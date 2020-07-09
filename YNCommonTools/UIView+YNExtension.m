//
//  UIView+YNExtension.m
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2020/3/4.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "UIView+YNExtension.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation UIView (YNExtension)

- (void)setYn_x:(CGFloat)yn_x {
    CGRect frame = self.frame;
    frame.origin.x = yn_x;
    self.frame = frame;
}

- (void)setYn_y:(CGFloat)yn_y {
    CGRect frame = self.frame;
    frame.origin.y = yn_y;
    self.frame = frame;
}

- (void)setYn_centerX:(CGFloat)yn_centerX {
    CGPoint center = self.center;
    center.x = yn_centerX;
    self.center = center;
}

- (void)setYn_centerY:(CGFloat)yn_centerY {
    CGPoint center = self.center;
    center.y = yn_centerY;
    self.center = center;
}

- (void)setYn_width:(CGFloat)yn_width {
    CGRect frame = self.frame;
    frame.size.width = yn_width;
    self.frame = frame;
}

- (void)setYn_height:(CGFloat)yn_height {
    CGRect frame = self.frame;
    frame.size.height = yn_height;
    self.frame = frame;
}

- (void)setYn_size:(CGSize)yn_size {
    CGRect frame = self.frame;
    frame.size = yn_size;
    self.frame = frame;
}

- (void)setYn_origin:(CGPoint)yn_origin {
    CGRect frame = self.frame;
    frame.origin = yn_origin;
    self.frame = frame;
}

- (CGFloat)yn_x {
    return self.frame.origin.x;
}

- (CGFloat)yn_y {
    return self.frame.origin.y;
}

- (CGFloat)yn_centerX {
    return self.center.x;
}

- (CGFloat)yn_centerY {
    return self.center.y;
}

- (CGFloat)yn_width {
    return self.frame.size.width;
}

- (CGFloat)yn_height {
    return self.frame.size.height;
}

- (CGSize)yn_size {
    return self.frame.size;
}

- (CGPoint)yn_origin {
    return self.frame.origin;
}

- (void)yn_drawShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity {
    self.clipsToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
}

- (void)yn_shakeAnimationForView {
    AudioServicesPlaySystemSound(1521);
    CALayer *viewLayer = self.layer;
    CGPoint position = viewLayer.position;
    CGPoint left = CGPointMake(position.x-2, position.y);
    CGPoint right = CGPointMake(position.x+1, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setFromValue:[NSValue valueWithCGPoint:left]];
    [animation setToValue:[NSValue valueWithCGPoint:right]];
    [animation setAutoreverses:YES];
    [animation setDuration:0.04];
    [animation setRepeatCount:4];
    [viewLayer addAnimation:animation forKey:nil];
}

@end
