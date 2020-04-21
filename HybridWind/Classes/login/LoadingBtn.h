//
//  LoadingBtn.h
//  Wind
//
//  Created by syl on 2018/12/6.
//

#import <UIKit/UIKit.h>

@interface LoadingBtn : UIButton
@property (nonatomic, strong) UIActivityIndicatorView *indecator;


- (void)stopLoading;
- (void)startLoading;
@property NSString* text;

@end
