//
//  SessionService.h
//  hybrid-demo
//
//  Created by syl on 2019/6/27.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SetSessionSuccess)(NSDictionary* newLoginInfo);
typedef void (^SetSessionFailed) (NSError *err);

@interface SessionService : BaseService
+(instancetype)sharedService;
-(void)getSession;
-(void)setSession:(NSString *)orgId success:(SetSessionSuccess) suc  fail:(SetSessionFailed) fail;

@end

NS_ASSUME_NONNULL_END
