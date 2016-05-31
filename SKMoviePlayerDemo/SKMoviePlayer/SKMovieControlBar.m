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
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    _skPlayControl = [UIButton buttonWithType:UIButtonTypeCustom];
    _skPlayControl.backgroundColor = [UIColor clearColor];
    [_skPlayControl addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _skPlayControl.translatesAutoresizingMaskIntoConstraints = NO;
    [_skPlayControl setImage:[UIImage imageNamed:@"full_play_btn"] forState:UIControlStateNormal];
    [_skPlayControl setImage:[UIImage imageNamed:@"full_pause_btn"] forState:UIControlStateSelected];
    [self addSubview:_skPlayControl];
    [self constraintItem:_skPlayControl toItem:self topMultiplier:1 topConstant:5 bottomMultiplier:1 bottomConstant:-5 leftMultiplier:1 leftConstant:10 rightMultiplier:0 rightConstant:0 widthMultiplier:0 width:40 heightMultiplier:0 height:0];
}

- (void)playButtonClick:(UIButton *)aBtn {
    
    aBtn.selected = !aBtn.selected;
    
    if ([_delegate respondsToSelector:@selector(playOrPause:)]) {
        
        [_delegate playOrPause:aBtn];
    }
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
