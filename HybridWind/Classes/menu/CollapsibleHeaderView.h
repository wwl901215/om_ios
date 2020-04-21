//
//  CollapsibleHeaderView.h
//  HybridWind
//
//  Created by syl on 2019/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^actionBlock)(NSUInteger section);

@interface CollapsibleHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *downLine;

@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) actionBlock closeblock;
@property (nonatomic, strong) actionBlock openblock;

@end

NS_ASSUME_NONNULL_END
