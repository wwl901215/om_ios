//
//  Router.m
//  EnvHybrid
//
//  Created by xuchao on 17/3/14.
//  Copyright © 2017年 envision. All rights reserved.
//

#import "Router.h"
#import "RouterBundleHelper.h"
#import "EnvHybridConstants.h"
#import "EnvVersionUtils.h"
#import "Routable.h"

@interface Router()

@property (nonatomic, strong) NSString *rootUrl;

@end

@implementation Router

+ (instancetype)sharedRouter {
    static Router *_router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _router = [Router new] ;
        _router.routerConfigArr = [NSMutableArray new];
        [[NSNotificationCenter defaultCenter] addObserver:_router selector:@selector(rollbackRoutes:) name:NotificationRouterRollback object:nil ];
        [[NSNotificationCenter defaultCenter] addObserver:_router selector:@selector(updateRouterConfigs:) name:NotificationUpdateroutersSuccess object:nil];
    });
    return _router;
}

#pragma mark - public methods

- (void)setRootUrl:(NSString *)rootUrl {
    _rootUrl = rootUrl;
}

- (void)initRoutes:(void (^)(NSError* _Nullable))complete {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if([RouterBundleHelper isFirstLaunchOrNativeUpdate]) {
            [RouterBundleHelper copyBundleResourceFromWebapp:^(NSError* error) {
                if(error==nil) {
                    [self buildRouters:^(NSError * err) {
                        if(err==nil){
                            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                            [EnvVersionUtils setCurrentVersion:version];
                        }
                         complete(err);
                    }];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        complete(error);
                    });
                }
                
            }];
        }else {
            [self buildRouters:^(NSError * err) {
                 complete(err);
            }];
        }
    });
}


- (NSString *)pathForUrl:(NSString *)url withParams:(NSDictionary *)params {
    NSString *path = nil;
    if(!self.rootUrl) {
        self.rootUrl = BUNDLES_BASE_PATH;
    }
    NSDictionary *extraParams = [params objectForKey:kExtraParams];
    
    NSString *concatUrl = [self concatUrl:url withParams:params];
    NSString *bundleName = [extraParams objectForKey:kName];
    //    NSRange range = [concatUrl rangeOfString:@"/index.html"];
    NSRange range = [concatUrl rangeOfString:bundleName];
    //change "/index.html" to "/bundles/index.html"
    //    NSString *bundlePath = [concatUrl stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"/%@/index.html", BUNDLES_PATH_NAME]];
    NSString *bundlePath = [concatUrl stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%@/%@", bundleName, BUNDLES_PATH_NAME]];
    NSString *remoteServer = [extraParams objectForKey:kRemoteServer];
    
    // setRootUrl 设置为私有方法，目前阶段，第一个分支永远不会执行
    if([self.rootUrl rangeOfString:@"http"].location == 0) {
        path = [NSString stringWithFormat:@"%@%@", self.rootUrl, concatUrl];
    }else if(remoteServer && [remoteServer hasPrefix:@"http"]) {
        path = [NSString stringWithFormat:@"%@%@", remoteServer, concatUrl];
    }else {
        path = [NSString stringWithFormat:@"%@%@", self.rootUrl, bundlePath];
        NSURL *url = [NSURL fileURLWithPath:path];
        // 把路径中的 %23 替换为原始符号 #
        path = [[url absoluteString] stringByReplacingOccurrencesOfString:@"%3F" withString:@"?"];
        path = [path stringByReplacingOccurrencesOfString:@"%23" withString:@"#"];
    }
    path = [self append:path withQueryDic:params];
    
    return path;
}


#pragma mark - private methods


/** the complete block is called async on main queue*/
-(void) buildRouters:(void (^)(NSError* _Nullable))complete {
    [RouterBundleHelper buildRouters:^(NSError * _Nullable err, NSArray<NSDictionary *> * _Nonnull routerConfigs) {
        [self resetRouterWith:routerConfigs];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(err);
        });
    }];
}

/**
 set the router urk to controller mapping
 */
-(void) resetRouterWith:(NSArray<NSDictionary *> * _Nonnull) routerConfigs {
    [self.routerConfigArr removeAllObjects];
    for(NSDictionary* dic in routerConfigs){
        [[Routable sharedRouter] map:dic[@"url"]
                        toController:dic[@"controllerClz"]
                         withOptions:[UPRouterOptions routerOptionsForDefaultParams:@{kExtraParams: dic[@"routeConfig"]}]];
    }
    [self.routerConfigArr addObjectsFromArray:routerConfigs];
}


