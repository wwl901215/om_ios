//
//  ApimService.h
//  HybridWind
//
//  Created by 史元君 on 2020/2/26.
//

#ifndef ApimService_h
#define ApimService_h

#import "BaseService.h"


//net work response status code
typedef NS_ENUM(NSInteger,HttpStatuCode) {
    HttpOk = 200, //ok
    HttpUnauthenticated = 401,
    HttpForbidden = 403,
    HttpNotFound = 404,
    HttpRequestTimeOut = 408,
    HttpServerError = 500,
    HttpBadGateway = 502,
    HttpServiceUnavailable = 503,
    HttpGatewayTimeout = 504,
};
// business status code
typedef NS_ENUM(NSInteger,BusinessCode) {
    BusinessOK = 0, //ok
    RequestDuplicated = 1001, //重复请求，使用了相同的 encryption
    AppNotExist = 1002, //appKey 不存在
    EncryptionInvalid = 1003, //encryption 不合法
    ParamterIllegal = 1004, //参数不合法
    ServerError = 1005, //内部服务异常
    ParamterIsEmpty = 1202, //参数非空
    AccessTokenExpired = 1203, //Access Token已过期
    RefreshAccessTokenFaild = 1204, //刷新Access Token失败
};

typedef NS_ENUM(NSInteger,ApimErrorCode) {
    ApimErrorRequestOkButBuzFail = -1 //ok
};

typedef void (^FailureBlock)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull);


@interface ApimService: BaseService
+(instancetype _Nonnull )sharedService;

-(void) getToken:(void(^_Nonnull)(NSString*_Nonnull))succ fail:(FailureBlock _Nonnull )fail;
-(void) refreshToken:(NSString*_Nonnull)tobeExpiredToken success:(void(^_Nonnull)(NSString*_Nonnull))succ andFail:(FailureBlock _Nonnull )fail;
-(BOOL) cheackApimAccessTokenExpire;

@end


#endif /* ApimService_h */
