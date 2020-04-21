//
//  CommonTools.h
//  HybridWind
//
//  Created by syl on 2019/12/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonTools : NSObject
+(NSString *)signStr:(NSMutableDictionary*)dict;

+(NSString *)convertToJsonData:(NSDictionary *)dict;

+(NSArray *)handleArray:(NSArray *)arr;
@end

NS_ASSUME_NONNULL_END
