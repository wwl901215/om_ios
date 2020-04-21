/********* LoginAndOrg.m Cordova Plugin Implementation *******/
#import "ShellRouterPlugin.h"
#import <Cordova/CDVPluginResult.h>
#import "Routable.h"
#import <EnvHybrid/EnvHybridConstants.h>
#import "Persistent.h"
#import "AppDelegate.h"
#import "PublicDefine.h"
#import "SessionService.h"
#import "EnvAppData.h"
#import "MenuService.h"
#import "UserInfoService.h"
#import "LoginViewController.h"
#import <UMPush/UMessage.h>
#import "LoginAndOrg.h"

@implementation LoginAndOrg


- (void)logout:(CDVInvokedUrlCommand*)command
{
    // TODO: logout
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate logout];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)action:(CDVInvokedUrlCommand*)command
{
    
    NSString * data = [command argumentAtIndex:0];
    // TODO: action
    // 获取到orgid setsession
    NSString *orgSelect = [[EnvAppData sharedData] getPersistentItem:[NSString stringWithFormat:@"%@seleteOrgId", USERDEFAULT_PRIFIX]];
    NSString *orgPre = [[PublicDefine sharedInstance] getOrgSelect];
    if (orgSelect && ![orgSelect isEqualToString:orgPre]) {
        [[PublicDefine sharedInstance] setOrgSelect:orgSelect];
        @try {
            [[SessionService sharedService] setSession:orgSelect success:^(NSDictionary* newLoginInfo){
                if ([data isEqualToString:@"setting"]) {
                    // 切换组织成功
                    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
                    [delegate showOrgSelectSuccess];
                }
                [[[LoginViewController alloc] init] setSessionSuccess];
            } fail:^(NSError * _Nonnull err) {
                
            }];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


@end
