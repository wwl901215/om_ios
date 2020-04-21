//
//  FingerManager.h
//  hybrid-demo
//
//  Created by syl on 2019/8/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^VerifySuccess) (id data);
typedef void (^VerifyFail) (id data);

@interface FingerManager : NSObject
+ (instancetype)sharedManager;
- (void)checkFingerPrintWithSuccessBlock: (VerifySuccess)suc  failBlock: (VerifyFail) fail;

@end

NS_ASSUME_NONNULL_END
