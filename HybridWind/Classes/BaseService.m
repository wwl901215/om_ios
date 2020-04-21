

#import "BaseService.h"

#import "Reachability.h"
#import "AFNetworking.h"
#import <EnvHybrid/EnvHybridConstants.h>
#import "Persistent.h"
#import "Strs.h"
#import "Router.h"
#import "EnvAppData.h"
#import "CommonTools.h"
#import "NSString+SHA256.h"
#import "PublicDefine.h"
#import "AppDelegate.h"
#import "Uris.h"
#import "DAConfig.h"
#import "ApimService.h"


#define kEnvServiceErrorDomain @"kEnvServiceErrorDomain"
#define TIMEOUT 40
#define cSuccessResponse                             @"200"
#define cErrorInvalidResponse                        100
#define cErrorResponseFlagFalse                      101
#define cErrorLoginInvalidResponse                   102
#define sErrorInvalidResponse                        @"ErrorInvalidResponse"
#define sErrorResponseFlagFalse                      @"ErrorResponseFlagFalse"
#define sErrorLoginInvalidResponse                   @"ErrorLoginInvalidResponse"


@implementation BaseService

-(instancetype)init {
    if (self = [super init]) {
        self.failureHandler = ^void(NSURLSessionDataTask* _Nullable task, NSError* _Nullable error){
            
        };
    }
    return self;
}

-(AFHTTPSessionManager*)getBaseConfigedSessionManager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.validatesDomainName = NO;
    manager.securityPolicy.allowInvalidCertificates = NO;
    
    //requestSerializer init
    AFJSONRequestSerializer* reqSerizlizer = [AFJSONRequestSerializer serializer];
    [reqSerizlizer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    reqSerizlizer.timeoutInterval = TIMEOUT;
    manager.requestSerializer =reqSerizlizer;
    
    //responseSerializer init
    AFJSONResponseSerializer* respSerializer = [AFJSONResponseSerializer serializer];
    respSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", @"text/javascript", nil];
    manager.responseSerializer = respSerializer;
    
    return manager;
}

-(AFHTTPSessionManager*)getAppportalSessionManager {
    
    AFHTTPSessionManager *manager = [self getBaseConfigedSessionManager];
   
    // 添加header
    NSString *apimaccessToken = [[PublicDefine sharedInstance] getApimAccessToken][@"accessToken"];
    [manager.requestSerializer setValue:apimaccessToken forHTTPHeaderField:@"apim-accesstoken"];
    [manager.requestSerializer setValue:[[PublicDefine sharedInstance] getAuthorization] forHTTPHeaderField:AUTHORIZATION];
    
    return manager;
}


-(void)request:(NSString*)url type:(MethodType)type body:(NSDictionary*)body headers:(NSDictionary*)headers{

}
 

-(void) fetchJSONWithUrl:(NSString *) url  header:(NSDictionary *)header successWithBlock:(EnvServiceSuccess) succ
                 failure:(EnvServiceFailed) fail
    {
        return [self requestWithUrl:url isPost:NO content:nil   header: header successWithBlock:succ failure:^(NSError* err){
            if(err!=nil){
                DDLogError(@"request:%@ failed with %@:",url,err);
            }
            fail(err);
        }];
    }
    
-(void) postJSONWithUrl:(NSString *) url content:(id) body header:(NSDictionary *)header   successWithBlock:(EnvServiceSuccess) succ
                failure:(EnvServiceFailed) fail
    {
        return [self requestWithUrl:url isPost:YES content:body   header:header successWithBlock:succ failure:^(NSError* err){
            if(err!=nil){
                DDLogError(@"request:%@ failed with %@:",url,err);
            }
            fail(err);
        }];
    }
    
