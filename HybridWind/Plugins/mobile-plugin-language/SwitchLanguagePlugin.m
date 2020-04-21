#import <Cordova/CDVPluginResult.h>
#import "SwitchLanguagePlugin.h"
#import "DAConfig.h"
#import "AppDelegate.h"
#import "MenuService.h"
#import "PublicDefine.h"
#import "LoginViewController.h"

@implementation SwitchLanguagePlugin
- (void)switchLanguage:(CDVInvokedUrlCommand*)command {
    NSString *language = [command argumentAtIndex:0];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
   
    if ([language containsString: @"en"]) {
        [DAConfig setUserLanguage: CONFIG_LANGUAGE_EN];
    }else{
        [DAConfig setUserLanguage: CONFIG_LANGUAGE_ZH];
    }
    [delegate showChangeLanguageSuccess];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end
