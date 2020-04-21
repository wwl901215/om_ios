//
//  NormalHeaderFooterView.h
//  HybridWind
//
//  Created by syl on 2019/12/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^clickBlock)(NSString *url);

@interface NormalHeaderFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) clickBlock clickblock;
@property (nonatomic, strong) NSString *url;

@end

NS_ASSUME_NONNULL_END
