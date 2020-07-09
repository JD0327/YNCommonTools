//
//  UIImage+YNExtension.m
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2019/5/14.
//  Copyright © 2019 贾亚宁. All rights reserved.
//

#import "UIImage+YNExtension.h"

@implementation UIImage (YNExtension)

/** 将颜色转为图片 */
+ (instancetype)yn_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 将视图转为图片 */
+ (instancetype)yn_imageWithView:(UIView *)view {
    UIImage *image = [[UIImage alloc] init];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, UIScreen.mainScreen.scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)yn_gradientRampWithColors:(NSArray<UIColor *> *)colors type:(GradientRampType)type imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (type) {
        case GradientRampTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case GradientRampTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case GradientRampTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case GradientRampTypeUprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end,kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

/** 修改图片颜色 */
- (UIImage *)imageChangeColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    // 在这里借助系统按钮来切换图片颜色，非常精确
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setImage:self forState:normal];
    button.tintColor = color;
    button.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [button.layer renderInContext:ctx];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
