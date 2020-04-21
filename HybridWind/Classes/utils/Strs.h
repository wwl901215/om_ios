//
//  Strs.h
//  Wind
//
//  Created by xuchao on 18/3/27.
//
//

#ifndef Strs_h
#define Strs_h


#endif /* Strs_h */

  

#define USER_NAME               @"username"
#define PASSWORD                @"password"

#define APPID @"appid"
#define OPENID @"openid"
#define GLOBAL_ID @"global_id"
#define DEVICEUUID @"device_uuid"
#define LOGIN_INFO @"login_info"
#define USERID @"userId"
#define USERNAME  @"userName"
#define WORKING_PRG  @"workingOrganizationId"
#define CURRENT_PRG  @"currentOrgId"

#define ACCESSTOKEN @"accessToken"
#define REFRESHTOKEN @"refreshToken"
#define ORGS  @"organizations"
#define AUTHORIZATION  @"Authorization"

#define USERDEFAULT_PRIFIX  @"envappdata_"

#define LANGUAGE_ZH_TO_WEB     @"zh-CN"
#define LANGUAGE_EN_TO_WEB     @"en-US"


typedef enum {
    Default = 0,
    Portal,
} AuthType;

#define CURRENT_ENV @"current_env"
#define CURRENT_ENV_APIM   @"current_env_apim"
#define CURRENT_AUTH_TYPE @"current_auth_type"

#define US_SERVER @"https://app-portal-us2.envisioniot.com"
#define US_SERVER_APIM @"https://ag-us2.envisioniot.com"

//#define CN_SERVER @"https://app-portal-ppe1.envisioniot.com"

//#define CN_SERVER @"https://app-portal-cn5.envisioniot.com"

// 迁移接口2.0
#define CN_SERVER @"https://app-portal-cn5.envisioniot.com"
#define CN_SERVER_APIM @"https://ag-cn5.envisioniot.com"

#define EU_SERVER @"https://app-portal-eu2.envisioniot.com"
#define EU_SERVER_APIM @"https://ag-eu2.envisioniot.com"

#define PPE_SERVER @"https://app-portal-ppe1.envisioniot.com"
#define PPE_SERVER_APIM   @"https://apim-ppe1.envisioniot.com"

#define SHDL_SERVER @"https://enos-shdl1.envisioniot.com:9443"
#define SHDL_SERVER_APIM @"https://enos-shdl1.envisioniot.com:9443"

#define HBJT_SERVER @"http://111.62.247.20:8080"
#define HBJT_SERVER_APIM @"http://111.62.247.20:8080"

#define GUANGFA_SERVER @"https://app-portal-gf1.envisioniot.com:1443"
#define GUANGFA_SERVER_APIM @"https://ag-gf1.eniot.io/"

#define INDIA_SERVER @"https://app-portal-india1.envisioniot.com"
#define INDIA_SERVER_APIM @"https://ag-india1.envisioniot.com"

#define AUTH_TYPE_DEFAULT @"default"
#define AUTH_TYPE_PORTAL  @"RCC"

#define LOGIN_ROUTE @"/login"
#define DOWNLOAD_ROUTE  @"/download"
#define FINGER_ROUTE  @"/finger"
#define UPDATE_ROUTE @"/updating"
#define HOME_ROUTE @"/eos-wind-map/assetOverview.html"
#define ERROR_ROUTE  @"/setting/error.html"
#define ORGSELECT_ROUTER  @"/setting/orgselect.html"

#define ROUTE_USER_AGREEMENT   @"/setting/useragreement.html"
#define ROUTE_USER_AGREEMENT_EN   @"/setting/useragreenmenten.html"
#define ROUTE_PRIVACY    @"/setting/privacypolicy.html"
#define ROUTE_PRIVACY_EN    @"/setting/privacypolicyen.html"

#define ROUTE_KEY_URLQUERY @"queryDic"

#define SCREEN_WIDTH       [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT      [UIScreen mainScreen].bounds.size.height
#define auth_list          @[NSLocalizedString(@"default", nil), @"ENVISION Portal"]

#define LOGIN_LOGO_IMAGE     @"EnvLoginLogo"
#define APP_CODE   @"EnvAppCode"
#define ENVIRONMENT_LIST    @"EnvList"
#define ENVIRONMENT    @"Envirnment"
#define QR_IMAGE  @"EnvQR"
#define HOME_PAGE_ROUTE  @"HomePage"
#define MENUS   @"menus"
#define APPS  @"apps"
#define ORG_SELECT  @"org_select"
#define MENU_SELECT  @"menu_select"
#define APP_SELECT  @"app_select"
#define FIRST_LOGIN  @"isFirst"
#define kCurrentVersion   @"kCurrentVersion"
#define APIM_ACCESS_TOKEN  @"apim_access_token"
#define APP_SELECT_NAME   @"app_select_name"
#define MENU_SELECT_SECTION  @"menu_select_section"


#define CURRENT_APIM_APP  @"current_apim_app"
#define CURRENT_APIM_APP_SECRET_KEY  @"EnvAppSecret"
#define CURRENT_APIM_APP_KEY    @"EnvAppKey"
#define CURRENT_APP_KEY   @"current_appKey"
#define CURRENT_APP_DELEGATE     [[UIApplication sharedApplication] delegate]


