//
//  FingerViewController.m
//  hybrid-demo
//
//  Created by syl on 2019/8/19.
//

#import "FingerViewController.h"
#import "Persistent.h"
#import "Strs.h"
#import "EnvAppData.h"
#import "FingerManager.h"
#import "LoginService.h"
#import "Router.h"
#import "EnvHybridConstants.h"
#import "AppDelegate.h"

@interface FingerViewController ()
@property (nonatomic, strong) NSDictionary *pageParams;
@end

@implementation FingerViewController

- (instancetype)initWithRouterParams:(NSDictionary *)routerParams{
    self = [super init];
    if(self) {
        if(routerParams && [routerParams objectForKey:kExtraParams]) {
            self.pageParams = [routerParams objectForKey:kExtraParams];
        }
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 校验指纹
    [[FingerManager sharedManager] checkFingerPrintWithSuccessBlock:^(id  _Nonnull data) {
        [self autoLogin];
    } failBlock:^(id  _Nonnull data) {
        
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)autoLogin {
    // 自动登录
    
    [[LoginService sharedService] autoLogin:@{} succ:^(NSDictionary* userInfo){
        // 修改为实际路由
        [Router open:HOME_ROUTE];
    } failure:^(NSError *error) {
        // 修改为实际路由
        [Router open:LOGIN_ROUTE];
    }];
}
- (IBAction)tryAgainFingerAuth:(UIButton *)sender {
    [[FingerManager sharedManager] checkFingerPrintWithSuccessBlock:^(id  _Nonnull data) {
        [self autoLogin];
    } failBlock:^(id  _Nonnull data) {

    }];
}
- (IBAction)goToLogin:(UIButton *)sender {
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate logout];
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
