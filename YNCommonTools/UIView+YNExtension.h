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

/**
 * 添加阴影
 */
- (void)yn_drawShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity;

/**
 * 视图抖动，添加抖动幅度
 */
- (void)yn_shakeAnimationWithPosition:(CGFloat)positon;

/**
 *  给视图添加圆角，摒弃layer的cornerRadius，提高性能
 */
- (void)addCornerRadius:(CGFloat)cornerRadius frame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
