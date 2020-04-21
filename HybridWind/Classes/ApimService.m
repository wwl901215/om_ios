//
//  ApimService.m
//  HybridWind
//
//  Created by 史元君 on 2020/2/26.
//

#import  "ApimService.h"
#import "PublicDefine.h"
#import "NSString+SHA256.h"
#import "AFNetworking.h"

#define ERROR_DOMAIN @"ENOS_APIM_REQUESTS"

#define POST_APIM_GET_TOKEN   @"/apim-token-service/v2.0/token/get"
#define POST_APIM_REFRESH_TOKEN    @"/apim-token-service/v2.0/token/refresh"

#define EXPIRE_DELTA 5*60

@implementation ApimService

+(instancetype)sharedService{
    static ApimService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[ApimService alloc] init];
    });
    return service;
}

-(NSError*) genError:(ApimErrorCode)code readableMsg:(NSString*)localizedString forReason:(NSString*)failureReason fromError:(NSError* _Nullable)err{
    
    return [NSError errorWithDomain:ERROR_DOMAIN
                               code: code
                           userInfo:@{
                               NSLocalizedDescriptionKey:localizedString,
                               NSLocalizedFailureReasonErrorKey:failureReason,
                               NSUnderlyingErrorKey:err
                           }];
}


-(void)saveApimtoken:(NSDictionary*) respMap{
    NSMutableDictionary* tokenDic =[NSMutableDictionary dictionaryWithDictionary:respMap];
    tokenDic[@"ts"] = @((long)[[NSDate date] timeIntervalSince1970]);
    [[PublicDefine sharedInstance] setApimAccessToken:tokenDic];
}

/**
 this response  call the success only the the request is success in business meaning(not only statuscode is 200 but also the response has a valid code)
 and the data passed in comes from the `data` key in origin response dictionary
 */
- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary*)parameters
                      progress:(void (^)(NSProgress * _Nonnull))uploadProgress
                       success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
                       failure:(FailureBlock)failure{
    NSString *accessKey = [[PublicDefine sharedInstance] getAPIMAppAccessKey];
    NSString *secretKey = [[PublicDefine sharedInstance] getAPIMAppSecretKey];
    
    long timeSp = [[NSDate date] timeIntervalSince1970] * 1000;
    // 拼接appKey、timestamp、appSecret
    NSString *encryptionStr = [NSString stringWithFormat:@"%@%ld%@", accessKey, timeSp, secretKey];
    // 对 encryptionStr 进行sha256 加密
    NSString *SHAencryptionStr = [[encryptionStr SHA256] lowercaseString];
    // 请求body参数
    NSDictionary *param = @{
        @"appKey":accessKey,
        @"encryption" : SHAencryptionStr,
        @"timestamp" : @(timeSp)
    };
    
    if(parameters){
        NSMutableDictionary* dic=  [NSMutableDictionary dictionaryWithDictionary:parameters];
        [dic addEntriesFromDictionary:param];
        param = dic;
    }
    
    AFHTTPSessionManager *manager = [self getBaseConfigedSessionManager];
    
    
    return  [manager POST:URLString parameters:param progress:uploadProgress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)task.response;
        if(response.statusCode != HttpOk){
            NSString* msg =[NSString stringWithFormat:@"request:%@ faild with code:%ld",response.URL.absoluteString, response.statusCode];
            failure(task,[self genError:ApimErrorRequestOkButBuzFail readableMsg:@"request failed" forReason:msg fromError:nil]);
        }
        if(!responseObject){
            NSString* msg =[NSString stringWithFormat:@"request:%@ has no response body",response.URL.absoluteString];
            failure(task,[self genError:ApimErrorRequestOkButBuzFail readableMsg:@"request has no response body" forReason:msg fromError:nil]);
        }
        NSUInteger businessStatus = [[responseObject objectForKey:@"status"] intValue];
        if(businessStatus != BusinessOK){
            NSString* msg =[NSString stringWithFormat:@"request:%@ failed with business code %ld",response.URL.absoluteString,businessStatus];
            failure(task,[self genError:ApimErrorRequestOkButBuzFail readableMsg:responseObject[@"msg"] forReason:msg fromError:nil]);
        }
        success(task ,responseObject[@"data"]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task, error);
    }];
    
}


#pragma mark public api
-(void) getToken:(void(^)(NSString*))succ fail:(FailureBlock)fail{
//    clear old info
    [[PublicDefine sharedInstance]  setApimAccessToken:nil];
    
    NSString *baseUrl = [[PublicDefine sharedInstance] getCurrentAPIMEnv];
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, POST_APIM_GET_TOKEN];
    
    [self POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *accessToken = responseObject[@"accessToken"];
        NSUInteger expire =[responseObject[@"expire"] integerValue];
        
        if(expire>EXPIRE_DELTA){
            [self saveApimtoken:responseObject];
            succ(accessToken);
        }else{
            [self refreshToken:accessToken success:succ andFail:fail];
        }
        
    } failure:fail];
}

-(void) refreshToken:(NSString*)tobeExpiredToken success:(void(^)(NSString*))succ andFail:(FailureBlock)fail{
    NSString *baseUrl = [[PublicDefine sharedInstance] getCurrentAPIMEnv];
    NSString *url = [NSString stringWithFormat:@"%@%@", baseUrl, POST_APIM_REFRESH_TOKEN];
    
    
    [self POST:url parameters:@{@"accessToken":tobeExpiredToken}
        progress:nil
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *accessToken = responseObject[@"accessToken"];
        [self saveApimtoken:responseObject];
        succ(accessToken);
        
    } failure:fail];
}

-(BOOL)cheackApimAccessTokenExpire {
    
    NSDictionary* tokenMap = [[PublicDefine sharedInstance] getApimAccessToken];
    if(tokenMap){
        long start = [tokenMap[@"ts"] longValue];
        long expire = [tokenMap[@"expire"] longValue];
        // 判断是否过期
        long nowTs = (long)[[NSDate date] timeIntervalSince1970] ;
        
        //    提前5分钟就判定失效
        if (start + expire - nowTs  > EXPIRE_DELTA) {
            return NO;
        }
    }
    return YES;
}

@end


