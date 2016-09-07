# SKMoviePlayerDemo

### 使用方法：

```
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

    skMoviePlayer = [[SKMoviePlayer alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200) playerUrlPath:@"xxxx"];
    skMoviePlayer.delegate = self;
    [self.view addSubview:skMoviePlayer];
    
    [skMoviePlayer setSkPlayerSize:CGSizeMake(self.view.bounds.size.width, 200)];
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
            
            complection(YES, [UIScreen mainScreen].bounds);
        }];
        
    }else {
        [aSkMoviePlayer.skFullScreenVC dismissViewControllerAnimated:NO completion:^{
            
            [aSkMoviePlayer removeFromSuperview];
            [self.view addSubview:aSkMoviePlayer];
            complection(YES, CGRectMake(0, 100, self.view.bounds.size.width, 200));
        }];
    }
}

```

### 注意事项:
```
1.必须是addSubview添加播放器SKMoviePlayer。
2.播放器比例是16:9，创建的播放器时候可以根据比例设置宽高。

```
