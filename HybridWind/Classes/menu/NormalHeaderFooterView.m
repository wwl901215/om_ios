//
//  NormalHeaderFooterView.m
//  HybridWind
//
//  Created by syl on 2019/12/18.
//

#import "NormalHeaderFooterView.h"

@implementation NormalHeaderFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    [self addGestureRecognizer:tap];
    // Initialization code
}

- (void)handleTapAction:(UITapGestureRecognizer *)tap {
    self.clickblock(self.url);
}

@end
