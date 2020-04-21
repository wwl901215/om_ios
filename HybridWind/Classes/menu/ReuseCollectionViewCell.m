//
//  ReuseCollectionViewCell.m
//  HybridWind
//
//  Created by syl on 2019/12/4.
//

#import "ReuseCollectionViewCell.h"

@implementation ReuseCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:0.4];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = UIBaselineAdjustmentAlignBaselines;
}

@end