-(void) requestWithUrl:(NSString *) url isPost:(BOOL) isPost
               content:(id) body
      header:(NSDictionary *)header
      successWithBlock:(EnvServiceSuccess) succ
               failure:(EnvServiceFailed) fail
    {
        if(![self isConnectionAvailable]){
            NSError * error = [NSError errorWithDomain:kEnvServiceErrorDomain
                                                  code: -1
                                              userInfo:@{
                                                  NSLocalizedDescriptionKey:NSLocalizedString(@"err_network_unavailable", @"network not available"),
                                                  NSLocalizedFailureReasonErrorKey:@"network not available"
                                              } ];
            fail(error);
        }else if(![url stringIsValid] || (isPost && !body)){
            NSError * error = [NSError errorWithDomain:kEnvServiceErrorDomain
                                                  code: -2
                                              userInfo:@{
                                                  NSLocalizedDescriptionKey:NSLocalizedString(@"err_invalid_req", @"invalid arguments"),
                                                  NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"url:%@ is not valid or post request without body:%@", url,body]
                                              }];
                                
            fail(error);
        }else if( [[ApimService sharedService] cheackApimAccessTokenExpire]) {
            // apim-token失效
            [[ApimService sharedService] getToken:^(NSString * _Nonnull token) {
                [self requestWithUrl:url isPost:isPost content:body   header:header successWithBlock:succ failure:fail];
            } fail:^(NSURLSessionDataTask * _Nullable ftask, NSError * _Nonnull apimErr) {
                NSError * error = [NSError errorWithDomain:kEnvServiceErrorDomain
                                                                     code: -3
                                                                 userInfo:@{
                                                                     NSLocalizedDescriptionKey:NSLocalizedString(@"err_apimtoken_expired", @"update apim-token token faild"),
                                                                     NSLocalizedFailureReasonErrorKey:[NSString stringWithFormat:@"apim-token token expired and refresh request faild:%@", [apimErr userInfo][NSLocalizedDescriptionKey] ],
                                                                     NSUnderlyingErrorKey:apimErr
                                                                 }];
                               fail(error);
            }];
            
        }else{
            AFHTTPSessionManager *manager = nil;
           
            
                // 添加header
                NSString *apimaccessToken = [[PublicDefine sharedInstance] getApimAccessToken][@"accessToken"];
                NSDate *datenow = [NSDate date];
                NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970] * 1000];
                NSString *secretKey = [[PublicDefine sharedInstance] getAPIMAppSecretKey];
                NSMutableString *paramData = [NSMutableString new];
                NSMutableString *signData = [NSMutableString new];
                if (body) {
                    paramData = (NSMutableString *)[CommonTools convertToJsonData:body];
                    signData = (NSMutableString *)[NSString stringWithFormat:@"%@%@%@%@", apimaccessToken, paramData, timeSp, secretKey];
                }else {
                    // 将query排序
                    NSArray *components = [url componentsSeparatedByString:@"?"];
                    if (components.count > 1) {
                        NSString *query = components[1];
                        NSArray *queryComponents = [query componentsSeparatedByString:@"="];
                        paramData = (NSMutableString *)[NSString stringWithFormat:@"%@%@", queryComponents[0], queryComponents[1]];
                        signData = (NSMutableString *)[NSString stringWithFormat:@"%@%@%@%@", apimaccessToken, paramData, timeSp, secretKey];
                    }else{
                        signData = (NSMutableString *)[NSString stringWithFormat:@"%@%@%@", apimaccessToken, timeSp, secretKey];
                    }
                }
                
                manager = [self getAppportalSessionManager];
                NSString *sha256SignData = [[signData SHA256] lowercaseString];
                [manager.requestSerializer setValue:apimaccessToken forHTTPHeaderField:@"apim-accesstoken"];
                [manager.requestSerializer setValue:sha256SignData forHTTPHeaderField:@"apim-signature"];
                [manager.requestSerializer setValue:timeSp forHTTPHeaderField:@"apim-timestamp"];
                [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                
                NSString *authorization = [header objectForKey:AUTHORIZATION];
                if (authorization) {
                    [manager.requestSerializer setValue:authorization forHTTPHeaderField:AUTHORIZATION];
                }
             
            
           
            NSString *domain = [[NSURL URLWithString:url] host];
            
            //设置语言Cookie
            NSHTTPCookie *localCookie = [self getLanguageCookieWithDomain: domain expiresDate:[NSDate dateWithTimeIntervalSinceNow: +24*60*60]];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:localCookie];
            
            if(!isPost){
                [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask* task, id  responseObject) {
                    
                    if(responseObject == nil){
                        fail([NSError errorWithDomain:domain code:cErrorInvalidResponse userInfo:nil]);
                    }
                    NSString *code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]];
                    if(code != nil && !([code isEqualToString:cSuccessResponse])){
                        fail([NSError errorWithDomain:domain code:cErrorResponseFlagFalse userInfo:@{
                            NSLocalizedDescriptionKey: [responseObject objectForKey:@"message"]
                        }]);
                    }else{
                        succ((NSHTTPURLResponse *)task.response,responseObject);
                    }
                } failure:^(NSURLSessionDataTask* operation, NSError* error) {
                    if(operation){
                       NSHTTPURLResponse* response = (NSHTTPURLResponse*)operation.response;
                       if(response.statusCode == 401){
                           [[ApimService sharedService] getToken:^(NSString * _Nonnull token) {
                                          [self requestWithUrl:url isPost:isPost content:body header:header successWithBlock:succ failure:fail];
                            } fail:^(NSURLSessionDataTask * _Nullable ftask, NSError * _Nonnull apimErr) {
                              fail(apimErr);
                          }];
                           return;
                       }
                   }
                     fail(error);
                }];
            }else{
                [manager POST:url parameters:body progress:nil success:^(NSURLSessionDataTask* task, id  responseObject) {
                    if(responseObject == nil){
                        fail([NSError errorWithDomain:domain code:cErrorInvalidResponse userInfo:nil]);
                    }
                    NSString *code = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"code"]];
                    
                    if(code != nil && !([code isEqualToString:cSuccessResponse])){
                                              if ([code isEqualToString:@"401"]) {
                                                  [Router open:LOGIN_ROUTE];
                                              }
                                              fail([NSError errorWithDomain:domain code:cErrorResponseFlagFalse userInfo:@{NSLocalizedDescriptionKey: [responseObject objectForKey:@"message"], @"code": [responseObject objectForKey:@"code"]}]);
                                          }else{
                                              succ((NSHTTPURLResponse *)task.response, responseObject);
                                          }
                } failure:^(NSURLSessionDataTask* operation, NSError* error) {
                    if(operation){
                        NSHTTPURLResponse* response = (NSHTTPURLResponse*)operation.response;
                        if(response.statusCode == 401){
                            [[ApimService sharedService] getToken:^(NSString * _Nonnull token) {
                                           [self requestWithUrl:url isPost:isPost content:body  header:header successWithBlock:succ failure:fail];
                             } fail:^(NSURLSessionDataTask * _Nullable ftask, NSError * _Nonnull apimErr) {
                               fail(apimErr);
                           }];
                            return;
                        }
                        
                    }
                      fail(error);
                  
                }];
               
            }
        }
    }
    
