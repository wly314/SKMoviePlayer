//
//  SKMovieFullScreenTitltBar.h
//  SKMoviePlayerDemo
//
//  Created by Leou on 16/6/2.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SKBackButtonHandler)(id obj);

@interface SKMovieFullScreenTitltBar : UIView

/** 返回按钮 */
@property (nonatomic, strong)UIButton *skBackFullControl;

/** 标题信息 */
@property (nonatomic, strong)UILabel  *skFullTitleLabel;

/** 返回方法 */
@property (nonatomic, copy)SKBackButtonHandler  skBackHandler;
/** 点击事件方法 */
- (void)addBackHandler:(SKBackButtonHandler)skBackHandler;

@end
