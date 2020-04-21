/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */
#import "AppDelegate.h"
#import "Router.h"
#import "LoginViewController.h"
#import "MenuService.h"
#import "PublicDefine.h"
#import "EnvWindow.h"
#import "EnvAppData.h"
#import "ErrorViewController.h"
#import "DownloadAppViewController.h"
#import "FingerManager.h"
#import "FingerViewController.h"
#import "Persistent.h"
#import "EnvStyleParser.h"
#import "UIColor+Hex.h"
#import "UINavigationController+EnvHybrid.h"
#import "MenuViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "NSString+SHA256.h"
#import "AppSelectViewController.h"
#import "LoginService.h"
#import "AppDelegate+UmengPush.h"
#import "UserInfoService.h"
// from EnvDeletage
#import "EnvWindow.h"
#import <EnvHybrid/EnvHybridConstants.h>

// IMPORT START
// mobile-plugin-language import start
#import "DAConfig.h"
// mobile-plugin-language import end
// IMPORT END
//end

@implementation AppDelegate

//the main function response to umeng push notification
static void responsedToPushNotification( NSDictionary *info) {
    NSString* appCode = info[@"appCode"];
    NSString* appId = info[@"appAccessKey"];
    NSString* menuCode = info[@"menuCode"];
    NSString* notification = info[@"notification"];
    NSString* notificationType = info[@"notificationType"];

    DDLogDebug(@"###responsedToPushNotification received notification type:%@, appCode:%@, appAccessKey:%@ ,menuCode:%@,notification:%@",
          notificationType,appCode,appId,menuCode,notification);
    BOOL isAppidBlank = [NSString isBlankString:appId];
    NSArray<NSDictionary*> *apps =[[PublicDefine sharedInstance] getApps];
    NSDictionary* theAppToSwitch = nil;
    for(NSDictionary* app in apps){
        NSString *code = [app objectForKey:@"code"];
        NSString * appIdInList = [app objectForKey:@"id"];
        
        BOOL isMatch = isAppidBlank ? [appCode isEqualToString:code] :[appId isEqualToString:appIdInList];
        if(isMatch){
            theAppToSwitch =app;
            break;
        }
    }
    
    if(theAppToSwitch!=nil){
        DDLogDebug(@"###responsedToPushNotification find match APP");
        NSString* appid= [theAppToSwitch objectForKey:@"id"];
        [[MenuService sharedService] getMenuList:appid success:^(NSArray *menuList) {
            
            NSDictionary* menu =  [[MenuService sharedService] findMenu:menuList byComparator:^BOOL(NSDictionary * _Nonnull menu) {
                NSString* currentMenuCode = menu[@"identifier"];
                return [menuCode isEqualToString:currentMenuCode];
            }];
            
            if(menu!=nil){
                NSString* theUrl =menu[@"url"];
                DDLogDebug(@"###responsedToPushNotification find Menu with url:%@",theUrl);
                @try {
                    [[PublicDefine sharedInstance] setAppSelect:theAppToSwitch];
                    [[PublicDefine sharedInstance] setMenus:menuList];
                    [[PublicDefine sharedInstance] setMenuSelect:theUrl ];
                    [Router open:theUrl
                                          animated:FALSE
                                       extraParams:@{
                                                    ROUTE_KEY_URLQUERY:@{
                                                         @"notification" : notification
                                                         }
                                                     }
                     ];
                    
                } @catch (NSException *exception) {
                    DDLogDebug(@"###Open notification detail faild %@",exception);
                } @finally {
                    
                }
            }
            
        } fail:^(NSError *err) {
            DDLogError(@"###the get menu failed in notification:%@",[[err userInfo] objectForKey:@"message"]);
        }];
    }else{
        DDLogWarn(@"###NO Permissoin to access the notification detail");
    }
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    //    init the logger
    [DDLog addLogger:[DDOSLogger sharedInstance]];
    
    self.window = [[EnvWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *nav = [[UINavigationController alloc] init];
    [nav setNavigationBarHidden:YES];
    nav.view.backgroundColor = [UIColor whiteColor];
    [nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setShadowImage:[UIImage new]];
    [nav setNavigationBarHidden:YES];
    [self setNav:nav];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    [Router setNavigationController:nav];
    [self setNativeRoutes];

        // APPLICATION START
    // mobile-plugin-language application start
    [DAConfig setUserLanguage:[DAConfig getUserLanguage]];
    // mobile-plugin-language application end
        // APPLICATION END
    
    // 当设置了RootUrl时，APP会加载服务器端的页面，而不是本地的页面，主要用于远程调试
     // [[Router sharedRouter] setRootUrl:@"http://172.16.53.121:3000"];
    [[Router sharedRouter] initRoutes:^(NSError * _Nullable err) {
        if(err){
             DDLogError(@"initialize router with error:%@", err);
            if([err.domain isEqualToString:RouterBundleErrorDomain]){
                if(err.code == ErrCode_Unrecoveryable){
                    DDLogError(@"initialize router crashed:%@", err);
                }else{
                    DDLogWarn(@"");
                }
            }
        }
    }];
      
    
     [Router open:[self openRoute]];
    
    [self initUmengPushNotificationService:launchOptions];
    
    
    return YES;
}

-(void) initUmengPushNotificationService:(NSDictionary*)launchOptions {

        // Init umeng push notification service
        [self initilizePushService:launchOptions messageComsumedBy:^(NSDictionary * info, NotificationType type) {
    //        here you get the notiications ,
    //         1 use type to determine under which condition you received it
    //         2 use info to get the data the server sent

            NSString* lanucheByMsgId = nil;
            if(launchOptions !=nil) {
               NSDictionary* lanuchebByNoti = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
                lanucheByMsgId =lanuchebByNoti[@"d"];
            }
           

            if(type == AliveBackgroundNotification  ){
                 DDLogDebug(@"###  notification received and at AliveBackgroundNotification");
                [LoginService  onAutoLoginDone:^{
                    DDLogDebug(@"###  registerPostAutoLoginAction is triggerd");
                    responsedToPushNotification(info);
                }];
                BOOL isLaunchebByThisMsg =info[@"d"] == lanucheByMsgId;
                if(!isLaunchebByThisMsg){
                     [LoginService fireAutoLoginDoneEvent] ;
                }
            }else if(type== CallToAwake ){
                DDLogDebug(@"### CallToAwake notification received and registerPostAutoLoginAction");
                [LoginService  onAutoLoginDone:^{
                    DDLogDebug(@"###  registerPostAutoLoginAction is triggerd");
                    responsedToPushNotification(info);
                }];
            }else{
                DDLogDebug(@"### AlivePresentNotification %@",info);

            }
           
        }];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)showChangeLanguageSuccess {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"switch_language_notice", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"i_know", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:NO completion:nil];
        exit(0);
    }]];
    [[UserInfoService sharedService] addAlias];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showOrgSelectSuccess {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"switch_org_notice", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"i_know", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:NO completion:nil];
        exit(0);
    }]];
    [[UserInfoService sharedService] addAlias];

    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"i_know", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:NO completion:nil];
    }]];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}



