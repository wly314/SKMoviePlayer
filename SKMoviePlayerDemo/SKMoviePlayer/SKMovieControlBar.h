//
//  SKMovieControlBar.h
//  SKMoviePlayerDemo
//
//  Created by Leou on 16/5/31.
//  Copyright © 2016年 Leou. All rights reserved.
//

/** 播放器控制菜单栏 **/

#import <UIKit/UIKit.h>

@protocol SKMovieControlBarDelegate;

@interface SKMovieControlBar : UIView

/** 播放暂停控制 */
@property (nonatomic, strong)UIButton *skPlayControl;

@property (nonatomic, assign)id<SKMovieControlBarDelegate> delegate;

@end


@protocol SKMovieControlBarDelegate <NSObject>

@optional
/** 播放按钮，点击播放或暂停 */
- (void)playOrPause:(UIButton *)aBtn;

@end