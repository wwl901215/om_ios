//
//  MenuService.m
//  hybrid-demo
//
//  Created by syl on 2019/6/27.
//

#import "MenuService.h"
#import "PublicDefine.h"
#import "Uris.h"
#import "Persistent.h"
#import "Router.h"
#import "AppDelegate.h"
#import "CommonTools.h"
#import "LoginService.h"

@implementation MenuService
+(instancetype)sharedService{
    static MenuService *_menuService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _menuService = [[MenuService alloc] init];
    });
    return _menuService;
}
-(void)getAppList:(GetAppListSuccess) success fail: (GetMenuFailed) fail{
    NSString *urlBase = [[PublicDefine sharedInstance] getCurrentAPIMEnv];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", urlBase, POST_APP_LIST];
    [self fetchJSONWithUrl:strUrl header:@{AUTHORIZATION :[[PublicDefine sharedInstance] getAuthorization]} successWithBlock:^(NSHTTPURLResponse *task, id data) {
        DDLogDebug(@"getAppList = %@", data);
        NSArray *apps = [[data objectForKey:@"data"] objectForKey:@"apps"];
        if (apps && apps.count) {
            // 筛选出移动可用的应用
            NSArray *resultApp = [self handleAppListData:apps];
            NSArray *handledApps = [CommonTools handleArray:resultApp];
            if (handledApps && handledApps.count) {
                [[PublicDefine sharedInstance] setApps:handledApps];
                [[PublicDefine sharedInstance] setAppSelect:handledApps[0]];
                success(handledApps);
            }else{
                // 无任何app权限
                [[PublicDefine sharedInstance] setApps:@[]];
                [[PublicDefine sharedInstance] setAppSelect:@{}];
                [Router open:ERROR_ROUTE];
                NSString *message = NSLocalizedString(@"no_available_app", nil);
                AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
                [delegate showAlertWithMessage:message];
                success(@[]);
            }
        }else{
            // 无任何app权限
            [[PublicDefine sharedInstance] setApps:@[]];
            [[PublicDefine sharedInstance] setAppSelect:@{}];
            [Router open:ERROR_ROUTE];
            NSString *message = NSLocalizedString(@"no_available_app", nil);
            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate showAlertWithMessage:message];
            success(@[]);
        }
       
        
    } failure:^(NSError *err) {
        // 弹出获取app list失败的弹框
        NSString *message = [[err userInfo] objectForKey:@"message"];
        if(message ==nil){
           message = [err userInfo][NSLocalizedDescriptionKey];
        }
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate showAlertWithMessage:message];
        fail(err);
    }];
}

// 过滤出除了入口应用的mobile应用
- (NSArray *)handleAppListData: (NSArray *)apps {
    NSMutableArray *categories = [NSMutableArray new];
    NSString *accessKey = [[PublicDefine sharedInstance] getAPIMAppAccessKey];
    if (apps && apps.count) {
        for (NSDictionary *app in apps) {
            // status为web端字段，与mobile端无关
//            BOOL status = [[app objectForKey:@"status"] boolValue];
            BOOL type = [[app objectForKey:@"type"] boolValue];
            NSString *appid = [app objectForKey:@"id"];
            if (type && ![accessKey isEqualToString:appid]) {
                [categories addObject:app];
//                NSDictionary *category = [app objectForKey:@"category"];
//                NSMutableDictionary *categoryDic = [NSMutableDictionary dictionaryWithDictionary:category];
//                if (![self haveCategery:categories cate:categoryDic]) {
//                    [categories addObject:categoryDic];
//                }
//                for (NSDictionary *category in categories) {
//                    if ([category objectForKey:@"id"] == [[app objectForKey:@"category"] objectForKey:@"id"]) {
//                        NSMutableDictionary *appDic = [NSMutableDictionary dictionaryWithDictionary:app];
//                        [appDic removeObjectForKey:category];
//                        NSMutableArray *children = [category objectForKey:@"children"];
//                        if (!children) {
//                            children = [NSMutableArray new];
//                        }
//                        [children addObject:appDic];
//                        [categoryDic setValue:children forKey:@"children"];
//                    }
//                }
            }
        }
    }
    return categories;
}

- (BOOL)haveCategery:(NSMutableArray *)arr  cate:(NSDictionary *)dic{
    BOOL isHave = false;
    if (!arr.count) {
        isHave = false;
    }
    for (NSDictionary *app in arr) {
        NSString *categoryid = [app objectForKey:@"id"];
        NSString *currentId = [dic objectForKey:@"id"];
        if (categoryid == currentId) {
            isHave = true;
        }
    }
    return isHave;
    
}

