//
//  YNRefreshNormalFooter.m
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2020/3/4.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "YNRefreshNormalFooter.h"
#import "YNRefreshConfig.h"

@interface YNRefreshNormalFooter ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CAShapeLayer *arrowLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@end

@implementation YNRefreshNormalFooter

- (CAShapeLayer *)arrowLayer {
    if (!_arrowLayer) {
        CGFloat width = [YNRefreshConfig share].loadingWidth*0.5;
        _arrowLayer = [[CAShapeLayer alloc]init];
        UIBezierPath *bezierPath = [[UIBezierPath alloc]init];
        [bezierPath moveToPoint:CGPointMake(width, width*0.6)];
        [bezierPath addLineToPoint:CGPointMake(width, width*1.4)];
        [bezierPath moveToPoint:CGPointMake(width*0.7, width*0.9)];
        [bezierPath addLineToPoint:CGPointMake(width, width*0.6)];
        [bezierPath addLineToPoint:CGPointMake(width*1.3, width*0.9)];
        _arrowLayer.path = bezierPath.CGPath;
        _arrowLayer.lineCap = kCALineCapRound;
        _arrowLayer.fillColor = [UIColor clearColor].CGColor;
        _arrowLayer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    _arrowLayer.lineWidth = [YNRefreshConfig share].lineWidth;
    _arrowLayer.strokeColor = [YNRefreshConfig share].loadingColor.CGColor;
    return _arrowLayer;
}

- (CAShapeLayer *)circleLayer {
    if (!_circleLayer) {
        _circleLayer = [[CAShapeLayer alloc]init];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake([YNRefreshConfig share].loadingWidth*0.5, [YNRefreshConfig share].loadingWidth*0.5)
                                                                  radius:[YNRefreshConfig share].loadingWidth*0.5-[YNRefreshConfig share].lineWidth
                                                              startAngle:-M_PI_2
                                                                endAngle:M_PI_2*3.0
                                                               clockwise:YES];
        _circleLayer.path = bezierPath.CGPath;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeEnd = 0.05;
        _circleLayer.strokeStart = 0.05;
        _circleLayer.lineCap = kCALineCapRound;
        _circleLayer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    _circleLayer.lineWidth = [YNRefreshConfig share].lineWidth;
    _circleLayer.strokeColor = [YNRefreshConfig share].loadingColor.CGColor;
    return _circleLayer;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    _titleLabel.font = [YNRefreshConfig share].font;
    _titleLabel.textColor = [YNRefreshConfig share].textColor;
    return _titleLabel;
}

- (void)prepare {
    [super prepare];
    
    self.mj_h = [YNRefreshConfig share].footerHeight;
    
    [self addSubview:self.titleLabel];
    [self.layer addSublayer:self.arrowLayer];
    [self.layer addSublayer:self.circleLayer];
}

/** 摆放子控件 */
- (void)placeSubviews {
    [super placeSubviews];
    
    // 获取当前label的大小
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    // 计算加载圈x坐标
    CGFloat qx = (CGRectGetWidth([UIScreen mainScreen].bounds) - [YNRefreshConfig share].loadingWidth - [YNRefreshConfig share].space - size.width) * 0.5;
    // 计算加载圈y坐标
    CGFloat qy = ([YNRefreshConfig share].footerHeight - [YNRefreshConfig share].loadingWidth) * 0.5;
    // 设置加载圈的位置
    self.arrowLayer.frame = CGRectMake(qx, qy, [YNRefreshConfig share].loadingWidth, [YNRefreshConfig share].loadingWidth);
    self.circleLayer.frame = CGRectMake(qx, qy, [YNRefreshConfig share].loadingWidth, [YNRefreshConfig share].loadingWidth);
    
    if (self.state == MJRefreshStateNoMoreData) {
        self.titleLabel.frame = self.bounds;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }else {
        // 计算label的x坐标
        CGFloat lx = CGRectGetMaxX(self.circleLayer.frame) + [YNRefreshConfig share].space;
        self.titleLabel.frame = CGRectMake(lx, 0, size.width+2, [YNRefreshConfig share].headerHeight);
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    if (self.state == MJRefreshStatePulling) {
        self.arrowLayer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }else {
        self.arrowLayer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
    }
}

/** 监听状态 */
- (void)setState:(MJRefreshState)state {
    MJRefreshState oldState = self.state;
    if (state == oldState) return;
    [super setState:state];
    
    if (state == MJRefreshStateIdle) {
        self.titleLabel.text = [YNRefreshConfig share].footerIdleString;
        self.arrowLayer.hidden = NO;
        self.circleLayer.strokeEnd = 0.05;
        [self.circleLayer removeAllAnimations];
    }
    if (state == MJRefreshStateNoMoreData) {
        self.titleLabel.text = [YNRefreshConfig share].footerNoMoreDataString;
        self.arrowLayer.hidden = YES;
        self.circleLayer.strokeEnd = 0.05;
        [self.circleLayer removeAllAnimations];
    }
    if (state == MJRefreshStatePulling) {
        self.titleLabel.text = [YNRefreshConfig share].footerPullingString;
    }
    if (state == MJRefreshStateRefreshing) {
        self.arrowLayer.hidden = YES;
        self.titleLabel.text = [YNRefreshConfig share].footerRefreshingString;
        self.circleLayer.strokeEnd = 0.95;
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.toValue = [[NSNumber alloc] initWithDouble:M_PI*2];
        rotateAnimation.duration = 0.8;
        rotateAnimation.cumulative = YES;
        rotateAnimation.repeatCount = 10000000;
        [self.circleLayer addAnimation:rotateAnimation forKey:@"rotate"];
    }
}

/** 监听ScrollView的滚动 */
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    if (self.state == MJRefreshStateIdle || self.state == MJRefreshStatePulling) {
        CGPoint point = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
        
        CGFloat numoffsetY = self.scrollView.contentSize.height-self.scrollView.mj_h+self.scrollView.mj_inset.bottom;
        if (point.y - numoffsetY >= 0) {
            CGFloat offsetY = point.y - numoffsetY;
            double progress = offsetY / [YNRefreshConfig share].footerHeight;
            if (progress > 1.0) {
                __weak typeof(self)weakSelf = self;
                [UIView animateWithDuration:.2 animations:^{
                    weakSelf.circleLayer.strokeEnd = 0.95;
                }];
                return;
            }
            self.circleLayer.strokeEnd = 0.05 + 0.9 * progress;
        }
    }
}


@end
