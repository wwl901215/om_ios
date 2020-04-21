//
//  SessionService.m
//  hybrid-demo
//
//  Created by syl on 2019/6/27.
//

#import "SessionService.h"
#import "PublicDefine.h"
#import "Uris.h"
#import "Persistent.h"
#import "UserInfoService.h"

@implementation SessionService
+(instancetype)sharedService{
    static SessionService *_sessionService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionService = [[SessionService alloc] init];
    });
    return _sessionService;
}
-(void)getSession{
//    NSString *urlBase = [[PublicDefine sharedInstance] getCurrentHost];
//    NSString *strUrl = [NSString stringWithFormat:@"%@%@", urlBase, POST_SESSION_GET];
//    [self postJSONWithUrl:strUrl content:@{} header: nil successWithBlock:^(NSHTTPURLResponse *task, id data) {
//
//    } failure:^(NSError *err) {
//
//    }];
}
-(void)setSession:(NSString *)orgId success:(SetSessionSuccess) suc  fail:(SetSessionFailed) fail{
    NSString *urlBase = [[PublicDefine sharedInstance] getCurrentAPIMEnv];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", urlBase, POST_SESSION_SET];
    [self postJSONWithUrl:strUrl content:@{@"organizationId": orgId} header: @{AUTHORIZATION: [[PublicDefine sharedInstance] getAuthorization]}   successWithBlock:^(NSHTTPURLResponse *task, id data) {
        DDLogDebug(@"setSession = %@", data);
        //保存data值
        
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:data];
        NSDictionary *loginInfo = [dic objectForKey:@"data"];
        [[UserInfoService sharedService] addAlias:loginInfo[@"userName"]  type:loginInfo[@"currentOrgId"]];
        [Persistent writeToFile:LOGIN_INFO content:loginInfo];
        suc(loginInfo);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"setSessionSuccess" object:nil];
    } failure:^(NSError *err) {
        fail(err);
    }];
}
@end
