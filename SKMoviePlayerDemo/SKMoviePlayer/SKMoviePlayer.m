//
//  SKMoviePlayer.m
//  SKMoviePlayerDemo
//
//  Created by Leou on 16/5/31.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import "SKMoviePlayer.h"

@interface SKMoviePlayer () {
    
    /** 播放状态，手动控制。缓存播放完的时候可能会停止播放，通过监听状态，纪录状态，再次播放 **/
    BOOL                    playStatus;//0 播放 1 停止
    
    /** 载入视频小菊花 */
    UIActivityIndicatorView *loadActivityIndicator;
    
    /** 显示或者隐藏控制条 默认0显示 */
    BOOL                    showOrHidenControlBar;
    
    /** 主屏幕的播放按钮 **/
    UIButton                *mainPlayButton;
}

/** 播放器 */
@property (nonatomic, strong)AVPlayerItem           *skPlayerItem;

/** 时间格式器 **/
@property (nonatomic, strong)NSDateFormatter        *skDateFormatter;

/** 播放器控制器 **/
@property (nonatomic, strong)SKMovieControlBar      *skMovieControl;

/** 全屏播放器头部titleBar **/
@property (nonatomic, strong)SKMovieFullScreenTitltBar      *skMovieTitleBar;
/** 是否出现全屏返回title控制条 默认不出现NO，全屏成功的时候置为YES */
@property (nonatomic, assign)BOOL   isFullControlTitleBarShow;

@end

@implementation SKMoviePlayer

@synthesize skFullScreenVC = _skFullScreenVC;

- (id)initWithFrame:(CGRect)frame playerUrlPath:(NSString *)urlString {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        /** 初始化播放容器 */
        _skContentView = [[UIView alloc] init];
        _skContentView.translatesAutoresizingMaskIntoConstraints = NO;
        _skContentView.backgroundColor = [UIColor blackColor];
        [self addSubview:_skContentView];
        [self constraintItem:_skContentView toItem:self topMultiplier:1 topConstant:0 bottomMultiplier:1 bottomConstant:0 leftMultiplier:1 leftConstant:0 rightMultiplier:1 rightConstant:0 widthMultiplier:0 width:0 heightMultiplier:0 height:0];
        
        UIView *tapView = [[UIView alloc] init];
        tapView.translatesAutoresizingMaskIntoConstraints = NO;
        [_skContentView addSubview:tapView];
        [self constraintItem:tapView toItem:_skContentView topMultiplier:1 topConstant:0 bottomMultiplier:1 bottomConstant:0 leftMultiplier:1 leftConstant:0 rightMultiplier:1 rightConstant:0 widthMultiplier:0 width:0 heightMultiplier:0 height:0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideOrShow:)];
        [tapView addGestureRecognizer:tap];
        
        if (urlString && urlString.length > 0) {
            
            _skUrlString = urlString;
        }
        
        /** 初始化AVPlayerItem **/
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
        
        
        /** 主屏幕的播放按钮 **/
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_skContentView addSubview:playBtn];
        playBtn.backgroundColor = [UIColor clearColor];
        [playBtn setImage:[UIImage imageNamed:@"sk_play_fullscreen"] forState:UIControlStateNormal];
        [playBtn setImage:[UIImage imageNamed:@"sk_pause_fullscreen"] forState:UIControlStateHighlighted];
        [playBtn setImage:[UIImage imageNamed:@"sk_pause_fullscreen"] forState:UIControlStateSelected];
        [playBtn addTarget:self action:@selector(setupMoviePlayerAndPlay:) forControlEvents:UIControlEventTouchUpInside];
        [self constraintItem:playBtn toItem:_skContentView topMultiplier:0 topConstant:0 bottomMultiplier:0 bottomConstant:0 leftMultiplier:0 leftConstant:0 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:50 heightMultiplier:0 height:50];
        [self constraintCneterXOfItem:playBtn toItem:_skContentView];
        [self constraintCneterYOfItem:playBtn toItem:_skContentView];
        mainPlayButton = playBtn;
        /** 播放控制器 加载视频的动画 */
        [self initPlayerView];
    }
    
    return self;
}

