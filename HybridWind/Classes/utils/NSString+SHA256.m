//
//  NSString+SHA256.m
//  HybridWind
//
//  Created by syl on 2019/12/11.
//

#import "NSString+SHA256.h"
@implementation NSString (SHA256)
- (NSString *)SHA256
{
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [self hex:out];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
    
}

-(NSString*)hex:(NSData*)data{
     NSMutableData *result = [NSMutableData dataWithLength:2*data.length];
     unsigned const char* src = data.bytes;
     unsigned char* dst = result.mutableBytes;
     unsigned char t0, t1;

     for (int i = 0; i < data.length; i ++ ) {
          t0 = src[i] >> 4;
          t1 = src[i] & 0x0F;

          dst[i*2] = 48 + t0 + (t0 / 10) * 39;
          dst[i*2+1] = 48 + t1 + (t1 / 10) * 39;
     }

     return [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
}



+  (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

#pragma mark merged from hybrid-ios

-(BOOL)stringIsValid
{
    BOOL isVaild = false;
    if ([self isEqual:[NSNull null]]) {
        return false;
    }
    if (self != nil && ![self isEqualToString:@""] && ![self isEqualToString:@"(null)"]) {
        isVaild = YES;
    }
    
    return isVaild;
}

//判断是否为整形：
- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    NSInteger val;
    return [scan scanInteger:&val] && [scan isAtEnd];
}

@end
