//
//  Uris.h
//  Wind
//
//  Created by xuchao on 18/3/27.
//
//

#ifndef Uris_h
#define Uris_h


#endif /* Uris_h */

//#define POST_LOGIN           @"/app-portal/api/v1/login"
//#define POST_REFRESHTOKEN    @"/app-portal/api/v1/token/refresh"
//#define GET_PUBLIC_KEY       @"/app-portal/v1/encrypt/publicKey"
//#define POST_SESSION_GET           @"/app-portal/api/v1/session/get"
//#define POST_SESSION_SET           @"/app-portal/api/v1/session/set"
//#define POST_RESOURCE_LIST   @"/app-portal/api/v1/user/app/resource/list"
//#define GET_USER_INFO   @"/app-portal/api/v1/user/info"
//#define POST_APP_LIST        @"/app-portal/api/v1/user/app/list"

// 迁移接口2.0
#define POST_LOGIN           @"/app-portal-service/v2.0/login"
#define POST_REFRESHTOKEN    @"/app-portal-service/v2.0/token/refresh"
#define POST_SESSION_SET           @"/app-portal-service/v2.1/session/set"
#define GET_USER_INFO   @"/app-portal-service/v2.0/user/info"
#define POST_RESOURCE_LIST   @"/app-portal-service/v2.1/user/app/resource/info"
#define POST_APP_LIST        @"/app-portal-service/v2.0/user/app/list"


#define POST_APIM_GET_TOKEN   @"/apim-token-service/v2.0/token/get"
#define POST_APIM_REFRESH_TOKEN    @"/apim-token-service/v2.0/token/refresh"
