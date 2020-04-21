//
//  UIImage+SVG.h
//  HybridWind
//
//  Created by syl on 2019/12/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SVG)

+(UIImage *)svgImgNamed:(NSString *)name size:(CGSize)size imageColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
