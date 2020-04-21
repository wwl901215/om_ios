//
//  MenuService.h
//  hybrid-demo
//
//  Created by syl on 2019/6/27.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"
typedef void (^GetAppListSuccess) (NSArray *appList);
typedef void (^GetMenuFailed) (NSError *err);

NS_ASSUME_NONNULL_BEGIN

@interface MenuService :BaseService
+(instancetype)sharedService;
-(void)getAppList:(GetAppListSuccess) success fail: (GetMenuFailed) fail;
-(void)getMenuList:(NSString *)appId success:(GetAppListSuccess) success fail: (GetMenuFailed) fail;
-(void)getMenuListAndOpenDefaultMenu:(NSString *)appId;
- (NSString *)findFirstMenu:(NSArray *)appList;
- (NSDictionary *)findMenu:(NSArray *)menuList byComparator:(BOOL (^)(NSDictionary* menu))comparator;
@end

NS_ASSUME_NONNULL_END
