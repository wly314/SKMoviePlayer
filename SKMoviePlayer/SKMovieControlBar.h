//
//  SKMovieControlBar.h
//  SKMoviePlayerDemo
//
//  Created by Leou on 16/5/31.
//  Copyright © 2016年 Leou. All rights reserved.
//

/** 播放器控制菜单栏 **/

#import <UIKit/UIKit.h>

/** 回调绑定, id obj是将自身传过去，传过去之后可以用来调用该类的方法 */
typedef void (^SKButtonHandler)(id obj);

/** value:当前value(要播放的时间点)传过去 */
typedef void (^SKSliderHandler)(id obj, NSInteger value);

@interface SKMovieControlBar : UIView {
    
    /** 播放控制条 */
    UISlider        *skBardurationSlider;
    
    /** 缓冲进度条 */
    UIProgressView  *skVideoProgress;
}

/** 播放暂停控制按钮 */
@property (nonatomic, strong)UIButton *skPlayControl;

/** 全屏控制按钮 */
@property (nonatomic, strong)UIButton *skFullControl;

/** 下载控制按钮 */
@property (nonatomic, strong)UIButton *skDownloadControl;

/** 当前播放时间 */
@property (nonatomic, strong)UILabel  *skCurrentTimeLabel;

/** 视频总播放时间 */
@property (nonatomic, strong)UILabel  *skTotalTimeLabel;

/** 视频总播放时间，可以用于设置slider的最大值 */
@property (nonatomic, assign)NSInteger skTotalTimeValue;
@property (nonatomic, assign)NSInteger skCurrentTimeValue;
/** 当前缓存 */
@property (nonatomic, assign)CGFloat   skCurrentProgress;

/** 播放或暂停 */
@property (nonatomic, copy)SKButtonHandler  skPlayOrPauseHandler;
/** 点击事件方法 */
- (void)addPlayOrPauseHandler:(SKButtonHandler)skPlayOrPauseHandler;

/** 全屏幕 */
@property (nonatomic, copy)SKButtonHandler  skFullScreenHandler;
/** 点击事件方法 */
- (void)addFullScreenHandler:(SKButtonHandler)skFullScreenHandler;

/** 点击播放进度 */
@property (nonatomic, copy)SKSliderHandler  skTapVideoValue;
/** 点击进度 */
- (void)addTapVideoValueHandler:(SKSliderHandler)skTapVideoValue;

/** 拖拽播放进度 */
@property (nonatomic, copy)SKSliderHandler  skDragVideoValue;
/** 拖拽进度 */
- (void)addDragVideoValueHandler:(SKSliderHandler)skDragVideoValue;

/** 视频下载 */
@property (nonatomic, copy)SKButtonHandler  skDownloadHandler;
/** 视频下载方法 */
- (void)addDownloadHandler:(SKButtonHandler)skDownloadHandler;

@end
