#import <Cordova/CDVPlugin.h>

@interface LoginAndOrg : CDVPlugin
- (void)logout:(CDVInvokedUrlCommand*)command;
- (void)action:(CDVInvokedUrlCommand*)command;
@end