//
//  SchemeRewritePlugin.m
//
//  Created by terence on 2019/10/31.
//

#import "SchemeRewritePlugin.h"

@implementation SchemeRewritePlugin

#define REWRITE_FILE_LIST @[@"envcontext.js", @"cordova.js"]
#define REWRITE_SCHEME @"enos://"
#define REWRITE_TEMPLATE @" src=\"%@\""

-(void)pluginInitialize
{
    self.urlSet = [[NSMutableSet alloc]initWithCapacity:10];
}

- (BOOL)shouldOverrideLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (request.URL == nil) {
        return YES;
    }
    if ( [self.urlSet containsObject:request.URL]) {
        [self.urlSet removeObject:request.URL];
        return YES;
    }
    NSData* fileData = [NSData dataWithContentsOfFile:(NSString*)[request URL]];
    NSString* orgContent = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    NSString* content = orgContent;
    for (int i = 0 ; i < REWRITE_FILE_LIST.count; i++) {
//        NSString* keyword = [NSString stringWithFormat:@" src=\"%@\"", REWRITE_FILE_LIST[i]];
        NSUInteger start = [orgContent rangeOfString:REWRITE_FILE_LIST[i]].location;
        if (start != NSNotFound) {
            NSString* newValue = [NSString stringWithFormat:@"%@%@", REWRITE_SCHEME, REWRITE_FILE_LIST[i]];
            content = [content stringByReplacingOccurrencesOfString:REWRITE_FILE_LIST[i] withString:newValue];
        }
    }
    if (![content isEqualToString:orgContent]) {
        [self.urlSet addObject:request.URL];
        [self.webViewEngine loadHTMLString:content baseURL:request.URL];
        return NO;
    }
    return YES;
}
@end
