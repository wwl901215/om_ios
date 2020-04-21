

#import "PublicDefine.h"
#import "Strs.h"
#import "Persistent.h"

@implementation PublicDefine

@synthesize currentHost;
@synthesize currentAuth;

static PublicDefine *instance = nil;

+(PublicDefine *)sharedInstance
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

-(id)init
{
    self = [super init];
    return self;
}


-(NSString *)getCurrentHost
{
    NSString *currentEnv = [[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_ENV];
    return [self getCurrentHostByEnv:[currentEnv intValue]];
}

-(void)setCurrentEnv:(int)env
{
    [[NSUserDefaults standardUserDefaults] setInteger:env forKey:CURRENT_ENV];
}

-(NSUInteger)getCurrentEnv
{
    return  [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_ENV];;
}

- (NSString *)getCurrentAPIMEnv {
    NSString *currentEnv = [[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_ENV];
    return [self getCurrentAPIMServerByEnv:[currentEnv intValue]];
}


-(NSString *)getCurrentHostByEnv:(int)env {
    NSString *host = @"";
    NSArray *list = [[NSBundle mainBundle] objectForInfoDictionaryKey:ENVIRONMENT_LIST];
    NSString *envStr = [list[env] objectForKey:ENVIRONMENT];
    if ([envStr isEqualToString:@"env_us"]) {
        host = US_SERVER;
    }else if ([envStr isEqualToString:@"env_ch"]){
        host = CN_SERVER;
    }else if ([envStr isEqualToString:@"env_eur"]){
        host = EU_SERVER;
    }else if ([envStr isEqualToString:@"env_ppe"]){
         host = PPE_SERVER;
    }else if ([envStr isEqualToString:@"env_shdl"]){
        host = SHDL_SERVER;
    }else if ([envStr isEqualToString:@"env_hbjt"]){
        host = HBJT_SERVER;
    }else if ([envStr isEqualToString:@"env_gf"]){
        host = GUANGFA_SERVER;
    }else if ([envStr isEqualToString:@"env_india"]){
        host = INDIA_SERVER;
    }
    return host;
}

- (NSString *)getCurrentAPIMServerByEnv:(int)env {
    NSString *host = @"";
    NSArray *list = [[NSBundle mainBundle] objectForInfoDictionaryKey:ENVIRONMENT_LIST];
    NSString *envStr = [list[env] objectForKey:ENVIRONMENT];
    if ([envStr isEqualToString:@"env_us"]) {
        host = US_SERVER_APIM;
    }else if ([envStr isEqualToString:@"env_ch"]){
        host = CN_SERVER_APIM;
    }else if ([envStr isEqualToString:@"env_eur"]){
        host = EU_SERVER_APIM;
    }else if ([envStr isEqualToString:@"env_ppe"]){
        host = PPE_SERVER_APIM;
    }else if ([envStr isEqualToString:@"env_shdl"]){
        host = SHDL_SERVER_APIM;
    }else if ([envStr isEqualToString:@"env_hbjt"]){
        host = HBJT_SERVER_APIM;
    }else if ([envStr isEqualToString:@"env_gf"]){
        host = GUANGFA_SERVER_APIM;
    }else if ([envStr isEqualToString:@"env_india"]){
        host = INDIA_SERVER_APIM;
    }
    
    return host;
}


-(NSString *)getCurrentAuthValue
{
    if(!self.currentAuth) {
        NSString *authType = [[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_AUTH_TYPE];
        self.currentAuth = [self getCurrentAuthByType:[authType intValue]];
    }
    return self.currentAuth;
    
}

-(void)setCurrentAuthType:(AuthType)authType
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",authType] forKey:CURRENT_AUTH_TYPE];
    self.currentAuth = [self getCurrentAuthByType:authType];
}

-(NSString *)getCurrentAuthType
{
    NSString *authType = [[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_AUTH_TYPE];
    return authType;
}

-(NSString *)getCurrentAuthByType:(AuthType)type {
    NSString *auth = @"";
    switch (type) {
            case Default:
        {
            auth = AUTH_TYPE_DEFAULT;
            break;
        }
            case Portal:
        {
            auth = AUTH_TYPE_PORTAL;
            break;
        }
        default:
            auth = AUTH_TYPE_DEFAULT;
            break;
    }
    return auth;
}

-(NSString *)currentLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    return currentLang;
}

-(NSString *) getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return app_build;
}

-(NSString *)getAuthorization {
    NSDictionary *loginInfo = [Persistent readFromFile:LOGIN_INFO];
    NSString *accessToken = [loginInfo objectForKey:ACCESSTOKEN];
    return [NSString stringWithFormat:@"Bearer %@", accessToken];
}

-(void)setCurrentAPIMApp:(NSDictionary *)app{
    [[NSUserDefaults standardUserDefaults] setObject:app forKey:CURRENT_APIM_APP];
}

- (NSString *)getAPIMAppAccessKey {
    NSDictionary *app = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_APIM_APP];
    NSString *accessKey = [app objectForKey: CURRENT_APIM_APP_KEY];
    return accessKey;
}
- (NSString *)getAPIMAppSecretKey {
    NSDictionary *app = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_APIM_APP];
    NSString *secret = [app objectForKey: CURRENT_APIM_APP_SECRET_KEY];
    return secret;
}

-(void)setCurrentAppKey:(NSString *)appkey {
    [[NSUserDefaults standardUserDefaults] setObject:appkey forKey:CURRENT_APP_KEY];
}


