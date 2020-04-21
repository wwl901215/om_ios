//
//  DAConfig.m
//  kusos
//
//  Created by zhenghuiyu on 2018/9/6.
//
//


#import "DAConfig.h"
#import "NSBundle+DAUtils.h"

static NSString *const UWUserLanguageKey = @"UWUserLanguageKey";
#define STANDARD_USER_DEFAULT  [NSUserDefaults standardUserDefaults]

@implementation DAConfig


+ (void)setLanguageCookie:(NSURL*) url {
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    // 设置语言cookie
    NSMutableDictionary *properties =[NSMutableDictionary dictionary];
    [properties setValue:[NSBundle isChineseLanguage]?@"zh":@"en" forKey:NSHTTPCookieValue];
    [properties setValue:@"locale" forKey:NSHTTPCookieName];
    [properties setObject:[url host]?[url host]:@".^filecookies^" forKey:NSHTTPCookieDomain];
    [properties setObject:@"/" forKey:NSHTTPCookiePath];
    [properties setObject:@"0" forKey:NSHTTPCookieVersion];
    //将cookie过期时间设置为一年后
    NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30];
    properties[NSHTTPCookieExpires] = expiresDate;
    //下面一行是关键,删除Cookies的discard字段，应用退出，会话结束的时候继续保留Cookies
    [properties removeObjectForKey:NSHTTPCookieDiscard];
    NSHTTPCookie *languageCookie = [NSHTTPCookie cookieWithProperties:properties];
    [cookieStorage setCookie:languageCookie];
}

+ (void)setUserLanguage:(NSString *)userLanguage
{
    //默认英语
    if (!userLanguage.length || ![userLanguage hasPrefix:@"zh"]) {
        userLanguage = CONFIG_LANGUAGE_EN;
    }
    //用户自定义
    [STANDARD_USER_DEFAULT setValue:userLanguage forKey:UWUserLanguageKey];
    [STANDARD_USER_DEFAULT setValue:@[userLanguage] forKey:@"AppleLanguages"];
    [STANDARD_USER_DEFAULT synchronize];
}

+ (NSString *)getUserLanguage
{
    if ([STANDARD_USER_DEFAULT valueForKey:UWUserLanguageKey]) {
        return [STANDARD_USER_DEFAULT valueForKey:UWUserLanguageKey];
    }
    return  [STANDARD_USER_DEFAULT valueForKey:@"AppleLanguages"][0];
}

/**
 重置系统语言
 */
+ (void)resetSystemLanguage
{
    [STANDARD_USER_DEFAULT removeObjectForKey:UWUserLanguageKey];
    [STANDARD_USER_DEFAULT setValue:nil forKey:@"AppleLanguages"];
    [STANDARD_USER_DEFAULT synchronize];
}

@end
