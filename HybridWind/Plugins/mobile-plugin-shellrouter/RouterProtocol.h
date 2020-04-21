//
//  RouterProtocol.h
//  EnvHybrid
//
//  Created by xuchao on 17/4/5.
//
//

#import <Foundation/Foundation.h>

@protocol RouterProtocol <NSObject>

+ (void)open:(NSString *)url;
+ (void)open:(NSString *)url animated:(BOOL)animated extraParams:(NSDictionary *)extraParams;
+ (void)setNavigationController:(UINavigationController *)nav;
+ (void)map:(NSString *)format toController:(Class)controllerClass;

@end
