//
//  UmengAliasRequestInteceptor.m
//  HybridWind
//
//  Created by 史元君 on 2020/2/21.
//
#import "UmengAliasRequestInteceptor.h"
#import "AppDelegate+UmengPush.h"

#pragma mark UmengAliasRequestInteceptor
static NSString* const  URL2MODIFY = @"https://msg.umengcloud.com/alias";
static NSString * const hasInitKey = @"ENOS_UMENG_KEY";

#define appkeyInReqDic  @"appkey"
#define headerKeyInReqDic @"header"

@implementation UmengAliasRequestInteceptor
+ (BOOL)canInitWithRequest:(NSURLRequest*)request {
    NSString* url = [[request URL] absoluteString];
    if([url isEqualToString:URL2MODIFY]
       && ![NSURLProtocol propertyForKey:hasInitKey inRequest:request]){
        return YES;
    }
    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request
{
    
    NSMutableURLRequest* req = (NSMutableURLRequest*)request;
    NSData* body = [req HTTPBody];
    [NSURLProtocol setProperty:@YES forKey:hasInitKey inRequest:req];
 
//    NSString* jsonStr= [[NSString alloc] initWithBytes:body.bytes length:body.length encoding:NSUTF8StringEncoding];
//    convert byte back to json
    NSError* error;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:body
                                                            options:NSJSONReadingMutableContainers
                                                              error: &error];
    if(!error){
        BOOL isAppkeyExists = dic[headerKeyInReqDic][appkeyInReqDic] != nil;
        if(!isAppkeyExists){
            NSMutableDictionary* bodyDic =[NSMutableDictionary dictionaryWithDictionary:dic];
            NSDictionary* infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString* umengAppKey = infoDic[APPKEY_IN_PLIST];
            bodyDic[headerKeyInReqDic][appkeyInReqDic] = umengAppKey;
            
             NSError* writeError;
            NSData* newReqBody = [NSJSONSerialization  dataWithJSONObject:bodyDic options:NSJSONWritingPrettyPrinted error:&writeError];
            if(!writeError){
                 req.HTTPBody =newReqBody;
            }
            return req;
        }
    }else{
        NSLog(@"ENOS-Plug-Umeng:request body turn to dic error:%@", error);
    }

    return request;
}


- (void)startLoading
{
    NSURLSession *session = [NSURLSession sharedSession];
    __weak UmengAliasRequestInteceptor* weakSelf = self;

   NSURLSessionDataTask* task = [session dataTaskWithRequest:[self request] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        [[weakSelf client] URLProtocol:weakSelf didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [[weakSelf client] URLProtocol:weakSelf didLoadData:data ];
        
        if(error){
            [[weakSelf client] URLProtocol:weakSelf didFailWithError:error];
            return;
        }
        [[weakSelf client] URLProtocolDidFinishLoading:weakSelf];
    }];
    
    [task resume];

}

- (void)stopLoading
{
    
}


@end
