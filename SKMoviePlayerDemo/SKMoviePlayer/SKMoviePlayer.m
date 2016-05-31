//
//  SKMoviePlayer.m
//  SKMoviePlayerDemo
//
//  Created by Leou on 16/5/31.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import "SKMoviePlayer.h"

@interface SKMoviePlayer ()<SKMovieControlBarDelegate> {
    
    /** 播放状态，手动控制。缓存播放完的时候可能会停止播放，通过监听状态，纪录状态，再次播放 **/
    BOOL        playStatus;//0 播放 1 停止
}

/** 播放器 */
@property (nonatomic, strong)AVPlayerItem           *skPlayerItem;

/** 时间格式器 **/
@property (nonatomic, strong)NSDateFormatter        *skDateFormatter;

/** 播放器控制器 **/
@property (nonatomic, strong)SKMovieControlBar      *skMovieControl;

@end

@implementation SKMoviePlayer

- (id)initWithFrame:(CGRect)frame playerUrlPath:(NSString *)urlString {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        /** 初始化播放容器 */
        _skContentView = [[UIView alloc] init];
        _skContentView.translatesAutoresizingMaskIntoConstraints = NO;
        _skContentView.backgroundColor = [UIColor blackColor];
        [self addSubview:_skContentView];
        
        [self constraintItem:_skContentView toItem:self topMultiplier:1 topConstant:0 bottomMultiplier:1 bottomConstant:0 leftMultiplier:1 leftConstant:0 rightMultiplier:1 rightConstant:0 widthMultiplier:0 width:0 heightMultiplier:0 height:0];
        
        if (urlString && urlString.length > 0) {
            
            _skUrlString = urlString;
            
            [self initPlayerView];
        }
    }
    
    return self;
}

- (void)setSkUrlString:(NSString *)skUrlString {
    
    /** 如果已经存在 需要替换AVPlayerItem */
    if (_skUrlString && _skUrlString.length > 0) {
        
        [self replacePlayerItem];
        
    }else {
        
        _skUrlString = skUrlString;
        
        [self initPlayerView];
    }
}