//配置要打开页面路由
- (NSString*)openRoute
{
    return LOGIN_ROUTE;
}

//配置自定义viewcontroller的router
- (void)setNativeRoutes
{
    [Router map:LOGIN_ROUTE toController:[LoginViewController class]];
    [Router map:DOWNLOAD_ROUTE toController:[DownloadAppViewController class]];
    [Router map:FINGER_ROUTE toController:[FingerViewController class]];
    [Router map:@"/menus?cur_menus=:cur_menus" toController:[MenuViewController class]];
    [Router map:@"/menus" toController:[MenuViewController class]];
    [Router map:@"/apps" toController:[AppSelectViewController class]];

}

//配置原生navigationcontroller样式
-(void)setNav:(UINavigationController *)nav{
    NSArray *naviBarBgColors = [[EnvStyleParser sharedParser] navigationBarBackgroundColors];
    if([naviBarBgColors count] > 1) {
        NSInteger gradientDirection = [[EnvStyleParser sharedParser] navigationBarGradient];
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        for(int i = 0; i < [naviBarBgColors count]; i++){
            colors[i] = (id)[UIColor colorWithCSS:naviBarBgColors[i]];
        }
        [nav ex_setBackgroundGradientColors:colors direction:gradientDirection];
    }else {
        [nav ex_setBackgroundColor:[UIColor colorWithCSS:naviBarBgColors[0]]];
    }
}

-(void)showWindowHome {
    UINavigationController *nv = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    NSArray *vcs = nv.childViewControllers;
    for (UIViewController *vc in vcs) {
        [vc removeFromParentViewController];
    };
     [Router open:LOGIN_ROUTE];
    //TODO: should reset all routers ????
    
}

- (void)logout {
    [[UserInfoService sharedService] removeAlias];
    // 删除持久化用户信息
    [self clearCookies];
    [self clearAllUserDefaultsData];
    [Persistent removeFile:LOGIN_INFO];
    [self showWindowHome];
}

- (void)clearAllUserDefaultsData{
    NSUserDefaults*userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary*dic=[userDefaults dictionaryRepresentation];
    [userDefaults removeObjectForKey:ACCESSTOKEN];
    [userDefaults removeObjectForKey:FIRST_LOGIN];
    [userDefaults removeObjectForKey:kCurrentVersion];
    [userDefaults removeObjectForKey:CURRENT_ENV];
    [[PublicDefine sharedInstance] clearAllData];
    for(NSString *key in dic) {
        if (![key isEqualToString:@"UWUserLanguageKey"]) {
            [userDefaults removeObjectForKey:key];
        }
    }
    [userDefaults synchronize];
}
-(void) clearCookies
{
    //    清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSArray *oldCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in oldCookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie: cookie];
    }
}
@end
