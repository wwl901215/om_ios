//
//  UIViewController+SlideMenu.m
//  EnvHyrbidDemo
//
//  Created by MinBaby on 2018/3/15.
//

#import "UIViewController+SlideMenu.h"
#import "SlideMenu.h"

@implementation UIViewController (SlideMenu)

- (SlideMenu *)env_slideMenu {
    UIViewController *slideMenu = self.parentViewController;
    while (slideMenu) {
        if ([slideMenu isKindOfClass:[SlideMenu class]]) {
            return (SlideMenu *)slideMenu;
        } else if (slideMenu.parentViewController && slideMenu.parentViewController != slideMenu) {
            slideMenu = slideMenu.parentViewController;
        } else {
            slideMenu = nil;
        }
    }
    return nil;
}

@end
