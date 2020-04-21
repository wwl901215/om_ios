//
//  AppDelegate+UmengPush.m
//  PluginUsecase
//
//  Created by 史元君 on 2019/12/13.
//

#import "AppDelegate+UmengPush.h"

#include <arpa/inet.h>
#import <objc/runtime.h>
#import "UmengAliasRequestInteceptor.h"

@interface AppDelegate ()
  @property (nonatomic, copy) NotificationConsumer consumerBlock;
@end


@implementation AppDelegate (UmengPush)
    
static const void * __overviewKey;

-(void)setConsumerBlock:(NotificationConsumer)consumer{
    objc_setAssociatedObject(self , __overviewKey, consumer, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
    
-(NotificationConsumer) consumerBlock{
    return objc_getAssociatedObject(self, __overviewKey);
}
    
- (void)initilizePushService:(NSDictionary*)withAppLaunchOptions messageComsumedBy:(NotificationConsumer)consumerBlock {
    
    [NSURLProtocol registerClass:[UmengAliasRequestInteceptor class]];
    
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString* umengAppKey = dict[APPKEY_IN_PLIST];
    NSString* umengChannel = dict[@"UmengChannel"];
    
    self.consumerBlock = consumerBlock;
    [UMConfigure setLogEnabled: YES];
    [UMConfigure initWithAppkey:umengAppKey channel:umengChannel];
    
    NSString* deviceID =  [UMConfigure deviceIDForIntegration];
    if ([deviceID isKindOfClass:[NSString class]]) {
        NSLog(@"ENOS-Plug-Umeng:D/succee get deviceID:%@" ,deviceID );
    }
    else{
        NSLog(@"ENOS-Plug-Umeng:E/failed get deviceID");
    }
    
    // Push组件基本功能配置
    UMessageRegisterEntity * entity = [[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
    entity.types = UMessageAuthorizationOptionBadge|UMessageAuthorizationOptionSound|UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate=self;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:withAppLaunchOptions Entity:entity     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"ENOS-Plug-Umeng:granted");
        }else{
            NSLog(@"ENOS-Plug-Umeng:not granted");
        }
    }];
    
}
    
    
    //iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        NSLog(@"ENOS-Plug-Umeng::receive Push Notification from willPresentNotification");
        
        self.consumerBlock(userInfo, AlivePresentNotification);
    }else{
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}
    
    //iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        NSLog(@"ENOS-Plug-Umeng::receive Push Notification from didReceiveNotificationResponse");

        self.consumerBlock(userInfo, AliveBackgroundNotification);

    }else{
        //应用处于后台时的本地推送接受
    }
}
    
    //iOS10以下使用这两个方法接收通知  静默推送
-(void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10){
        [UMessage didReceiveRemoteNotification:userInfo];
        NSLog(@"ENOS-Plug-Umeng:receive Push Notification from didReceiveRemoteNotification");
        self.consumerBlock(userInfo, CallToAwake);
    }
    completionHandler(UIBackgroundFetchResultNewData);
}
    
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog( @"ENOS-Plug-Umeng:register for remote notification failed: Reason %@, suggestion:%@", [error localizedDescription], [error localizedRecoverySuggestion]);
}
    
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    const unsigned *tokenBytes = (const unsigned *)[deviceToken bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"ENOS-Plug-Umeng:deviceToken:%@",hexToken);
}


@end
