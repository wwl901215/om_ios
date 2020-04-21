//
//  Router.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/14.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RouterProtocol.h"

@interface Router : NSObject<RouterProtocol>

@property (nonatomic, strong) NSMutableArray<NSDictionary*>* _Nonnull routerConfigArr;

+ (instancetype _Nonnull)sharedRouter;
/**
   init  routes from router bundles
 */
- (void)initRoutes:(void (^_Nonnull)( NSError* _Nullable))complete;
/**
    the notification handler for Evnet NotificationRouterRollback
 */
- (void)rollbackRoutes:(NSNotification* _Nonnull )note;
/**
    the notification handler for Evnet  NotificationUpdateroutersSuccess
 */
-(void) updateRouterConfigs:(NSNotification* _Nonnull)note;
/**
 get the loadable url for a give router url
 */
- (NSString* _Nonnull)pathForUrl:(NSString* _Nonnull)url withParams:(NSDictionary* _Nonnull)params;


@end
