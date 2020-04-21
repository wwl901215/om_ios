//
//  AppDelegate+UmengPush.h
//  PluginUsecase
//
//  Created by 史元君 on 2019/12/13.
//

#ifndef AppDelegate_UmengPush_h
#define AppDelegate_UmengPush_h

#import <Foundation/Foundation.h>
#import <UserNotifications/UNUserNotificationCenter.h>
#import "AppDelegate.h"
#import <UMCommon/UMConfigure.h>
#import <UMCommon/UMCommon.h>
#import <UMPush/Umessage.h>

#define APPKEY_IN_PLIST @"UmengAppkey"

typedef NS_ENUM(NSInteger, NotificationType){
//    willPresentNotification
    AlivePresentNotification = 1,
//    didReceiveNotificationResponse
    AliveBackgroundNotification =2 ,
//    didReceiveRemoteNotification
    CallToAwake =3
};

typedef void (^NotificationConsumer)(NSDictionary * , NotificationType);

@interface AppDelegate (UmengPush)<UNUserNotificationCenterDelegate>
// push service init entry
    - (void) initilizePushService:(NSDictionary*)withAppLaunchOptions messageComsumedBy:(NotificationConsumer)consumerBlock;
@end

#endif /* AppDelegate_UmengPush_h */