#pragma mark - 属性或者其他基础信息
/** 视频未加载前的播放按钮 **/
- (void)setupMoviePlayerAndPlay:(UIButton *)aBtn {
    
    if (_skUrlString && _skUrlString.length > 0) {
        
        aBtn.selected = !aBtn.selected;
        
        aBtn.hidden = YES;
        [loadActivityIndicator startAnimating];
        [self replacePlayerItem];
    }else {
        
    }
}

- (void)setSkUrlString:(NSString *)skUrlString {
    
    /** 如果已经存在 需要替换AVPlayerItem */
    if (skUrlString && skUrlString.length > 0) {
        
        mainPlayButton.hidden = YES;
        [loadActivityIndicator startAnimating];
        
        _skUrlString = skUrlString;
        
        [_skPlayer pause];
        [_skPlayerLayer removeFromSuperlayer];
        _skPlayerLayer = nil;
        _skPlayer = nil;
        [_skMovieControl removeFromSuperview];
        _skMovieControl = nil;
        [_skMovieTitleBar removeFromSuperview];
        _skMovieTitleBar = nil;
        
        [self replacePlayerItem];
    }
}

- (void)setSkVideoTitle:(NSString *)skVideoTitle {
    
    _skVideoTitle = skVideoTitle;
    
    if (_skMovieTitleBar) {
        
        _skMovieTitleBar.skFullTitleLabel.text = _skVideoTitle;
    }
}

- (void)initPlayerView {
    
    /** 载入视频小菊花 */
    loadActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadActivityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [_skContentView addSubview:loadActivityIndicator];
    [self constraintItem:loadActivityIndicator toItem:_skContentView topMultiplier:0 topConstant:0 bottomMultiplier:0 bottomConstant:0 leftMultiplier:0 leftConstant:0 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:50 heightMultiplier:0 height:50];
    [self constraintCneterXOfItem:loadActivityIndicator toItem:_skContentView];
    [self constraintCneterYOfItem:loadActivityIndicator toItem:_skContentView];
    
    /** 改变圈圈的颜色 iOS5引入 */
    loadActivityIndicator.color = [UIColor redColor];
    [loadActivityIndicator setHidesWhenStopped:YES];
}

- (void)initControlBar {
    
    if (!_skMovieControl) {
        
        /** 设置播放器控制器 */
        _skMovieControl = [[SKMovieControlBar alloc] init];
        _skMovieControl.translatesAutoresizingMaskIntoConstraints = NO;
        _skMovieControl.backgroundColor = [UIColor clearColor];
        [_skContentView addSubview:_skMovieControl];
        [self constraintItem:_skMovieControl toItem:_skContentView topMultiplier:0 topConstant:0 bottomMultiplier:1 bottomConstant:0 leftMultiplier:1 leftConstant:0 rightMultiplier:1 rightConstant:0 widthMultiplier:0 width:0 heightMultiplier:0 height:30];
        _skMovieControl.skDownloadControl.hidden = !_isCanDownload;
        
        /** 添加各类点击事件 **/
        [self addAllTagetHandel];
    }
    
    if (!_skMovieTitleBar) {
        
        /** 初始化全屏的title控制器 *** 非全屏隐藏,初始化的时候要隐藏 ** */
        _skMovieTitleBar = [[SKMovieFullScreenTitltBar alloc] init];
        _skMovieTitleBar.translatesAutoresizingMaskIntoConstraints = NO;
        [_skContentView addSubview:_skMovieTitleBar];
        [self constraintItem:_skMovieTitleBar toItem:_skContentView topMultiplier:1 topConstant:0 bottomMultiplier:0 bottomConstant:0 leftMultiplier:1 leftConstant:0 rightMultiplier:1 rightConstant:0 widthMultiplier:0 width:0 heightMultiplier:0 height:30];
        _skMovieTitleBar.skFullTitleLabel.text = _skVideoTitle;
        _skMovieTitleBar.hidden = YES;
        
        /** 添加MovieTitleBar各类点击事件 **/
        [self addTitleBarAllTagetHandel];
    }
}

