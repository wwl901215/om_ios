

#import <Foundation/Foundation.h>
#import "Strs.h"


@interface PublicDefine : NSObject

@property(nonatomic,strong) NSString *currentHost;
@property(nonatomic,strong) NSString *currentAuth;
@property (nonatomic, strong) NSArray *menus;
@property (nonatomic, strong) NSString *orgSelect;
@property (nonatomic, strong) NSString *menuSelect;
@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *homePage;




+(PublicDefine *)sharedInstance;

- (NSString *)getCurrentHost;//服务器

- (NSUInteger)getCurrentEnv;

- (NSString *)getCurrentAPIMEnv;


- (void)setCurrentEnv:(int)env;

- (NSString *)getCurrentAuthValue;//认证方式

- (NSString *)getCurrentAuthType;

- (void)setCurrentAuthType:(AuthType)env;

-(NSString *)getAuthorization;

-(void)setCurrentAPIMApp:(NSDictionary *)app;

-(void)setCurrentAppKey:(NSString *)appkey;
-(NSString *)getCurrentAppKey;

-(void)setHomePage:(NSString *)homepage;

-(NSString *)getHomePage;

-(void)setMenus:(NSArray *)menus;
-(NSArray *)getMenus;

-(void)setApps:(NSArray *)apps;
-(NSArray *)getApps;

- (void)setOrgSelect:(NSString *)orgSelect;
- (NSString *)getOrgSelect;

- (void)setMenuSelect:(NSString *)menuSelect;
- (NSString *)getMenuSelect;

- (void)setMenuSelectSection:(NSUInteger)setMenuSelectSection;
- (NSUInteger)getMenuSelectSection;

- (void)setAppSelect:(NSDictionary *)appSelect;
- (NSDictionary *)getAppSelect;

- (void)setAppSelectName:(NSString *)appSelectName;
- (NSString *)getAppSelectName;

/**
    the apimAccessTokenDic has a shape like
 {
    accessToken: string
    expire: long  -   seconds
    ts: long  - the timestamp store the data in seconds
 }
 */
- (void)setApimAccessToken:(NSDictionary *)apimAccessTokenDic;
- (NSDictionary *)getApimAccessToken;


- (NSString *)getAPIMAppAccessKey;
- (NSString *)getAPIMAppSecretKey;



- (void)clearAllData;
-(NSArray *)handleArray:(NSArray *)arr;


@end
