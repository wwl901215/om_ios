
#import <Cordova/CDVViewController.h>
#import <Cordova/CDVAppDelegate.h>

@interface AppDelegate : CDVAppDelegate {}
//from EnvDeletage
@property (nonatomic, strong) UIWindow *window;
- (void)setNativeRoutes;
- (void)setNav:(UINavigationController *)nav;
//end
-(void)showWindowHome;
- (void)showChangeLanguageSuccess;
- (void)logout;
- (void)showOrgSelectSuccess;
- (void)showAlertWithMessage:(NSString *)message;
@end
