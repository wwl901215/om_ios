//
//  UserInfoService.h
//  HybridWind
//
//  Created by syl on 2019/9/19.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"

typedef void (^GetUserInfoSuccess) (void);
typedef void (^GetUserInfoFailed) (NSError *err);


NS_ASSUME_NONNULL_BEGIN

@interface UserInfoService : BaseService
+(instancetype)sharedService;
-(void)getUserInfo:(GetUserInfoSuccess) success fail:(GetUserInfoFailed) fail;

/**
  use latest user info to add alias
 */
-(void)addAlias;
-(void)addAlias:(NSString * __nonnull)name type:(NSString * __nonnull)type;

/**
 remove current alias config
 */
- (void) removeAlias;
@end

NS_ASSUME_NONNULL_END
