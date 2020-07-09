//
//  UIImage+YNExtension.h
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2019/5/14.
//  Copyright © 2019 贾亚宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GradientRampType) {
    GradientRampTypeLeftToRight = 0,    // 从左到右
    GradientRampTypeTopToBottom,        // 从上到下
    GradientRampTypeUpleftToLowright,   // 左上到右下
    GradientRampTypeUprightToLowleft,   // 右上到左下
};

@interface UIImage (YNExtension)

/** 将颜色转为图片 */
+ (instancetype)yn_imageWithColor:(UIColor *)color;

/** 将视图转为图片 */
+ (instancetype)yn_imageWithView:(UIView *)view;

/** 通过渐变色转为图片 */
+ (instancetype)yn_gradientRampWithColors:(NSArray <UIColor *>*)colors type:(GradientRampType)type imgSize:(CGSize)imgSize;

/** 修改图片颜色 */
- (UIImage *)imageChangeColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
