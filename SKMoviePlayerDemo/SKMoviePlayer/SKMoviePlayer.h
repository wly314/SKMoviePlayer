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

@interface SKMoviePlayer : UIView

/** playerUrlPath: 视频地址 逻辑：只有设置了url之后，才能够初始化播放器 **/
- (id)initWithFrame:(CGRect)frame playerUrlPath:(NSString *)urlString;

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

@end