-(BOOL) isConnectionAvailable
    {
        BOOL isExistenceNetwork = YES;
        Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        switch ([reach currentReachabilityStatus]) {
            case NotReachable:
            isExistenceNetwork = NO;
            DDLogDebug(@"notReachable");
            break;
            case ReachableViaWiFi:
            isExistenceNetwork = YES;
            DDLogDebug(@"WIFI");
            break;
            case ReachableViaWWAN:
            isExistenceNetwork = YES;
            DDLogDebug(@"3G");
            break;
        }
        return isExistenceNetwork;
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
    [propertiesLoc setValue:@"locale" forKey:NSHTTPCookieName];
    [propertiesLoc setValue: domainStr forKey:NSHTTPCookieDomain];
    [propertiesLoc setValue: expiresDate forKey:NSHTTPCookieExpires];
    [propertiesLoc setValue:@"/" forKey:NSHTTPCookiePath];
    [[EnvAppData sharedData] savePersistentItem:localStr forKey:[NSString stringWithFormat:@"%@locale", USERDEFAULT_PRIFIX]];
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
    NSString *language = [DAConfig getUserLanguage];
    NSString *result;
    if ([language containsString:@"zh"]) {
         result = LANGUAGE_ZH_TO_WEB;
    } else if ([language containsString:@"en"]) {
         result = LANGUAGE_EN_TO_WEB;
    }
    return result;
}
 
    
    @end

