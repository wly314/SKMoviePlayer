//
//  SKMoviePlayer.h
//  SKMoviePlayerDemo
//
//  Created by Leou on 16/5/31.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import "SKMovieControlBar.h"//播放器控制条
/** 全屏视图控制器 */
#import "SKFullScreenViewController.h"

/** 用于回调是否全屏已经完成,通过判断处理AVPlayer的layer大小 **/
typedef void (^SKFullScreenCompletion)(BOOL isComplection);
/** 用于回调是否该视频已经下载 **/
typedef void (^SKFullDownloaded)(BOOL isDownloaded);

@protocol SKMoviePlayerDelegate;

@interface SKMoviePlayer : UIView

/** playerUrlPath: 视频地址 逻辑：只有设置了url之后，才能够初始化播放器 **/
- (id)initWithFrame:(CGRect)frame playerUrlPath:(NSString *)urlString;

@property (nonatomic, assign)id<SKMoviePlayerDelegate> delegate;

@property (nonatomic, strong)NSString           *skUrlString;

/** 播放器容器: 视频播放器，控制器 */
@property (nonatomic, readonly, strong)UIView   *skContentView;

/** 播放器 */
@property (nonatomic, strong)AVPlayer           *skPlayer;

// 播放器的Layer
@property (weak, nonatomic)AVPlayerLayer        *skPlayerLayer;

/** 播放器的大小：可以外部设置大小，不可超过容器大小 */
@property (nonatomic, assign)CGSize             skPlayerSize;

/** 暂停 */
- (void)pause;

/** 播放 */
- (void)play;

/** 全屏视图 逻辑:通过SKFullScreenViewController创建全屏视图 **/
@property (nonatomic, readonly, strong)SKFullScreenViewController *skFullScreenVC;

/** 是否可以下载，下载按钮是否隐藏 */
@property (nonatomic, assign)BOOL  isCanDownload;

@end


/** 代理方法 **/
@protocol SKMoviePlayerDelegate <NSObject>

@optional
/** isFull ：是否屏幕 */
- (void)moviePlayer:(SKMoviePlayer *)aSkMoviePlayer fullScreenSwitchOrientation:(BOOL)isFull complection:(SKFullScreenCompletion)complection;

/** 视频下载 downloaded:视频已经下载过了／正在下载 */
- (void)moviePlayer:(SKMoviePlayer *)aSkMoviePlayer videoDownloaded:(SKFullDownloaded)downloaded;

@end

