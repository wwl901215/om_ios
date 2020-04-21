//
//  EnvAppData.m
//  Mydemo
//
//  Created by zhenghuiyu on 2019/4/19.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "EnvAppData.h"
#import "NSDictionary+EnvHybrid.h"
#import <EnvHybrid/EnvHybridConstants.h>


#define ROOT_OBJECT @"this.global"

@interface EnvAppData()

@property(nonatomic, strong) NSMutableDictionary * itemDic;
@end

@implementation EnvAppData

+ (instancetype)sharedData {
    static EnvAppData *_sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedData = [[EnvAppData alloc] init];
        _sharedData.itemDic = [NSMutableDictionary dictionaryWithCapacity:30];
    });
    return _sharedData;
}


-(void)setItem:(id) value forKey:(NSString* ) key
{
    [self.itemDic setValue:value forKey:key];
}

-(id)getItem:(NSString* ) key
{
    return [self.itemDic valueForKey:key];
}


-(void)removeItem:(NSString* ) key
{
    [self.itemDic removeObjectForKey:key];
}

-(void)resetState
{
    [self.itemDic removeAllObjects];
}

- (void)savePersistentItem:(NSString *)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

- (NSString *)getPersistentItem:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)removePersistentItem:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

-(NSString *)getNamespaceItem:(NSString *)nameSpace key:(NSString *)key {
    NSDictionary* namespaceItem = [[NSUserDefaults standardUserDefaults] objectForKey:nameSpace];
    if(!namespaceItem){
        namespaceItem = [NSDictionary dictionary];
    }
    return [namespaceItem objectForKey:key];
}

- (void)saveNamespaceItem:(NSString *)nameSpace key:(NSString *)key value:(NSString *)value {
    NSDictionary* namespaceItem = [[NSUserDefaults standardUserDefaults] objectForKey:nameSpace];
    NSMutableDictionary *newdic;
    if(!namespaceItem){
        newdic = [NSMutableDictionary dictionary];
    }else{
        newdic= [NSMutableDictionary dictionaryWithDictionary:namespaceItem];
    }
    [newdic setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:newdic] forKey:nameSpace];
}

- (void)removeNamespaceItem:(NSString *)nameSpace key:(NSString *)key {
    NSDictionary* namespaceItem = [[NSUserDefaults standardUserDefaults] objectForKey:nameSpace];
    NSMutableDictionary *newdic;
    if(!namespaceItem){
        newdic = [NSMutableDictionary dictionary];
    }else{
        newdic= [NSMutableDictionary dictionaryWithDictionary:namespaceItem];
    }
    [newdic removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithDictionary:newdic] forKey:nameSpace];
}

- (void)removeNamespaceAllItem:(NSString *)nameSpace {
    return [[NSUserDefaults standardUserDefaults] removeObjectForKey:nameSpace];
}

@end
