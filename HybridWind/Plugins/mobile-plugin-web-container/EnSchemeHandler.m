//
//  EnSchemeHandler.m
//
//  Created by terence on 2019/10/16.
//

#import "EnSchemeHandler.h"
#import "EnvContextProvider.h"

#define FILE_LIST @[@"cordova.js", @"cordova_plugins.js", @"plugins/", @"cordova-js-src/"]
#define ENV_CONTEXT_FILE @"envcontext.js"

@implementation EnSchemeHandler

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask API_AVAILABLE(ios(11.0))
{
    NSData *fileData;
    NSUInteger start;
    start = [urlSchemeTask.request.URL.absoluteString rangeOfString:ENV_CONTEXT_FILE].location;
    if (start != NSNotFound) {
        fileData = [[EnvContextProvider getEnvContext] dataUsingEncoding:NSUTF8StringEncoding];
    } else {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"www" ofType:nil];
        for (int i = 0 ; i < FILE_LIST.count; i++) {
            start = [urlSchemeTask.request.URL.absoluteString rangeOfString:FILE_LIST[i]].location;
            if (start != NSNotFound) {
                NSString *subUrl = [urlSchemeTask.request.URL.absoluteString substringFromIndex:start];
                NSString *soursePath = [bundlePath stringByAppendingPathComponent:subUrl];
                fileData = [NSData dataWithContentsOfFile:soursePath];
                break;
            }
        }
    }
    if (fileData) {
        NSDictionary *responseHeader = @{@"Content-type":@"application/javascript;charset=UTF-8", @"Content-length":[NSString stringWithFormat:@"%lu",(unsigned long)[fileData length]]};
        NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:urlSchemeTask.request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:responseHeader];
        [urlSchemeTask didReceiveResponse:response];
        [urlSchemeTask didReceiveData:fileData];
        [urlSchemeTask didFinish];
    }
}

- (void)webView:(nonnull WKWebView *)webView stopURLSchemeTask:(nonnull id<WKURLSchemeTask>)urlSchemeTask {
    return;
}

@end