-(NSString *)getCurrentAppKey {
    return [[NSUserDefaults standardUserDefaults] valueForKey:CURRENT_APP_KEY];
}

-(void)setHomePage:(NSString *)homepage {
    [[NSUserDefaults standardUserDefaults] setObject:homepage forKey:HOME_PAGE_ROUTE];
}
-(NSString *)getHomePage{
    return [[NSUserDefaults standardUserDefaults] objectForKey:HOME_PAGE_ROUTE];
}

-(void)setMenus:(NSArray *)menus {
    [[NSUserDefaults standardUserDefaults] setObject:menus forKey:MENUS];
}


-(NSArray *)getMenus {
    return [[NSUserDefaults standardUserDefaults] objectForKey:MENUS];
}

-(void)setApps:(NSArray *)apps {
    [[NSUserDefaults standardUserDefaults] setObject:apps forKey:APPS];

}
-(NSArray *)getApps {
    return [[NSUserDefaults standardUserDefaults] objectForKey:APPS];

}

- (void)setOrgSelect:(NSString *)orgSelect {
    [[NSUserDefaults standardUserDefaults] setObject:orgSelect forKey:ORG_SELECT];
    
}
- (NSString *)getOrgSelect{
    return [[NSUserDefaults standardUserDefaults] objectForKey:ORG_SELECT];
    
}

- (void)setMenuSelect:(NSString *)menuSelect{
    [[NSUserDefaults standardUserDefaults] setObject:menuSelect forKey:MENU_SELECT];
}
- (NSString *)getMenuSelect{
    return [[NSUserDefaults standardUserDefaults] objectForKey:MENU_SELECT];
}

- (void)setMenuSelectSection:(NSUInteger)setMenuSelectSection {
    [[NSUserDefaults standardUserDefaults] setObject:@(setMenuSelectSection) forKey:MENU_SELECT_SECTION];
}
- (NSUInteger)getMenuSelectSection {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:MENU_SELECT_SECTION] integerValue];

}

- (void)setAppSelect:(NSDictionary *)appSelect {
    [[NSUserDefaults standardUserDefaults] setObject:appSelect forKey:APP_SELECT];
}
- (NSDictionary *)getAppSelect {
    return [[NSUserDefaults standardUserDefaults] objectForKey:APP_SELECT];
}

//- (void)setAppSelectName:(NSString *)appSelectName {
//    [[NSUserDefaults standardUserDefaults] setObject:appSelectName forKey:APP_SELECT_NAME];
//}
//- (NSString *)getAppSelectName {
//    return [[NSUserDefaults standardUserDefaults] objectForKey:APP_SELECT_NAME];
//}

- (void)setApimAccessToken:(NSDictionary *)apimAccessTokenDic {
    [[NSUserDefaults standardUserDefaults] setObject:apimAccessTokenDic forKey:APIM_ACCESS_TOKEN];

}
- (NSDictionary *)getApimAccessToken {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:APIM_ACCESS_TOKEN];
}


- (void)clearAllData {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:CURRENT_ENV];
    [userDefault removeObjectForKey:CURRENT_AUTH_TYPE];
    [userDefault removeObjectForKey:CURRENT_APIM_APP_KEY];
    [userDefault removeObjectForKey:HOME_PAGE_ROUTE];
    [userDefault removeObjectForKey:MENUS];
    [userDefault removeObjectForKey:ORG_SELECT];
    [userDefault removeObjectForKey:MENU_SELECT];
    [userDefault removeObjectForKey:APP_SELECT];
    [userDefault removeObjectForKey:APIM_ACCESS_TOKEN];
    [userDefault removeObjectForKey:APPS];

}

- (NSArray *)handleArray:(NSArray *)arr {
    if (!arr.count) {
        return @[];
    }
    NSMutableArray *resutArr = [NSMutableArray new];
    for (NSDictionary *category in arr) {
        NSMutableDictionary *muteCategory = [NSMutableDictionary dictionaryWithDictionary:category];
        [category enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"children"]) {
                NSArray *children = [muteCategory objectForKey:@"children"];
                NSMutableArray *muteChildren = [NSMutableArray new];
                if (children.count > 0) {
                    for (NSDictionary *dic in children) {
                        NSMutableDictionary *mutaDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            if ([[mutaDic objectForKey:key] isEqual:[NSNull null]]) {
                                [mutaDic setObject:@"" forKey:key];
                            }
                        }];
                        [muteChildren addObject:mutaDic];
                    };
                }
                [muteCategory removeObjectForKey:@"children"];
                [muteCategory setObject:muteChildren forKey:@"children"];
            } else if([key isEqualToString:@"category"]){
                NSMutableDictionary *mutaDic = [NSMutableDictionary dictionaryWithDictionary:[category objectForKey:@"category"]];
                [mutaDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if([[mutaDic objectForKey:key] isEqual:[NSNull null]]){
                        [mutaDic setObject:@"" forKey:key];
                    }
                }];
                [muteCategory removeObjectForKey:@"category"];
                [muteCategory setObject:mutaDic forKey:@"category"];
                
            }else{
                if([[muteCategory objectForKey:key] isEqual:[NSNull null]]){
                    [muteCategory setObject:@"" forKey:key];
                }
            }
            
        }];
        [resutArr addObject:muteCategory];
    }
    return resutArr;
}






@end
