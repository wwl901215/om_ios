//
//  CommonTools.m
//  HybridWind
//
//  Created by syl on 2019/12/11.
//

#import "CommonTools.h"

@implementation CommonTools
+(NSString *)signStr:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        
        if (![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![[dict objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[dict objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@%@", categoryId, [dict objectForKey:categoryId]];
        }
    }
    return contentString;
}

+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        DDLogWarn(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
    
}

+ (NSArray *)handleArray:(NSArray *)arr {
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
