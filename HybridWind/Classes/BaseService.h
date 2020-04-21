

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^EnvServiceSuccess) (NSHTTPURLResponse* task, id data);
typedef void (^EnvServiceFailed) (NSError*);
typedef void (^GetApimAccessTokenSuccess) (void);

typedef NS_ENUM(NSInteger, MethodType){
    MethodGet = 1,
    MethodPost = 2
};

typedef void(^HTTPFailureHandler)( NSURLSessionDataTask *_Nullable task , NSError * _Nullable error );

static NSString * currentUserName;
static NSString * currentLoginId;
static NSString * currentSessionId;

@interface BaseService : NSObject
@property(nonatomic, copy) HTTPFailureHandler failureHandler;

-(void) fetchJSONWithUrl:(NSString *) url   header:(NSDictionary *)header successWithBlock:(EnvServiceSuccess) succ
                 failure:(EnvServiceFailed) fail;
    
-(void) postJSONWithUrl:(NSString *) url content:(NSDictionary*) body header:(NSDictionary *)header   successWithBlock:(EnvServiceSuccess) succ
                failure:(EnvServiceFailed) fail;



-(AFHTTPSessionManager*)getBaseConfigedSessionManager;
    @end
