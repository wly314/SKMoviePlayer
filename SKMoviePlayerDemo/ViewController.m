//
//  ViewController.m
//  SKMoviePlayerDemo
//
//  Created by Leou on 16/5/31.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import "ViewController.h"

#import "SKMoviePlayer.h"

@interface ViewController () {
    
    SKMoviePlayer *skMoviePlayer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    skMoviePlayer = [[SKMoviePlayer alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200) playerUrlPath:@"http://60.220.194.93/source.vickeynce.com/201605053fc0a48a3bf8e3da9365fd072e6b80fb.mp4?wsiphost=local"];
    [self.view addSubview:skMoviePlayer];
    
    [skMoviePlayer setSkPlayerSize:CGSizeMake(375, 200)];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
//    [skMoviePlayer setSkUrlString:@"http://60.220.194.93/source.vickeynce.com/201605053fc0a48a3bf8e3da9365fd072e6b80fb.mp4?wsiphost=local"];
}

- (void)dealloc {
    
    [skMoviePlayer removeFromSuperview];
    skMoviePlayer = nil;

}

@end
