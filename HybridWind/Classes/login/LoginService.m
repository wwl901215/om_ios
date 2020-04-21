
#import <Security/Security.h>
#import "LoginService.h"
#import "Uris.h"
#import "Strs.h"
#import "EnvAppData.h"
#import "Persistent.h"
#import "PublicDefine.h"
#import "EnvAppData.h"
#import "CommonTools.h"
#import "NSString+SHA256.h"
#import "AFNetworking.h"
#import "UserInfoService.h"
#import <EnvHybrid/EnvVersionUtils.h>


@interface LoginService()
@property(nonatomic, strong) NSMutableArray* succCallbacks;
@property(nonatomic, strong) NSMutableArray* failCallbacks;
@property(nonatomic) BOOL isLogining;
@property(nonatomic,strong) NSString* domain;
@end

@implementation LoginService

static NSString* EVENT_NAME_AUTOLOGIN_DONE = @"EVENT_NAME_AUTOLOGIN_DONE";

+(void) onAutoLoginDone:(void(^)(void))action {
    NSNotificationCenter * __weak center = [NSNotificationCenter defaultCenter];
    id __block token = [center
                addObserverForName:EVENT_NAME_AUTOLOGIN_DONE
                            object:nil
                             queue:[NSOperationQueue mainQueue]
                        usingBlock:^(NSNotification *note) {
                            DDLogDebug(@"###  registerPostAutoLoginAction is going to call ");
                            action();
                            [center removeObserver:token];
                       }];
}

+(void) fireAutoLoginDoneEvent {
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_NAME_AUTOLOGIN_DONE object:nil];
}

+(instancetype)sharedService {
    static LoginService * _sharedService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedService = [LoginService new];
        _sharedService.succCallbacks = [NSMutableArray new];
        _sharedService.failCallbacks = [NSMutableArray new];
        _sharedService.isLogining = NO;
        NSString *appServer = [[PublicDefine sharedInstance] getCurrentAPIMEnv];
        NSUInteger location = [appServer rangeOfString:@"//"].location;
        if(location == NSNotFound){
            _sharedService.domain = appServer;
        }else{
            _sharedService.domain = [appServer substringFromIndex: location+2];
        }
        
    });
    return _sharedService;
}

-(void)performLogin:(NSString *) loginId
           password:(NSString *) password
               succ:(LoginServiceSuccess) succ
            failure: (LoginServiceFailed) fail{
    
    [self.succCallbacks addObject:succ];
    [self.failCallbacks addObject:fail];
    
    if(self.isLogining){
        return;
    }
    self.isLogining = YES;
    // 如果是重新登录，则清空状态
//    if([EnvAppData sharedData].isInitialized){
//        [[EnvAppData sharedData] resetState];
//    }
    
    // 清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSArray *oldCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in oldCookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie: cookie];
    }
    
    //设置语言Cookie
    
    NSString *appServer = [[PublicDefine sharedInstance] getCurrentAPIMEnv];
    NSUInteger location = [appServer rangeOfString:@"//"].location;
    if(location == NSNotFound){
        self.domain = appServer;
    }else{
        self.domain = [appServer substringFromIndex: location+2];
    }
    
    NSHTTPCookie *localCookie = [self getLanguageCookieWithDomain:self.domain  expiresDate:[NSDate dateWithTimeIntervalSinceNow: +24*60*60]];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:localCookie];
    
//    NSString *urlBase = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AppServer"];
    NSString *urlBase = [[PublicDefine sharedInstance] getCurrentAPIMEnv];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", urlBase, POST_LOGIN];
//    NSString *keyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"keyId"];

    [self postJSONWithUrl:strUrl content:@{@"account":loginId, @"password":password} header: nil
         successWithBlock:^(NSHTTPURLResponse *response, NSDictionary* data)
     {
         NSMutableDictionary *loginState =[NSMutableDictionary dictionaryWithDictionary:data];
         NSArray *newCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:response.allHeaderFields forURL:[NSURL URLWithString:strUrl]];
         // 将orgs传递到web
         NSMutableArray *orgs = loginState[@"data"][@"organizations"];
         NSArray *handleOrgs = [CommonTools handleArray:orgs];
         [[EnvAppData sharedData] savePersistentItem:handleOrgs forKey:[NSString stringWithFormat:@"%@orgs", USERDEFAULT_PRIFIX]];
         [[EnvAppData sharedData] savePersistentItem: loginState[@"data"][@"user"][@"name"] forKey:[NSString stringWithFormat:@"%@userName", USERDEFAULT_PRIFIX]];
         NSString *version = [EnvVersionUtils currentVersion];
         [[EnvAppData sharedData] savePersistentItem:version  forKey:[NSString stringWithFormat:@"%@version", USERDEFAULT_PRIFIX]];
         //更新持久化数据
         [self saveLogin:loginState withCookies:newCookies];
         [self successAll:loginState[@"data"]];
     } failure:^(NSError * error) {
         //登录失败，提示用户相关信息
         NSDictionary *userInfo = error.userInfo;
         NSString *code = [NSString stringWithFormat:@"%@", [userInfo objectForKey:@"code"]];
         if(![userInfo objectForKey:NSLocalizedDescriptionKey]){
             NSError *er = [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:@{
                 NSLocalizedDescriptionKey:NSLocalizedString(@"NETWORK_TIME_OUT", @""),
                 NSUnderlyingErrorKey:error
             }];
             [self failedAll:er];
         }else if([code isEqualToString:@"400"]){
             NSError *er = [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:@{
                 NSLocalizedDescriptionKey:NSLocalizedString(@"msg_username_or_password_wrong", @""),
                 NSUnderlyingErrorKey:error}];
             [self failedAll:er];
         }else{
              [self failedAll:error];
         }
     }];
}

