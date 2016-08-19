//
//  SKMovieControlBar.m
//  SKMoviePlayerDemo
//
//  Created by Leou on 16/5/31.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import "SKMovieControlBar.h"

@implementation SKMovieControlBar

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        /** 半透明灰色背景 */
        UIView *alphaBgView = [[UIView alloc] init];
        alphaBgView.translatesAutoresizingMaskIntoConstraints = NO;
        alphaBgView.backgroundColor = [UIColor blackColor];
        alphaBgView.alpha = 0.4;
        alphaBgView.userInteractionEnabled = YES;
        [self addSubview:alphaBgView];
        [self constraintItem:alphaBgView toItem:self topMultiplier:1 topConstant:0 bottomMultiplier:1 bottomConstant:0 leftMultiplier:1 leftConstant:0 rightMultiplier:1 rightConstant:0 widthMultiplier:0 width:0 heightMultiplier:0 height:0];
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    _skPlayControl = [UIButton buttonWithType:UIButtonTypeCustom];
    _skPlayControl.backgroundColor = [UIColor clearColor];
    [_skPlayControl addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _skPlayControl.translatesAutoresizingMaskIntoConstraints = NO;
    [_skPlayControl setImage:[UIImage imageNamed:@"sk_normal_play"] forState:UIControlStateNormal];
    [_skPlayControl setImage:[UIImage imageNamed:@"sk_normal_pause"] forState:UIControlStateSelected];
    [self addSubview:_skPlayControl];
    [self constraintItem:_skPlayControl toItem:self topMultiplier:1 topConstant:5 bottomMultiplier:1 bottomConstant:-5 leftMultiplier:1 leftConstant:20 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:20 heightMultiplier:0 height:0];
    
    _skFullControl = [UIButton buttonWithType:UIButtonTypeCustom];
    _skFullControl.backgroundColor = [UIColor clearColor];
    [_skFullControl addTarget:self action:@selector(fullScreenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _skFullControl.translatesAutoresizingMaskIntoConstraints = NO;
    [_skFullControl setImage:[UIImage imageNamed:@"sk_normal_full"] forState:UIControlStateNormal];
    [_skFullControl setImage:[UIImage imageNamed:@"sk_full_normal"] forState:UIControlStateSelected];
    [self addSubview:_skFullControl];
    [self constraintItem:_skFullControl toItem:self topMultiplier:1 topConstant:5 bottomMultiplier:1 bottomConstant:-5 leftMultiplier:0 leftConstant:0 rightMultiplier:1 rightConstant:-20 widthMultiplier:0 width:20 heightMultiplier:0 height:0];
    
    _skDownloadControl = [UIButton buttonWithType:UIButtonTypeCustom];
    [_skDownloadControl setImage:[UIImage imageNamed:@"sk_full_dowload"] forState:UIControlStateNormal];
    [_skDownloadControl setImage:[UIImage imageNamed:@"sk_full_dowload"] forState:UIControlStateSelected];
    _skDownloadControl.translatesAutoresizingMaskIntoConstraints = NO;
    [_skDownloadControl addTarget:self action:@selector(downloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_skDownloadControl];
    [self constraintItem:_skDownloadControl toItem:self topMultiplier:1 topConstant:5 bottomMultiplier:1 bottomConstant:-5 leftMultiplier:0 leftConstant:0 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:20 heightMultiplier:0 height:0];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_skDownloadControl attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_skFullControl attribute:NSLayoutAttributeLeft multiplier:1 constant:-10]];
    
    _skCurrentTimeLabel = [[UILabel alloc] init];
    _skCurrentTimeLabel.text = @"00:00";
    _skCurrentTimeLabel.backgroundColor = [UIColor clearColor];
    _skCurrentTimeLabel.textColor = [UIColor whiteColor];
    _skCurrentTimeLabel.textAlignment = NSTextAlignmentCenter;
    _skCurrentTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    _skCurrentTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_skCurrentTimeLabel];
    [self constraintItem:_skCurrentTimeLabel toItem:self topMultiplier:1 topConstant:5 bottomMultiplier:1 bottomConstant:-5 leftMultiplier:0 leftConstant:0 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:50 heightMultiplier:0 height:0];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_skCurrentTimeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_skPlayControl attribute:NSLayoutAttributeRight multiplier:1 constant:5]];
    
    _skTotalTimeLabel = [[UILabel alloc] init];
    _skTotalTimeLabel.text = @"000:00";
    _skTotalTimeLabel.backgroundColor = [UIColor clearColor];
    _skTotalTimeLabel.textColor = [UIColor whiteColor];
    _skTotalTimeLabel.textAlignment = NSTextAlignmentCenter;
    _skTotalTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    _skTotalTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_skTotalTimeLabel];
    [self constraintItem:_skTotalTimeLabel toItem:self topMultiplier:1 topConstant:5 bottomMultiplier:1 bottomConstant:-5 leftMultiplier:0 leftConstant:0 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:50 heightMultiplier:0 height:0];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_skTotalTimeLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_skDownloadControl attribute:NSLayoutAttributeLeft multiplier:1 constant:-5]];

    /** 缓冲进度条 */
    skVideoProgress = [[UIProgressView alloc] init];
    skVideoProgress.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:skVideoProgress];
    [self constraintItem:skVideoProgress toItem:self topMultiplier:0 topConstant:0 bottomMultiplier:0 bottomConstant:0 leftMultiplier:0 leftConstant:0 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:0 heightMultiplier:0 height:2];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:skVideoProgress attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_skTotalTimeLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:skVideoProgress attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_skCurrentTimeLabel attribute:NSLayoutAttributeRight multiplier:1 constant:5]];
    [self constraintCneterYOfItem:skVideoProgress toItem:self];
    
    /** 播放进度条 **/
    skBardurationSlider = [[UISlider alloc] init];
    skBardurationSlider.backgroundColor = [UIColor clearColor];
    skBardurationSlider.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:skBardurationSlider];
    [self constraintItem:skBardurationSlider toItem:self topMultiplier:1 topConstant:5 bottomMultiplier:1 bottomConstant:-5 leftMultiplier:0 leftConstant:0 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:0 heightMultiplier:0 height:0];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:skBardurationSlider attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_skTotalTimeLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:skBardurationSlider attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_skCurrentTimeLabel attribute:NSLayoutAttributeRight multiplier:1 constant:5]];
    
    UIImage *thumbImage = [UIImage imageNamed:@"sk_play_current_point.png"];
    [skBardurationSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [skBardurationSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    /** 通俗的讲：已走进度颜色 */
    [skBardurationSlider setMinimumTrackImage:[UIImage imageNamed:@"sk_play_timelinefull"] forState:UIControlStateNormal];
    [skBardurationSlider setMaximumTrackImage:[UIImage imageNamed:@"sk_play_timeline"] forState:UIControlStateNormal];
    skBardurationSlider.minimumValue = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapThumb:)];
    [skBardurationSlider addGestureRecognizer:tap];
    
    [skBardurationSlider addTarget:self action:@selector(trackThumb:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)playButtonClick:(UIButton *)aBtn {
    
    aBtn.selected = !aBtn.selected;
    
    if (_skPlayOrPauseHandler) {
        
        _skPlayOrPauseHandler(aBtn);
    }
}

- (void)fullScreenButtonClick:(UIButton *)aBtn {
    
    aBtn.selected = !aBtn.selected;
    
    if (_skFullScreenHandler) {
        
        _skFullScreenHandler(aBtn);
    }
}

#pragma mark - 缓存
- (void)setSkCurrentProgress:(CGFloat)skCurrentProgress {
    
    _skCurrentProgress = skCurrentProgress;
    
    [skVideoProgress setProgress:skCurrentProgress animated:YES];
}

#pragma mark - Slider属性
- (void)setSkTotalTimeValue:(NSInteger)skTotalTimeValue {
    
    _skTotalTimeValue = skTotalTimeValue;
    
    skBardurationSlider.maximumValue = skTotalTimeValue;
}

- (void)setSkCurrentTimeValue:(NSInteger)skCurrentTimeValue {
    
    _skCurrentTimeValue = skCurrentTimeValue;
    
    skBardurationSlider.value = skCurrentTimeValue;
}

#pragma mark Slider事件
/** 点击事件 */
- (void)tapThumb:(UITapGestureRecognizer *)tap {
    
    UISlider *aSlider = (UISlider *)tap.view;
    
    if (_skTapVideoValue) {
        
        /** 得到当前点击的值 */
        CGPoint point = [tap locationInView:aSlider];
        NSInteger currentValue = (NSInteger)(point.x/aSlider.bounds.size.width * aSlider.maximumValue);
        
        [aSlider setValue:currentValue animated:YES];
        
        _skTapVideoValue(aSlider, currentValue);
    }
}

/** 拖拽事件 */
- (void)trackThumb:(UISlider *)aSlider {
    
    if (_skDragVideoValue) {
        
        [aSlider setValue:aSlider.value animated:YES];
        
        NSInteger currentTime = (NSInteger)aSlider.value;
        
        _skDragVideoValue(aSlider, currentTime);
    }
}

#pragma mark - 下载事件
- (void)downloadButtonClick:(UIButton *)aBtn {
    
    if (_skDownloadHandler) {
        
        _skDownloadHandler(aBtn);
    }
}

#pragma mark - 添加事件
/** 播放暂停 **/
- (void)addPlayOrPauseHandler:(SKButtonHandler)skPlayOrPauseHandler {
    
    _skPlayOrPauseHandler = skPlayOrPauseHandler;
}

- (void)setSkPlayOrPauseHandler:(SKButtonHandler)skPlayOrPauseHandler {
    
    _skPlayOrPauseHandler = skPlayOrPauseHandler;
}

/** 全屏操作 **/
- (void)addFullScreenHandler:(SKButtonHandler)skFullScreenHandler {
    
    _skFullScreenHandler = skFullScreenHandler;
}

- (void)setSkFullScreenHandler:(SKButtonHandler)skFullScreenHandler {
    
    _skFullScreenHandler = skFullScreenHandler;
}

/** 点击进度 */
- (void)setSkTapVideoValue:(SKSliderHandler)skTapVideoValue {
    
    _skTapVideoValue = skTapVideoValue;
}

- (void)addTapVideoValueHandler:(SKSliderHandler)skTapVideoValue {
    
    _skTapVideoValue = skTapVideoValue;
}

/** 拖拽进度 */
- (void)setSkDragVideoValue:(SKSliderHandler)skDragVideoValue {
    
    _skDragVideoValue = skDragVideoValue;
}

- (void)addDragVideoValueHandler:(SKSliderHandler)skDragVideoValue {
    
    _skDragVideoValue = skDragVideoValue;
}

/** 视频下载方法 */
- (void)setSkDownloadHandler:(SKButtonHandler)skDownloadHandler {
    
    _skDownloadHandler = skDownloadHandler;
}

- (void)addDownloadHandler:(SKButtonHandler)skDownloadHandler {
    
    _skDownloadHandler = skDownloadHandler;
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
