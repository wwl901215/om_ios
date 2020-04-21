//
//  DebugViewController.m
//  HybridWind
//
//  Created by syl on 2019/11/22.
//

#import "DebugViewController.h"
#import <EnvHybrid/EnvHybridConstants.h>
#import "PublicDefine.h"
#import "Router.h"
#import "EnvAppData.h"

@implementation DebugViewController
- (instancetype)initWithRouterParams:(NSDictionary *) routerParams {
    self = [super init];
    if(self) {
        if(routerParams) {
           NSString *url = [[EnvAppData sharedData] getPersistentItem:@"debugPath"];
            if(url) {
                self.pageName = url;
                self.startPage = url;
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
