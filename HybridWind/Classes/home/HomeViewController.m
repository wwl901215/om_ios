//
//  HomeViewController.m
//  EnvHyrbidDemo
//
//  Created by MinBaby on 2018/3/15.
//

#import "HomeViewController.h"
#import "SlideMenu.h"
#import "LeftMenuViewController.h"
#import "UIViewController+SlideMenu.h"
#import "EnvWebViewController.h"
#import "UINavigationController+EnvHybrid.h"
#import "Router.h"
#import <EnvHybrid/EnvHybridConstants.h>
#import "EnvStyleParser.h"
#import "UIColor+Hex.h"
#import "EnvIconFont.h"
#import "CoverView.h"
#import "MenuViewController.h"
#import "MenuService.h"
#import "Persistent.h"
#import "PublicDefine.h"
#import "AppDelegate.h"
#import "MenuService.h"
#import "EnvAppData.h"
#import "SessionService.h"
#import "BlueViewController.h"
#import "WhiteViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) NSDictionary *pageParams;
@property (nonatomic, strong) UIView *cover;
@property (nonatomic, strong) NSArray *menuList;

@end

@implementation HomeViewController
- (instancetype)initWithRouterParams:(NSDictionary *) routerParams {
    self = [super init];
    if(self) {
        if(routerParams && [routerParams objectForKey:kExtraParams]) {
            self.pageParams = [routerParams objectForKey:kExtraParams];
            NSString *url = [routerParams objectForKey:kREALURL] ? [routerParams objectForKey:kREALURL] : [self.pageParams objectForKey:kURL];
            NSDictionary *extraParams = [routerParams objectForKey:kExtraParams];
            NSString *remote_server = [extraParams objectForKey:@"remote_server"];
            NSString *appServer = [[PublicDefine sharedInstance] getCurrentHost];
            if(remote_server.length){
                [extraParams setValue:appServer forKey:@"remote_server"];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self getNavigationBarLeftButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WebViewDidDisappear:) name:CDVViewDidDisappearNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WebViewDidDisappear:) name:CDVViewDidDisappearNotification object:nil];
    DDLogDebug(@"home--viewWillAppear");
}

- (void)viewWillDisappear:(BOOL)animated{
    DDLogDebug(@"home--viewWillDisappear");
}

- (UIBarButtonItem* )getNavigationBarLeftButton {
    UIBarButtonItem *barButtonItem = [self naviBarButtonItem: @"\ue92d" withAction:@selector(showLeft) target:self];
    return barButtonItem;
}

- (UIBarButtonItem *)naviBarButtonItem:(NSString *)iconfont withAction:(SEL)action target:(id) target {
    UIView *barButtonView = [[UIView alloc]init];
    barButtonView.frame =CGRectMake(0, 0, 25, 25);
//    barButtonView.backgroundColor = [UIColor redColor];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(0, 0, 25, 25);
    UILabel *label = [[UILabel alloc] init];
    
    NSString *iconColor = [[EnvStyleParser sharedParser] navigationBarIconColor];
    CGFloat iconSize = [[EnvStyleParser sharedParser] navigationBarIconSize];
    
    NSString * iconFontName = [[EnvIconFont sharedIconFont] iconFontName];
    UIFont *font = [UIFont fontWithName:iconFontName size:iconSize];
    [label setFont:font];
    // 判断是icon font
    if(iconfont.length ==1 && [iconfont characterAtIndex:0] > 4096){
        [label setText: iconfont];
    }else{
        [label setText: iconfont];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 0, 25, 25);
    [label setTextColor:[UIColor colorWithCSS:iconColor]];
    [barButtonView addSubview:label];
    [barButtonView addSubview:btn];
    
    //[btn setShowsTouchWhenHighlighted:YES];
    //[btn setBackgroundImage:[UIImage imageWithColor: [UIColor redColor]] forState:UIControlStateHighlighted];
    if ([iconfont isEqualToString:@""] || iconfont == nil) {
        //        [btn addTarget:target action:nil forControlEvents:UIControlEventTouchUpInside];
    }else {
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:barButtonView];
    return barBtn;
    
}

- (void)WebViewDidDisappear:(NSNotification *)notification {
    if (self.navigationController.childViewControllers.count > 0) {
        NSArray *vcs = self.navigationController.childViewControllers;
        if (vcs.count > 2) {
            UIViewController *vc = vcs[vcs.count-2];
            UIViewController *lastVC =vcs.lastObject;
            if ([lastVC isMemberOfClass:[vc class]] && !([vc isMemberOfClass:[WhiteViewController class]] || [vc isMemberOfClass:[BlueViewController class]] || [vc isMemberOfClass:[EnvWebViewController class]])) {
                [vc removeFromParentViewController];
            }
        }
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL isFirstDownload = [self checkFirstDownLoad];
    if (isFirstDownload) {
        [self showGuidePage];
    }
    NSString * bgColor = [[EnvStyleParser sharedParser] webViewBackgroundColor];
    if(bgColor){
        self.view.backgroundColor  = [UIColor colorWithCSS:bgColor];
        self.view.opaque= NO;
    }
}


- (void)setNavigationTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 200, 44)];
    label.text = NSLocalizedString(title, nil);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = (UIView *)label;
}

-(BOOL)checkFirstDownLoad{
    BOOL isFirst = [[NSUserDefaults standardUserDefaults] objectForKey:FIRST_LOGIN];
    if (isFirst) {
        return false;
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:FIRST_LOGIN];
        return true;
    }
    
}
-(void)showGuidePage{
    CGRect frame = [UIScreen mainScreen].bounds;
    self.cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.cover.backgroundColor = [UIColor colorWithRed:17/255.0 green:22/255.0 blue:36/255.0 alpha:0.64];
    CoverView *cover = [[CoverView alloc] initWithFrame:frame];
  
    [cover.knowBtn addTarget:self action:@selector(hideCover) forControlEvents:UIControlEventTouchUpInside];
    [self.cover addSubview:cover];
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];

    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.view.frame];
    //判断当前机型是否是iPhone X
    CGFloat height = [UIApplication sharedApplication].statusBarFrame.size.height;
    if(height >= 44){
        [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(8,40,44, 44) cornerRadius:0] bezierPathByReversingPath]];
    }else{
          [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(8,20,44, 44) cornerRadius:0] bezierPathByReversingPath]];
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineDashPattern = @[@4, @4];
    shapeLayer.lineWidth = 2.f;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.cover.layer setMask:shapeLayer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCover)];
    [self.cover addGestureRecognizer:tap];

}

-(void)hideCover{
    [self.cover removeFromSuperview];
    
} 
-(void)showLeft{
//    NSString *appCode = [[NSBundle mainBundle] objectForInfoDictionaryKey:APP_CODE];
    // 显示菜单弹框控制器
    MenuViewController *menu = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:[NSBundle mainBundle]];
    menu.selectMenu = self.pageName;
    [self presentViewController:menu animated:YES completion:nil];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
