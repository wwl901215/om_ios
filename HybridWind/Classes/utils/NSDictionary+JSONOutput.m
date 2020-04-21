//
//  NSDictionary+JSONOutput.m
//  HybridWind
//
//  Created by 史元君 on 2020/2/12.
//

#import "NSDictionary+JSONOutput.h"


@implementation NSDictionary (JSONOutput)

- (NSString *)descriptionWithLocale:(id)locale {
    NSString *output;
    @try {
        output = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        output = [output stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"]; // 处理\/转义字符
    } @catch (NSException *exception) {
        output = self.description;
    } @finally {
        
    }
    return  output;
}
@end