- (void)setSkPlayerSize:(CGSize)skPlayerSize {
    
    _skPlayerSize = skPlayerSize;
    
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
    
    /** 如果替换为stop作为地址 则不再播放 */
    if ([_skUrlString isEqualToString:@"stop"]) {
        
        return;
    }
    
    NSURL *url = (_skUrlFromLocal) ? ([NSURL fileURLWithPath:_skUrlString]) : ([NSURL URLWithString:_skUrlString]);
    _skPlayerItem = [AVPlayerItem playerItemWithURL:url];
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
    
    if (!_skPlayer) {
        
        /** 初始化播放器 */
        _skPlayer = [[AVPlayer alloc] initWithPlayerItem:_skPlayerItem];
        _skPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_skPlayer];
        
        _skPlayerLayer.frame = self.layer.bounds;
        [_skContentView.layer addSublayer:_skPlayerLayer];
        
        CGRect rect = self.bounds;
        if ((_skPlayerSize.width < rect.size.width && _skPlayerSize.height < rect.size.height) && (_skPlayerSize.width > 0 && _skPlayerSize.height > 0)) {
            
            _skPlayerLayer.frame = CGRectMake((rect.size.width - _skPlayerSize.width) / 2, (rect.size.height - _skPlayerSize.height) / 2, _skPlayerSize.width, _skPlayerSize.height);
        }
        
    }else {
        
        [_skPlayer replaceCurrentItemWithPlayerItem:_skPlayerItem];
    }
}

#pragma mark - 下载按钮控制
- (void)setIsCanDownload:(BOOL)isCanDownload {
    
    _isCanDownload = isCanDownload;
    if (isCanDownload) {
        
        _skMovieControl.skDownloadControl.hidden = NO;
    }else {
        
        _skMovieControl.skDownloadControl.hidden = YES;
    }
}

