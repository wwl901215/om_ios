#import "EnvContextPlugin.h"
#import "PublicDefine.h"
#import "Persistent.h"
#define ENV_CONTEXT_SCRIPT  @"envcontext.js"

@implementation EnvContextPlugin
-(void)pluginInitialize
{
    [NSURLProtocol registerClass:[EnvContextURLProtocol class]];
}
@end


@implementation EnvContextURLProtocol
/**
 * @return 提供要写入envcontext.js的内容
 */
-(NSString * )contextScript
{
    NSString* urlBase = [[PublicDefine sharedInstance] getCurrentHost];
    NSDictionary *loginInfo = [Persistent readFromFile:LOGIN_INFO];
    NSString *accesstoken = [loginInfo objectForKey:ACCESSTOKEN];
    NSString *userName = [loginInfo objectForKey:USERNAME];
    NSString *orgId;
    NSString *workingOrganizationId = [loginInfo objectForKey:WORKING_PRG];
    NSString *currentOrgId = [loginInfo objectForKey:CURRENT_PRG];
    if (currentOrgId) {
        orgId = currentOrgId;
    }
    if (workingOrganizationId) {
        orgId = workingOrganizationId;
    }
    NSString *customerId = [loginInfo objectForKey:USERID];
    NSString *refreshToken = [loginInfo objectForKey:REFRESHTOKEN];
    NSString *appId = [[[PublicDefine sharedInstance] getAppSelect] objectForKey:@"id"];
    return [NSString stringWithFormat:@"window.navigator.serverAddress = '%@';window.navigator.accessToken = '%@'; window.navigator.workingOrganizationId = '%@'; window.navigator.appId = '%@'; window.navigator.refreshToken = '%@'; window.navigator.customerId = '%@';  window.navigator.customerName = '%@';", urlBase, accesstoken, orgId, appId, refreshToken, customerId, userName];
}

#pragma mark
#pragma mark NSURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest*)request
{
    NSURL* url = [request URL];
    if([url.absoluteString rangeOfString:ENV_CONTEXT_SCRIPT].location != NSNotFound){
        return YES;
    }else if([url.absoluteString rangeOfString:@"cordova_plugins.js"].location != NSNotFound){
        return YES;
    }else if ([url.absoluteString rangeOfString:@"cordova.js"].location != NSNotFound){
        return YES;
    }else if ([url.absoluteString rangeOfString:@"plugins/"].location != NSNotFound){
        return YES;
    }else if ([url.absoluteString rangeOfString:@"cordova-js-src/"].location != NSNotFound){
        return YES;
    }else if([url.absoluteString rangeOfString:@"raven.min.js.map"].location != NSNotFound){
        return YES;
    }else {
        return NO;
    }

}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request
{
    return request;
}

- (void)startLoading
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"www" ofType:nil];
    NSArray *arr = @[@"cordova_plugins.js",@"cordova.js",@"plugins/",@"cordova-js-src/",ENV_CONTEXT_SCRIPT];
    for (int i = 0 ; i< arr.count; i++) {
        NSUInteger start = [[self.request URL].absoluteString rangeOfString:arr[i]].location;
        NSData *data;
        if (start != NSNotFound && ![arr[i] isEqualToString:ENV_CONTEXT_SCRIPT]) {
            NSString *subUrl = [self.request.URL.absoluteString substringFromIndex:start];
            NSString *soursePath = [bundlePath stringByAppendingPathComponent:subUrl];
            data = [NSData dataWithContentsOfFile:soursePath];
        }else if (start != NSNotFound && [arr[i] isEqualToString:ENV_CONTEXT_SCRIPT]){
            data = [[self contextScript] dataUsingEncoding:NSUTF8StringEncoding];
        }
        if (data) {
                NSHTTPURLResponse* response = nil;
                NSDictionary * headersDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%lu",data.length], @"Content-Length",@"application/javascript;charset=UTF-8",@"Content-Type",nil];
                response = [[NSHTTPURLResponse alloc] initWithURL:[self.request URL] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headersDict];
                
                [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowedInMemoryOnly];
                [self.client URLProtocol:self didLoadData:data];
                [self.client URLProtocolDidFinishLoading:self];
            break;
        }
    }
}

- (void)stopLoading
{
    
}
@end
