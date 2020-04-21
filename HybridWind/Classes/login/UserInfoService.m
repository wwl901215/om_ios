//
//  UserInfoService.m
//  HybridWind
//
//  Created by syl on 2019/9/19.
//

#import "UserInfoService.h"
#import "PublicDefine.h"
#import "Uris.h"
#import "Persistent.h"
#import "EnvAppData.h"
#import <UMPush/UMessage.h>
#import "DAConfig.h"

@implementation UserInfoService{
    NSString* _aliasName;
    NSString* _aliasType;
}
+(instancetype)sharedService {
    static UserInfoService *_userInfoService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userInfoService = [[UserInfoService alloc] init];
    });
    return _userInfoService;
}

-(void)getUserInfo:(GetUserInfoSuccess) success fail:(GetUserInfoFailed) fail{
    NSString *urlBase = [[PublicDefine sharedInstance] getCurrentAPIMEnv];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", urlBase, GET_USER_INFO];
    [self fetchJSONWithUrl:strUrl   header: @{AUTHORIZATION :[[PublicDefine sharedInstance] getAuthorization]}  successWithBlock:^(NSHTTPURLResponse *task, id data) {
        NSMutableDictionary *rep =[NSMutableDictionary dictionaryWithDictionary:data];
        NSDictionary *repData = [rep objectForKey:@"data"];
        if (!repData) {
            fail([rep objectForKey:@"message"]);
        }else{
            NSString *email = [repData objectForKey:@"email"];
            if (email) {
                [[EnvAppData sharedData] savePersistentItem:email forKey:[NSString stringWithFormat:@"%@email", USERDEFAULT_PRIFIX]];
            }
        }
    } failure:^(NSError *err) {
         fail(err);
    }];
}

-(void)addAlias{
    NSDictionary* userInfo = [Persistent readFromFile:LOGIN_INFO];
    [self addAlias:userInfo[@"userName"]  type:userInfo[@"workingOrganizationId"]];
}

-(void)addAlias:(NSString * __nonnull)name type:(NSString * __nonnull)type{
    
    NSString* lang = [[DAConfig getUserLanguage] substringToIndex:2];// [[self language ] substringToIndex:2];
    NSString* newType = [NSString stringWithFormat:@"%@_%@",type,lang ];
    
    if(self->_aliasName != nil
       && (
           ![self->_aliasName isEqualToString:name]
           || ![self->_aliasType isEqualToString:newType]
           )
       ) {
//      compare and  remove old alias first
        [UMessage removeAlias:self->_aliasName type:self->_aliasType response:^(id response, NSError* error){
            if(error==nil && !response[@"errors"]){
                DDLogDebug(@"remove  old alias for user successful");
            }else{
                DDLogWarn(@"remove  old alias for user faild: %@ : %@", error, response );
            }
        }];
    }
    
    self->_aliasName =name;
    self->_aliasType = newType;
    
    [UMessage addAlias:name type:newType  response:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if(error == nil && !responseObject[@"errors"]){
            DDLogDebug(@"register Umeng Alias successful: %@" , responseObject);
        }else{
            DDLogWarn(@"register Umeng Alias failed : %@ :%@", error, responseObject);
        }
    }];
}


- (void) removeAlias {
    if(self->_aliasName!=nil){
        [UMessage removeAlias:self->_aliasName type:self->_aliasType response:^(id response, NSError* error){
             if(error == nil && !response[@"errors"]){
                 DDLogDebug(@"remove alias for user successful");
                 self->_aliasName = nil;
                 self->_aliasType = nil;
             }else{
                 DDLogWarn(@"remove alias failed : %@ : %@", response ,error);
             }
        }];
    }
}

@end