#pragma mark - 视频播放器监听
/** KVO方法 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            
            [loadActivityIndicator stopAnimating];
            [self initControlBar];
            [_skPlayer play];
            _skMovieControl.skPlayControl.selected = YES;
            
            /** 转成秒 */
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;
            /** 转换成播放时间 */
            NSString *totalTimeStr = [self convertTime:totalSecond];
            _skMovieControl.skTotalTimeLabel.text = totalTimeStr;
            /** 设置slider最大value */
            _skMovieControl.skTotalTimeValue = totalSecond;
            
            /** 监听播放状态 */
            [self monitoringPlayback:_skPlayerItem];
            
        }else if ([playerItem status] == AVPlayerStatusFailed) {
            
            /** 加载失败 **/
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
        /** 计算缓冲进度 */
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = _skPlayerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        _skMovieControl.skCurrentProgress = timeInterval / totalDuration;
        
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
        
        if (_skPlayerItem.playbackBufferEmpty) {
            
            playStatus = YES;
            self.skMovieControl.skPlayControl.selected = NO;
        }
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        
        if (_skPlayerItem.playbackLikelyToKeepUp) {
            
            /** 预测播放缓冲区 可以支持播放 */
            if (playStatus && _skPlayerItem.status == AVPlayerStatusReadyToPlay) {
                
                [_skPlayer play];
                self.skMovieControl.skPlayControl.selected = YES;
                
                playStatus = NO;
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
        
        weakSelf.skMovieControl.skCurrentTimeLabel.text = timeString;
        /** 设置slider当前value */
        weakSelf.skMovieControl.skCurrentTimeValue = currentSecond;
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
    
    [_skPlayer seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
        self.skMovieControl.skPlayControl.selected = NO;
    }];
    
    if ([_delegate respondsToSelector:@selector(moviePlayerVideoPlayEnd:)]) {
        
        [_delegate moviePlayerVideoPlayEnd:self];
    }
}

/** 播放时间转换 **/
- (NSString *)convertTime:(CGFloat)second {
    
    int mm = (int)second/60;
    int ss = (int)second%60;
    
    NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d", mm, ss];
    
    return timeStr;
    
//    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:second];
//    if (second/3600 >= 1) {
//        
//        [[self dateFormatter] setDateFormat:@"mm:ss"];
//    } else {
//        [[self dateFormatter] setDateFormat:@"mm:ss"];
//    }
//    NSString *showtimeNew = [[self dateFormatter] stringFromDate:date];
//    return showtimeNew;
}

- (NSDateFormatter *)dateFormatter {
    
    if (!_skDateFormatter) {
        
        _skDateFormatter = [[NSDateFormatter alloc] init];
    }
    return _skDateFormatter;
}

#pragma mark - 控制器代理方法 播放或暂停
- (void)addAllTagetHandel {
    
    /** 避免循环引用 **/
    __weak typeof(self)weakSelf = self;
    
    /** 播放或暂停 */
    [_skMovieControl addPlayOrPauseHandler:^(id obj) {
        
        UIButton *btn = (UIButton *)obj;
        
        if (btn.selected) {
            
            [weakSelf.skPlayer play];
        }else {
            [weakSelf.skPlayer pause];
        }
    }];
    
    /** 全屏操作 */
    [_skMovieControl addFullScreenHandler:^(id obj) {
        
        [weakSelf fullScreenSwitch:obj];
        
    }];
    
    /** 点击播放进度 */
    [_skMovieControl addTapVideoValueHandler:^(id obj, NSInteger value) {
       
        [weakSelf tapToPlayerAtTime:value];
    }];
    
    /** 拖拽播放进度 **/
    [_skMovieControl addDragVideoValueHandler:^(id obj, NSInteger value) {
        
        [weakSelf dragToPlayerAtTime:value];
    }];;
    
    /** 视频下载 */
    [_skMovieControl addDownloadHandler:^(id obj) {
        
        [weakSelf downloadVideo:obj];
    }];;
}

/** TitleBar的事件 */
- (void)addTitleBarAllTagetHandel {
    
    __weak typeof(self)weakSelf = self;
    [_skMovieTitleBar addBackHandler:^(id obj) {
        
        /** 这里直接使用了全屏按钮的事件，所以：1.设置全屏按钮的selected 2.并要将全屏按钮传过去 */
        weakSelf.skMovieControl.skFullControl.selected = !weakSelf.skMovieControl.skFullControl.selected;
        [weakSelf fullScreenSwitch:weakSelf.skMovieControl.skFullControl];
    }];
}

/** 直接设置全屏状态：即在播放的时候就是全屏 */
- (void)toFullScreentWhenStart:(SKMoviePlayer *)skMoviePlayer {
    
    /** 全屏的时候 先手动创建一个控制bar 然后将全屏按钮置为选中状态 出现titleBar */
    [self initControlBar];
    skMoviePlayer.skMovieControl.skFullControl.selected = YES;
//    self.isFullControlTitleBarShow = YES;
//    _skPlayerLayer.frame = CGRectMake(0, 0, skMoviePlayer.width, skMoviePlayer.height);
    [self fullScreenSwitch:skMoviePlayer.skMovieControl.skFullControl];
}

/** 全屏回调方法回调，外部控制使用页面跳转的方式 **/
- (void)fullScreenSwitch:(id)obj {
    
    UIButton *btn = (UIButton *)obj;
    /** 避免循环引用 **/
    __weak typeof(self)weakSelf = self;
    
    if ([_delegate respondsToSelector:@selector(moviePlayer:fullScreenSwitchOrientation: complection:)]) {
        
        [_delegate moviePlayer:weakSelf fullScreenSwitchOrientation:btn.selected complection:^(BOOL isComplection, CGRect layerFrame){
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                _skPlayerLayer.frame = CGRectMake(0, 0, layerFrame.size.width, layerFrame.size.height);
                
            } completion:nil];
            
            if (btn.selected) {
                
                /** 切换layer大小。注意：当全屏的时候，要将_isFullControlTitleBarShow置为YES，切换回非全屏的时候置为NO，用self.调用  **/
                if (isComplection) {
                    
                    self.isFullControlTitleBarShow = YES;
                    
                }else {
                    self.isFullControlTitleBarShow = NO;
                }
            }else {
                
                if (isComplection) {
                    
                    self.isFullControlTitleBarShow = NO;
                    
                }else {
                    
                    self.isFullControlTitleBarShow = YES;
                }
            }
        }];
    }
}

