//
//  FingerManager.m
//  hybrid-demo
//
//  Created by syl on 2019/8/19.
//

#import "FingerManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation FingerManager
+ (instancetype)sharedManager {
    static FingerManager *_fingerManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _fingerManager = [[FingerManager alloc] init];
    });
    return _fingerManager;
}

- (void)checkFingerPrintWithSuccessBlock: (VerifySuccess)suc  failBlock: (VerifyFail) fail{
    // hud show
    UIActivityIndicatorView *indivator = [[UIActivityIndicatorView alloc] init];
    [indivator startAnimating];
    LAContext *la = [[LAContext alloc] init];
    la.localizedCancelTitle = @"cancel.."; // 自定义 左边 title
    la.localizedFallbackTitle = @"fallTitle.."; // 自定义 右边 title
    NSError *error;
    if ([la canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [la evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"手机验证指纹。。。" reply:^(BOOL success, NSError * _Nullable error) {
            // hud 消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [indivator stopAnimating];
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        suc(@"success");
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        switch (error.code) {
                                // 用户未提供有效证书,(3次机会失败 --身份验证失败)。
                            case LAErrorAuthenticationFailed:
                            {
                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"指纹验证失败" preferredStyle:UIAlertControllerStyleAlert];
                                [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                    [alert dismissViewControllerAnimated:NO completion:nil];
                                }]];
                                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
                                
                            }
                                
                                break;
                                // 认证被取消,(用户点击取消按钮)。
                            case LAErrorUserCancel:
                                break;
                                // 认证被取消,用户点击回退按钮(输入密码)。
                            case LAErrorUserFallback:
                                break;
                                // 身份验证被系统取消,(比如另一个应用程序去前台,切换到其他 APP)。
                            case LAErrorSystemCancel:
                                break;
                                // 身份验证无法启动,因为密码在设备上没有设置。
                            case LAErrorPasscodeNotSet:
                                break;
                                // 身份验证无法启动,因为触摸ID在设备上不可用。
                            case LAErrorTouchIDNotAvailable:
                                break;
                                // 身份验证无法启动,因为没有登记的手指触摸ID。 没有设置指纹密码时。
                            case LAErrorTouchIDNotEnrolled:
                                break;
                            case LAErrorTouchIDLockout:
                            {
                                [indivator startAnimating];
                                [la evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"123" reply:^(BOOL success, NSError * _Nullable error) {
                                    [indivator stopAnimating];
                                    if (success) {
                                        [self checkFingerPrintWithSuccessBlock:^(id  _Nonnull data) {
                                            suc(@"success");
                                        } failBlock:^(id  _Nonnull data) {
                                            fail(data);
                                        }];
                                    }
                                    
                                }];
                            }
                                break;
                            default:
                                // 其他错误
                                break;
                        }
                        fail(@"fail");
                    });
                }
                
            });
            
        }];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (error.code) {
                case LAErrorTouchIDNotEnrolled:
                    DDLogDebug(@"您还没有进行指纹输入，请指纹设定后打开");
                    break;
                case  LAErrorTouchIDNotAvailable:
                    DDLogDebug(@"您的设备不支持指纹输入，请切换为数字键盘");
                    break;
                case LAErrorPasscodeNotSet:
                    DDLogDebug(@"您还没有设置密码输入");
                    break;
                default:
                    break;
            }
            fail(@"fail");
        });
        
    }
    
   
}



@end
