#import "ShellRouterPlugin.h"
#import <Cordova/CDVPluginResult.h>
#import "Routable.h"
#import <EnvHybrid/EnvHybridConstants.h>

@implementation ShellRouterPlugin
- (void)replaceState:(CDVInvokedUrlCommand*)command
{
    NSString * path = [command argumentAtIndex:0];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [[Routable sharedRouter] pop:NO];
    @try {
         [[Routable sharedRouter] open:path];
    } @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)pushState:(CDVInvokedUrlCommand*)command
{
    NSString * path = [command argumentAtIndex:0];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    @try {
        [[Routable sharedRouter] open:path];
    } @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

- (void)goBack:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    @try {
        [[Routable sharedRouter] popViewControllerFromRouterAnimated:YES];
    } @catch (NSException *exception) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    } @finally {
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}

@end
