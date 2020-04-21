//
//  EnvContextProvider.m
//  hybrid-demo
//
//  Created by terence on 2019/10/29.
//

#import <Foundation/Foundation.h>
#import "EnvContextProvider.h"
#import "PublicDefine.h"
#import "Persistent.h"

@implementation EnvContextProvider

+ (NSString*)getEnvContext
{
    // Return custom js content
    NSString* urlBase = [[PublicDefine sharedInstance] getCurrentHost];
    NSDictionary *loginInfo = [Persistent readFromFile:LOGIN_INFO];
    NSString *accesstoken = [loginInfo objectForKey:ACCESSTOKEN];
    NSString *userName = [loginInfo objectForKey:USERNAME];
    NSString *orgId;
    NSString *workingOrganizationId = [loginInfo objectForKey:WORKING_PRG];
    NSString *currentOrgId = [loginInfo objectForKey:CURRENT_PRG];
    if (currentOrgId) {
        orgId = currentOrgId;
    }
    if (workingOrganizationId) {
        orgId = workingOrganizationId;
    }
    NSString *customerId = [loginInfo objectForKey:USERID];
    NSString *refreshToken = [loginInfo objectForKey:REFRESHTOKEN];
    NSString *appId = [[[PublicDefine sharedInstance] getAppSelect] objectForKey:@"id"];
    return [NSString stringWithFormat:@"window.navigator.serverAddress = '%@';window.navigator.accessToken = '%@'; window.navigator.workingOrganizationId = '%@'; window.navigator.appId = '%@'; window.navigator.refreshToken = '%@'; window.navigator.customerId = '%@';  window.navigator.customerName = '%@';", urlBase, accesstoken, orgId, appId, refreshToken, customerId, userName];
}

@end
