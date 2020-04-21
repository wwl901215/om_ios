//
//  CollapsibleHeaderView.m
//  HybridWind
//
//  Created by syl on 2019/11/21.
//

#import "CollapsibleHeaderView.h"

@implementation CollapsibleHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    [self.arrowBtn addTarget:self action:@selector(handleTapAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addGestureRecognizer:tap];
    // Initialization code
}

- (void)handleTapAction:(UITapGestureRecognizer *)tap {
    if (self.isOpen) {
        self.closeblock(self.section);
    }else{
        self.openblock(self.section);
    }
}

@end
