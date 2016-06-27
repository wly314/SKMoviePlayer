//
//  SKMovieFullScreenTitltBar.m
//  SKMoviePlayerDemo
//
//  Created by Leou on 16/6/2.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import "SKMovieFullScreenTitltBar.h"

@implementation SKMovieFullScreenTitltBar

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
    
    _skBackFullControl = [UIButton buttonWithType:UIButtonTypeCustom];
    _skBackFullControl.backgroundColor = [UIColor clearColor];
    [_skBackFullControl addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _skBackFullControl.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *nbackImgs = [UIImage imageNamed:@"full_return"];
    [_skBackFullControl setImage:nbackImgs forState:UIControlStateNormal];
    [_skBackFullControl setImage:nbackImgs forState:UIControlStateSelected];
    [self addSubview:_skBackFullControl];
    [self constraintItem:_skBackFullControl toItem:self topMultiplier:0 topConstant:0 bottomMultiplier:0 bottomConstant:0 leftMultiplier:1 leftConstant:10 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:(nbackImgs.size.width*2+10) heightMultiplier:0 height:(nbackImgs.size.height)];
    [self constraintCneterYOfItem:_skBackFullControl toItem:self];
    
    _skFullTitleLabel = [[UILabel alloc] init];
    _skFullTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _skFullTitleLabel.textColor = [UIColor whiteColor];
    _skFullTitleLabel.backgroundColor = [UIColor clearColor];
    _skFullTitleLabel.alpha = 0.9;//变成弱白色
    _skFullTitleLabel.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:_skFullTitleLabel];
    [self constraintItem:_skFullTitleLabel toItem:self topMultiplier:1 topConstant:5 bottomMultiplier:1 bottomConstant:-5 leftMultiplier:0 leftConstant:0 rightMultiplier:1 rightConstant:-20 widthMultiplier:0 width:0 heightMultiplier:0 height:0];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_skFullTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_skBackFullControl attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
}

/** 返回按钮被点击了 */
- (void)backButtonClick:(UIButton *)aBtn {
    
    if (_skBackHandler) {
        
        _skBackHandler(aBtn);
    }
}

/** 返回方法 */
- (void)setSkBackHandler:(SKBackButtonHandler)skBackHandler {
    
    _skBackHandler = skBackHandler;
}
/** 点击事件方法 */
- (void)addBackHandler:(SKBackButtonHandler)skBackHandler {
    
    _skBackHandler = skBackHandler;
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
