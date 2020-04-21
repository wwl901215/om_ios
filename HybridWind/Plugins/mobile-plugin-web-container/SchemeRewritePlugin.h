//
//  SchemeRewritePlugin.h
//
//  Created by terence on 2019/10/31.
//

#ifndef SchemeRewritePlugin_h
#define SchemeRewritePlugin_h

#import <Cordova/CDVPlugin.h>

@interface SchemeRewritePlugin : CDVPlugin
@property (atomic,strong,readwrite) NSMutableSet *urlSet;
@end

#endif /* SchemeRewritePlugin_h */