-(void)getMenuListAndOpenDefaultMenu:(NSString *)appId {
    [self getMenuList:appId success:^(NSArray *menuList) {
        [self openFirstMenuAsDefault:menuList];
        DDLogDebug(@"###after open openFirstMenuAsDefault");
       [LoginService fireAutoLoginDoneEvent ];
    } fail:^(NSError *err) {
        NSString *message = [[err userInfo] objectForKey:@"message"];
        if(message ==nil){
            message = [err userInfo][NSLocalizedDescriptionKey];
        }
        [[PublicDefine sharedInstance] setMenus:@[]];
        [Router open:ERROR_ROUTE];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        [delegate showAlertWithMessage:message];
        [LoginService fireAutoLoginDoneEvent];
    }];
}

-(void)getMenuList:(NSString *)appId success:(void(^)(NSArray* menuList)) success fail:(nonnull GetMenuFailed)fail{
    
    //        define the func to deal with exception
    NSError* (^getError)(NSString*) = ^(NSString* message){
        NSDictionary<NSErrorUserInfoKey,id>* info = [NSDictionary dictionaryWithObjects:@[message, message] forKeys:@[@"message", NSLocalizedDescriptionKey ]];
        NSError* err = [NSError errorWithDomain:@"getMenuList Error" code:11 userInfo:info];
        return err;
    };
    
    //    // 获取文件路径
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"menus" ofType:@"json"];
//        // 将文件数据化
//        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//        // 对数据进行JSON格式化并返回字典形式
//        NSArray *appsMockData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSString *urlBase = [[PublicDefine sharedInstance] getCurrentAPIMEnv];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@?accessKey=%@", urlBase, POST_RESOURCE_LIST, appId];
    [self fetchJSONWithUrl:strUrl header:@{AUTHORIZATION :[[PublicDefine sharedInstance] getAuthorization]} successWithBlock:^(NSHTTPURLResponse *task, id data) {
                NSMutableDictionary *rep =[NSMutableDictionary dictionaryWithDictionary:data];
                NSDictionary *repData = [rep objectForKey:@"data"];
        
                if (!repData) {
                    fail(getError(NSLocalizedString(@"no_available_menu", nil)));
                }else{
                    NSArray *menus = [repData objectForKey:@"menus"];
                    NSArray *handledMenus = [CommonTools handleArray:menus];
                    if (handledMenus && handledMenus.count) {
                        DDLogDebug(@"###getMenu success");
                        success(handledMenus);
                    }else{
                        fail(getError(NSLocalizedString(@"no_available_menu", nil)));
                    }
                }
    } failure:^(NSError *err) {
         fail(err);
    }];
}

-(void) openFirstMenuAsDefault:(NSArray *)handledMenus {
    NSString *firstUrl = [self findFirstMenu:handledMenus];
    NSString *homePage = [[PublicDefine sharedInstance] getMenuSelect];
    [[PublicDefine sharedInstance] setMenus:handledMenus];
    if (!firstUrl) {
        if (homePage) {
            @try {
                [Router open:firstUrl];
                
            } @catch (NSException *exception) {
                [Router open:ERROR_ROUTE];
            } @finally {
            }
        }else{
            [Router open:ERROR_ROUTE];
        }
    }else {
        [[PublicDefine sharedInstance] setMenuSelect:firstUrl];
        [[PublicDefine sharedInstance] setMenuSelectSection:0];
        @try {
            [Router open:firstUrl];
            
        } @catch (NSException *exception) {
            [Router open:ERROR_ROUTE];
        } @finally {
        }
    }
}


- (NSString *)findFirstMenu:(NSArray *)appList{
    if (!appList.count) {
        return nil;
    }
    for (int i = 0; i < appList.count; i++) {
        NSDictionary *dic = appList[i];
        NSString *appUrl = [dic objectForKey:@"url"];
        if (appUrl.length) {
            return appUrl;
        }else{
            NSArray *child = [dic objectForKey:@"children"];
            for (int j = 0; j < child.count; j++) {
                NSDictionary *dic = child[j];
                if (dic && [dic objectForKey:@"url"]) {
                    NSString *url = [dic objectForKey:@"url"];
                    return url;
                }
            }
        }
    }
    return nil;
}



/**
 used to loop the inner structure of the menu list and find the matched menu by using the comparator
 */
- (NSDictionary *)findMenu:(NSArray *)menuList byComparator:(BOOL (^)(NSDictionary* menu))comparator{
    if (!menuList.count) {
        return nil;
    }
    for (NSDictionary* topMenu in menuList) {
        BOOL result = comparator(topMenu);
        if (result) {
            return topMenu;
        }else{
            NSArray *children = [topMenu objectForKey:@"children"];
            for (NSDictionary* child in children) {
                 BOOL result = comparator(child);
                if(result){
                    return child;
                }
            }
        }
    }
    return nil;
}
@end
