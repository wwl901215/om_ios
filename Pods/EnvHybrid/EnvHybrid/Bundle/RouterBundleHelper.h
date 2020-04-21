//
//  BundleManager.h
//  EnvHybrid
//
//  Created by xuchao on 17/3/27.
//  Copyright © 2017年 envision. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^HelperCompleteBlock)(NSError* _Nullable);

@interface RouterBundleHelper : NSObject
/**
 copy bundles folders from "webapp" to "NSHomeDirectory()/Library/Bundles"
 */
+ (void)copyBundleResourceFromWebapp:(HelperCompleteBlock _Nonnull ) complete;
/**
 reading the bunlders under "NSHomeDirectory()/Library/Bundles" folder
 @param complete receive the array of content json from config.json if any
 */
+ (void)parseBundlesFromBundlesFolder:(void (^_Nonnull)(NSError* _Nullable error, NSArray* _Nullable bundlesArray)) complete;
/**
 setup the mapping between a router config url to a concreate controller with a given bundles array
 get a list of router configs from the bundles array, the result can be used for the map method of ROutalbe
 @return [{
 @"url":string ,
 @"controllerClz":class,
 @"routeConfig":object
 }]
 */
+ (NSArray<NSDictionary*>*_Nonnull)mapUrlToControllerWithBundles:(NSArray* _Nonnull)bundles error:(NSError*_Nonnull*_Nonnull)err;

/** a wapper method encapsulate the call of  parseBundlesFromBundlesFolder  and mapUrlToControllerWithBundles, the result of routerConfig from block is same as the one from mapUrlToControllerWithBundles
*/
+ (void) buildRouters:(void (^_Nonnull)(NSError* _Nullable , NSArray<NSDictionary*>* _Nonnull routerConfig))complete;
+ (BOOL)isFirstLaunchOrNativeUpdate;
+ (void)checkUpdate:(void (^_Nonnull)(BOOL))complete pkgUpdateCallback:(void (^_Nonnull)(NSDictionary * _Nonnull))pkgUpdateCallback;

@end
