//
//  UIView+YNExtension.h
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2020/3/4.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YNExtension)

@property (nonatomic, assign) CGFloat yn_x;
@property (nonatomic, assign) CGFloat yn_y;
@property (nonatomic, assign) CGFloat yn_centerX;
@property (nonatomic, assign) CGFloat yn_centerY;
@property (nonatomic, assign) CGFloat yn_width;
@property (nonatomic, assign) CGFloat yn_height;
@property (nonatomic, assign) CGSize  yn_size;
@property (nonatomic, assign) CGPoint yn_origin;

- (void)yn_drawShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity;

- (void)yn_shakeAnimationForView;

@end

NS_ASSUME_NONNULL_END