- (void)rollbackRoutes:(NSNotification*) note{
    // TODO: OR use the self.routerConfigArr to reset the mapping?
    [self buildRouters:^(NSError * err) {
        if(err){
            NSLog(@"buildRouters err: %@", err);
        }
    }];
}

-(void)updateRouterConfigs:(NSNotification*) note {
    NSDictionary* dic = note.userInfo;
    NSError* err = dic[@"error"];
    NSArray<NSDictionary *>* configArr =dic[@"routerConfigs"];
    if(!err){
        [self  resetRouterWith:configArr];
    }else{
//        this is a temprary solution, the error should be display to user if there is any ui use the update function , and the error is pass out by complete block,so here only need to handle success case
        NSLog(@"update router faild %@", err);
    }
}

-(NSString*) append:(NSString*) url withQueryDic:(NSDictionary *)params {
    NSMutableArray* queryArr =[[NSMutableArray alloc] init];
    NSDictionary* queryDic = params[@"queryDic"];
    if(queryDic!=nil){
        for(NSString * key in queryDic){
            NSString *encodedQueryString = (NSString *)
            CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                      (CFStringRef)queryDic[key],
                                                                      NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                      kCFStringEncodingUTF8));
            [queryArr addObject: [NSString stringWithFormat:@"%@=%@", key ,encodedQueryString ]] ;
        }
    }
    
    NSString* queryStr = [queryArr componentsJoinedByString:@"&"] ;
    
    NSRange querySymbolRange =[url rangeOfString:@"?"];
    if(![@"" isEqualToString:queryStr]){
        NSUInteger location = querySymbolRange.location;
        if(location == NSNotFound){
            url = [NSString stringWithFormat:@"%@?%@", url, queryStr ];
        }else{
            NSString* replacement = [NSString stringWithFormat:@"?%@&",queryStr];
            url = [url stringByReplacingCharactersInRange:querySymbolRange withString:replacement];
        }
    }
    
    return url;
}
/**
 *  analysis and match the url and arguments
 *
 *  @param urlPatten url parttern eg. "/main/:id"
 *  @param params     eg. {id: 10, extraParams: {...}}
 *
 *  @return the combined url eg. "/main/10"
 */
-(NSString* )concatUrl:(NSString *) urlPatten withParams:(NSDictionary *) params {
    NSString *url = urlPatten;
    for(NSString *key in params.allKeys){
        if(![key isEqualToString:kExtraParams]){
            url = [url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@":%@", key] withString: [params objectForKey:key]];
        }
    }
    return url;
}

- (NSString *)routesFilePath {
    NSString *bundleBasePath = BUNDLES_BASE_PATH;
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentVersion];
    NSString *routeBasePath = [bundleBasePath stringByAppendingPathComponent:version];
    return [NSString stringWithFormat:@"%@/%@", routeBasePath, ROUTE_FILE_NAME];
}


#pragma mark - RouterProtocol

+ (void)open:(NSString *)url {
    // 对光伏进行硬修改
    if ([url containsString:@"s-solarmobilecross"] && ![url containsString:@"html"]) {
        NSMutableString *appendUrl = [NSMutableString stringWithString:url];
        [[Routable sharedRouter] open:[appendUrl stringByReplacingOccurrencesOfString:@"#" withString:@"index.html#"]];
    }else{
        [[Routable sharedRouter] open:url];
    }
}

+ (void)setNavigationController:(UINavigationController *)nav {
    [[Routable sharedRouter] setNavigationController:nav];
}

+ (void)map:(NSString *)format toController:(Class)controllerClass {
    [[Routable sharedRouter] map:format toController:controllerClass];
}

+ (void)open:(NSString *)url animated:(BOOL)animated extraParams:(NSDictionary *)extraParams{
    if ([url containsString:@"s-solarmobilecross"] && ![url containsString:@"html"]) {
        NSMutableString *appendUrl = [NSMutableString stringWithString:url];
        [[Routable sharedRouter] open:[appendUrl stringByReplacingOccurrencesOfString:@"#" withString:@"index.html#"] animated:animated extraParams:extraParams];
    }else{
        [[Routable sharedRouter] open:url animated:animated extraParams:extraParams];
    }
}

@end