- (void)autoLogin:(NSDictionary *)dictionary succ:(LoginServiceSuccess) succ
          failure: (LoginServiceFailed) fail{
    
    [self.succCallbacks addObject:succ];
    [self.failCallbacks addObject:fail];
    
    if(self.isLogining){
        return;
    }
    self.isLogining = YES;
    NSDictionary *loginInfo = [Persistent readFromFile:LOGIN_INFO];
    NSString *refreshToken = [loginInfo objectForKey:REFRESHTOKEN];
    NSString *urlBase = [[PublicDefine sharedInstance] getCurrentAPIMEnv];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@?refreshToken=%@", urlBase, POST_REFRESHTOKEN, refreshToken];

    // 清除缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSArray *oldCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in oldCookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie: cookie];
    }
    
    //设置语言Cookie
    NSHTTPCookie *localCookie = [self getLanguageCookieWithDomain: self.domain expiresDate:[NSDate dateWithTimeIntervalSinceNow: +24*60*60]];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:localCookie];
    
    [self fetchJSONWithUrl:strUrl   header:nil successWithBlock:^(NSHTTPURLResponse *response, id data) {
        NSMutableDictionary * loginState =[NSMutableDictionary dictionaryWithDictionary:data];
        
        NSArray * newCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:response.allHeaderFields forURL:[NSURL URLWithString:strUrl]];
        //更新持久化数据
        [self saveLogin:loginState withCookies:newCookies];
         NSDictionary *userInfo = loginState[@"data"];
        [[UserInfoService sharedService] addAlias:userInfo[@"userName"] type:userInfo[@"workingOrganizationId"]];
        [self successAll:userInfo];
    } failure:^(NSError *err) {
        [self performLogout];
    }];

}



- (void)saveLogin:(NSDictionary *)loginState withCookies:(NSArray *)newCookies{
    NSDictionary *userInfo = loginState[@"data"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    NSArray *orgs = [dic objectForKey:@"organizations"];
    NSArray *handleOrgs = [CommonTools handleArray:orgs];
    [dic setObject:handleOrgs forKey:@"organizations"];
    [Persistent writeToFile:LOGIN_INFO content:dic];
}

/*
 * 注销
 */
-(void)performLogout
{
    [self.succCallbacks removeAllObjects];
    [self.failCallbacks removeAllObjects];
    [Persistent removeFile:LOGIN_INFO];
    [[EnvAppData sharedData] resetState];
    [[PublicDefine sharedInstance] clearAllData];
    self.isLogining = NO;
}

/**
 *  通知登录队列中所有的回调登录成功
 */
-(void)successAll:(NSDictionary *)userInfo
{
    for(LoginServiceSuccess success in self.succCallbacks){
        success(userInfo);
    }
    [self.succCallbacks removeAllObjects];
    [self.failCallbacks removeAllObjects];
    self.isLogining = NO;
}
/**
 *  向登录队列中所有的请求发送失败错误
 *
 *  @param error
 */
-(void)failedAll:(NSError *) error
{
    for(LoginServiceFailed failure in self.failCallbacks){
        failure(error);
    }
    [self.succCallbacks removeAllObjects];
    [self.failCallbacks removeAllObjects];
    self.isLogining = NO;
}

/**
 设置语言
 
 @param domainStr domainStr 域
 */
-(NSHTTPCookie *) getLanguageCookieWithDomain: (NSString *) domainStr expiresDate: (NSDate *) expiresDate
{
    //语言
    NSDictionary *propertiesLoc = [[NSMutableDictionary alloc] init];
    NSString *localStr = [self language];
    [propertiesLoc setValue:localStr forKey:NSHTTPCookieValue];
    [propertiesLoc setValue:@"lang" forKey:NSHTTPCookieName];
    [propertiesLoc setValue: domainStr forKey:NSHTTPCookieDomain];
    [propertiesLoc setValue: expiresDate forKey:NSHTTPCookieExpires];
    [propertiesLoc setValue:@"/" forKey:NSHTTPCookiePath];

    NSHTTPCookie *cookieLoc = [[NSHTTPCookie alloc] initWithProperties:propertiesLoc];
    return cookieLoc;
}

/**
 设置设备唯一标识
 @param domainStr domainStr 域
 */
-(NSHTTPCookie *) getUUIDCookieWithDomain: (NSString *) domainStr expiresDate : (NSDate *) expiresDate
{

    
    NSDictionary *propertiesLoc = [[NSMutableDictionary alloc] init];
    [propertiesLoc setValue:DEVICEUUID forKey:NSHTTPCookieName];
    [propertiesLoc setValue: domainStr forKey:NSHTTPCookieDomain];
    [propertiesLoc setValue:@"/" forKey:NSHTTPCookiePath];
    [propertiesLoc setValue: expiresDate forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:propertiesLoc];
    return cookie;
}

- (NSString *)language{
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    
    if ([currentLanguage containsString:@"zh"]) {
        return LANGUAGE_ZH_TO_WEB;
    } else if ([currentLanguage containsString:@"en"]) {
        return LANGUAGE_EN_TO_WEB;
    }
    
    return LANGUAGE_EN_TO_WEB;
}


@end