- (void)initPlayerView {
    
    _skPlayerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_skUrlString]];
    /** 监听status属性 */
    [_skPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    /** 监听loadedTimeRanges属性 */
    [_skPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    /** 缓冲没有了 */
    [_skPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    /** 监听缓存预测是否足够支持播放 */
    [_skPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    /** 添加视频播放结束通知 */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_skPlayerItem];
    
    /** 初始化播放器 */
    _skPlayer = [[AVPlayer alloc] initWithPlayerItem:_skPlayerItem];
    _skPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_skPlayer];
    _skPlayerLayer.frame = self.layer.bounds;
    [_skContentView.layer addSublayer:_skPlayerLayer];
    
    
    /** 设置播放器控制器 */
    _skMovieControl = [[SKMovieControlBar alloc] init];
    _skMovieControl.translatesAutoresizingMaskIntoConstraints = NO;
    _skMovieControl.delegate = self;
    [_skContentView addSubview:_skMovieControl];
    [self constraintItem:_skMovieControl toItem:_skContentView topMultiplier:0 topConstant:0 bottomMultiplier:1 bottomConstant:0 leftMultiplier:1 leftConstant:0 rightMultiplier:1 rightConstant:0 widthMultiplier:0 width:0 heightMultiplier:0 height:50];
}

- (void)setSkPlayerSize:(CGSize)skPlayerSize {
    
    CGRect rect = self.bounds;
    
    if (skPlayerSize.width >= rect.size.width || skPlayerSize.height >= rect.size.height) {
        
        return;
    }
    
    _skPlayerLayer.frame = CGRectMake((rect.size.width - skPlayerSize.width) / 2, (rect.size.height - skPlayerSize.height) / 2, skPlayerSize.width, skPlayerSize.height);
}

- (void)replacePlayerItem {
    
    /** 先移除当前AVPlayerItem监听 再设置AVPlayerItem 最后重新监听新的AVPlayerItem **/
    if (_skPlayerItem) {
        
        /** 先移除监听，再重新监听 **/
        [_skPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
        [_skPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
        [_skPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
        [_skPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_skPlayerItem];
    }
    
    _skPlayerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_skUrlString]];
    [_skPlayer replaceCurrentItemWithPlayerItem:_skPlayerItem];
    
    
    /** 监听status属性 */
    [_skPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    /** 监听loadedTimeRanges属性 */
    [_skPlayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    /** 缓冲没有了 */
    [_skPlayerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    /** 监听缓存预测是否足够支持播放 */
    [_skPlayerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    /** 添加视频播放结束通知 */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_skPlayerItem];
    
}

#pragma mark - 视频播放器监听
/** KVO方法 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            
            NSLog(@"AVPlayerStatusReadyToPlay");
            /** 获取视频总长度 */
            CMTime duration = _skPlayerItem.duration;
            /** 转换成秒 */
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;
            /** 转换成播放时间 */
            
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            /** 监听播放状态 */
            [self monitoringPlayback:_skPlayerItem];
            
        }else if ([playerItem status] == AVPlayerStatusFailed) {
            
            NSLog(@"AVPlayerStatusFailed");
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        /** 计算缓冲进度 */
        NSTimeInterval timeInterval = [self availableDuration];
        NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = _skPlayerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        
        if (_skPlayerItem.playbackBufferEmpty) {
            
            NSLog(@"缓冲没有了，暂停播放了");
            
            NSLog(@" %ld ===== %ld ", (long)_skPlayer.status, (long)_skPlayerItem.status);
            
            playStatus = YES;
        }
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        
        if (_skPlayerItem.playbackLikelyToKeepUp) {
            
            /** 预测播放缓冲区 可以支持播放 */
            if (playStatus && _skPlayerItem.status == AVPlayerStatusReadyToPlay) {
                
                [_skPlayer play];
            }
        }
    }
}

/** 播放状态监听 **/
- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    
    __weak typeof(self) weakSelf = self;
    [_skPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        
        /** 计算当前在第几秒 */
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;
        NSString *timeString = [weakSelf convertTime:currentSecond];
        NSLog(@"%@", timeString);
    }];
}

/** 缓冲进度计算 */
- (NSTimeInterval)availableDuration {
    
    NSArray *loadedTimeRanges = [[_skPlayer currentItem] loadedTimeRanges];
    /** 获取缓冲区域 */
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    /** 计算缓冲总进度 */
    NSTimeInterval resultTime = startSeconds + durationSeconds;
    
    
    return resultTime;
}

- (void)moviePlayDidEnd:(NSNotification *)notification {
   
    NSLog(@"Play end");
}

/** 播放时间转换 **/
- (NSString *)convertTime:(CGFloat)second {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    if (second/3600 >= 1) {
        
        [[self dateFormatter] setDateFormat:@"HH:mm:ss"];
    } else {
        [[self dateFormatter] setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [[self dateFormatter] stringFromDate:date];
    return showtimeNew;
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_skDateFormatter) {
        
        _skDateFormatter = [[NSDateFormatter alloc] init];
    }
    return _skDateFormatter;
}

#pragma mark - 控制器代理方法 播放或暂停
- (void)playOrPause:(UIButton *)aBtn {
    
    if (aBtn.selected) {
        
        [_skPlayer play];
    }else {
        
        [_skPlayer pause];
    }
}

#pragma mark -
- (void)dealloc {
    
    [_skPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
    [_skPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [_skPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
    [_skPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_skPlayerItem];
}

#pragma mark - 依赖于superView的约束
- (void)constraintCneterXOfItem:(id)view1 toItem:(id)view2 {
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:view1
                         attribute:NSLayoutAttributeCenterX
                         relatedBy:NSLayoutRelationEqual
                         toItem:view2
                         attribute:NSLayoutAttributeCenterX
                         multiplier:1
                         constant:0]];
}

- (void)constraintCneterYOfItem:(id)view1 toItem:(id)view2 {
    
    [self addConstraint:[NSLayoutConstraint
                         constraintWithItem:view1
                         attribute:NSLayoutAttributeCenterY
                         relatedBy:NSLayoutRelationEqual
                         toItem:view2
                         attribute:NSLayoutAttributeCenterY
                         multiplier:1
                         constant:0]];
}

- (void)constraintItem:(id)view1 toItem:(id)view2 topMultiplier:(CGFloat)topMultiplier topConstant:(CGFloat)top bottomMultiplier:(CGFloat)bottomMultiplier bottomConstant:(CGFloat)bottom leftMultiplier:(CGFloat)leftMultiplier leftConstant:(CGFloat)left rightMultiplier:(CGFloat)rightMultiplier rightConstant:(CGFloat)right widthMultiplier:(CGFloat)widthMultiplier width:(CGFloat)width heightMultiplier:(CGFloat)heightMultiplier height:(CGFloat)height {
    
    if (top != 0 || topMultiplier != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeTop
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeTop
                             multiplier:topMultiplier
                             constant:top]];
    }
    
    if (bottom != 0 || bottomMultiplier != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeBottom
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeBottom
                             multiplier:bottomMultiplier
                             constant:bottom]];
    }
    
    if (left != 0 || leftMultiplier != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeLeft
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeLeft
                             multiplier:leftMultiplier
                             constant:left]];
    }
    
    if (right != 0 || rightMultiplier != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeRight
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeRight
                             multiplier:rightMultiplier
                             constant:right]];
    }
    
    if (widthMultiplier != 0 || width != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeWidth
                             multiplier:widthMultiplier
                             constant:width]];
    }
    
    if (heightMultiplier != 0 || height != 0) {
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:view1
                             attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                             toItem:view2
                             attribute:NSLayoutAttributeHeight
                             multiplier:heightMultiplier
                             constant:height]];
    }
}

@end