/** 点击拖拽进度的方法 */
- (void)tapToPlayerAtTime:(NSInteger)time {
    
    CMTime toTime = CMTimeMakeWithSeconds(time, _skPlayerItem.currentTime.timescale);
    [_skPlayer seekToTime:toTime completionHandler:^(BOOL finished) {
        
        self.skMovieControl.skPlayControl.selected = YES;
        [_skPlayer play];
    }];
}

/** 拖拽播放进度的方法 */
- (void)dragToPlayerAtTime:(NSInteger)time {
    
    CMTime toTime = CMTimeMakeWithSeconds(time, _skPlayerItem.currentTime.timescale);
    [_skPlayer seekToTime:toTime completionHandler:^(BOOL finished) {
        
        self.skMovieControl.skPlayControl.selected = YES;
        [_skPlayer play];
    }];
}

/** 视频下载 */
- (void)downloadVideo:(UIButton *)aBtn {
    
    __weak typeof(self)weakSelf = self;
    if ([_delegate respondsToSelector:@selector(moviePlayer:videoDownloaded:)]) {
        
        [_delegate moviePlayer:weakSelf videoDownloaded:^(BOOL isDownloaded) {
           
            /** 视频是否下载了 **/
        }];
    }
}

#pragma mark - 外部代码操作控制播放暂停
/** 暂停 */
- (void)pause {
    
    [_skPlayer pause];
    _skMovieControl.skPlayControl.selected = NO;
}

/** 播放 */
- (void)play {
    
    [_skPlayer play];
    _skMovieControl.skPlayControl.selected = YES;
}

#pragma mark - 懒加载代码 全屏操作－创建全屏视图控制器
- (void)setSkFullScreenVC:(SKFullScreenViewController *)skFullScreenVC {
    
    _skFullScreenVC = skFullScreenVC;
}

- (SKFullScreenViewController *)skFullScreenVC {
    
    if (!_skFullScreenVC) {
        
        _skFullScreenVC = [[SKFullScreenViewController alloc] init];
    }
    
    return _skFullScreenVC;
}

#pragma mark - 隐藏或显示控制器
- (void)setIsFullControlTitleBarShow:(BOOL)isFullControlTitleBarShow {
    
    _isFullControlTitleBarShow = isFullControlTitleBarShow;
    
    _skMovieTitleBar.hidden = !_isFullControlTitleBarShow;
}

/** 隐藏或显示控制器 **/
- (void)tapHideOrShow:(id)obj {
    
    showOrHidenControlBar = !showOrHidenControlBar;
    
    _skMovieControl.hidden = showOrHidenControlBar;
    
    if (_isFullControlTitleBarShow) {
        
        _skMovieTitleBar.hidden = showOrHidenControlBar;
    }
}

#pragma mark -
- (void)dealloc {
    
    [_skPlayerItem removeObserver:self forKeyPath:@"status" context:nil];
    [_skPlayerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [_skPlayerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
    [_skPlayerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_skPlayerItem];
    
    [_skPlayer pause];
    [_skPlayerLayer removeFromSuperlayer];
    [_skMovieControl removeFromSuperview];
    [_skMovieTitleBar removeFromSuperview];
    _skPlayer = nil;
    _skPlayerLayer = nil;
    _skPlayerItem = nil;
    _skMovieTitleBar = nil;
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
