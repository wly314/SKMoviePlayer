//
//  ViewController.m
//  SKMoviePlayerDemo
//
//  Created by Leou on 16/5/31.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import "ViewController.h"

#import "SKMoviePlayer.h"

@interface ViewController ()<SKMoviePlayerDelegate> {
    
    SKMoviePlayer *skMoviePlayer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    skMoviePlayer = [[SKMoviePlayer alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16) playerUrlPath:@"http://60.220.194.93/source.vickeynce.com/201605053fc0a48a3bf8e3da9365fd072e6b80fb.mp4?wsiphost=local"];
    skMoviePlayer.delegate = self;
    [self.view addSubview:skMoviePlayer];
    
    [skMoviePlayer setSkPlayerSize:CGSizeMake(self.view.bounds.size.width, 180)];
    skMoviePlayer.isCanDownload = NO;
    skMoviePlayer.skVideoTitle = @"你咋不叫我杀个人啊？";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
}

#pragma mark - 播放器代理
#pragma mark 懒加载代码
- (void)moviePlayer:(SKMoviePlayer *)aSkMoviePlayer fullScreenSwitchOrientation:(BOOL)isFull complection:(SKFullScreenCompletion)complection {
    
    if(isFull) {
        
        [self presentViewController:aSkMoviePlayer.skFullScreenVC animated:NO completion:^{
            
            [aSkMoviePlayer removeFromSuperview];
            [aSkMoviePlayer.skFullScreenVC.view addSubview:aSkMoviePlayer];
            
            aSkMoviePlayer.frame = [UIScreen mainScreen].bounds;
            complection(YES, [UIScreen mainScreen].bounds);
        }];
        
    }else {
        [aSkMoviePlayer.skFullScreenVC dismissViewControllerAnimated:NO completion:^{
            
            [aSkMoviePlayer removeFromSuperview];
            [self.view addSubview:aSkMoviePlayer];
            
            aSkMoviePlayer.frame = CGRectMake(0, 100, self.view.bounds.size.width, 240);
            complection(YES, CGRectMake(0, 100, self.view.bounds.size.width, 180));
        }];
    }
}

/** 视频播放结束 **/
- (void)moviePlayerVideoPlayEnd:(SKMoviePlayer *)aSkMoviePlayer {
    
    
}

- (void)dealloc {
    
    [skMoviePlayer removeFromSuperview];
    skMoviePlayer = nil;

}

@end
