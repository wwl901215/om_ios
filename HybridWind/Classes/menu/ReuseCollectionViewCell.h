//
//  ReuseCollectionViewCell.h
//  HybridWind
//
//  Created by syl on 2019/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReuseCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

NS_ASSUME_NONNULL_END
