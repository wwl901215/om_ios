//
//  WhiteViewController.m
//  hybrid-demo
//
//  Created by syl on 2019/8/12.
//

#import "WhiteViewController.h"
#import <EnvHybrid/EnvHybridConstants.h>
#import "PublicDefine.h"
#import "Router.h"


@interface WhiteViewController ()

@end

@implementation WhiteViewController
- (instancetype)initWithRouterParams:(NSDictionary *) routerParams {
    self = [super init];
    if(self) {
        self.plistName = @"white-style";
        if(routerParams && [routerParams objectForKey:kExtraParams]) {
            self.pageParams = [routerParams objectForKey:kExtraParams];
            NSString *url = [routerParams objectForKey:kREALURL] ? [routerParams objectForKey:kREALURL] : [self.pageParams objectForKey:kURL];
            NSDictionary *extraParams = [routerParams objectForKey:kExtraParams];
            NSString *remote_server = [extraParams objectForKey:@"remote_server"];
            NSString *appServer = [[PublicDefine sharedInstance] getCurrentHost];
            if(remote_server.length){
                [extraParams setValue:@"http://192.168.1.3:8080" forKey:@"remote_server"];
            }
            if(url) {
                self.pageName = url;
                self.startPage = [[Router sharedRouter] pathForUrl:url withParams:routerParams];
            }
            [self setTabBarItem];
        }
        // 禁用自动根据navigationbar, statusbar 调整WebView的内容大小
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setStatusBarBackgroundColor:[UIColor whiteColor]];
    // 由于没有导航栏需要适配，使得webveiw从状态栏下面开始绘制
    if (@available(iOS 11.0, *)) {
        [self.webView.scrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void)setStatusBarBackgroundColor: (UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
        statusBar.tintColor = [UIColor blackColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
