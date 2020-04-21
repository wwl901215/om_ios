#import <Cordova/CDVPlugin.h>

@interface ShellRouterPlugin : CDVPlugin
- (void)replaceState:(CDVInvokedUrlCommand*)command;
- (void)pushState:(CDVInvokedUrlCommand*)command;
- (void)goBack:(CDVInvokedUrlCommand*)command;
@end