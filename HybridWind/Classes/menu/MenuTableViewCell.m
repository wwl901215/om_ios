//
//  MenuTableViewCell.m
//  Wind
//
//  Created by syl on 2018/12/3.
//

#import "MenuTableViewCell.h"



@implementation MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.checkBox.layer.masksToBounds = YES;
    self.checkBox.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:250/255.0 alpha:0.6];
    self.titleLabel.textColor = [UIColor colorWithRed:95/255.0 green:95/255.0 blue:107/255.0 alpha:1.0];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
