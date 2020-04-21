//
//  NSString+SHA256.h
//  HybridWind
//
//  Created by syl on 2019/12/11.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SHA256)
- (NSString *)SHA256;
-(NSString*)hex:(NSData*)data;
+  (BOOL)isBlankString:(NSString *)aStr;

#pragma mark merged from hybrid-ios
- (BOOL)stringIsValid;
- (BOOL)isPureInt;

@end

NS_ASSUME_NONNULL_END
