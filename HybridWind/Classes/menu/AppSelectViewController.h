//
//  AppSelectViewController.h
//  HybridWind
//
//  Created by syl on 2019/11/20.
//

#import <UIKit/UIKit.h>
#import "EnvWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppSelectViewController :EnvWebViewController
@property (nonatomic, strong) NSArray *apps;
@property (nonatomic, strong) NSString *selectApp;

@end

NS_ASSUME_NONNULL_END
