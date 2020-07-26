//
//  YNVerifyCodeView.h
//  TestField-Example
//
//  Created by 贾亚宁 on 2020/7/25.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YNVerifyCodeViewStyle) {
    YNVerifyCodeViewStyleCursor = 0,
    YNVerifyCodeViewStyleHighlightLine,
    YNVerifyCodeViewStyleBox,
};

@interface YNVerifyCodeView : UIView

/**
 * 构造器
 * @param count 验证码数量
 */
- (instancetype)initWithCount:(NSInteger)count style:(YNVerifyCodeViewStyle)style;

/**
 * 输入框输入到最大数之后是否自动回调，自动回调地址
 */
- (void)enableAutoBlockToMaxCountComplete:(void(^)(NSString *text))complete;

/**
 * 蒙版视图
 */
- (UIView *)maskView;

/**
 * 框与框之间的间距，默认为10
 */
@property (assign, nonatomic) CGFloat spaceWidth;

/**
 * 输入框当前的值
 */
@property (strong, nonatomic, readonly) NSString *text;

/**
 * 输入框的类型
 */
@property (assign, nonatomic, readonly) YNVerifyCodeViewStyle style;

/**
 * 正常的颜色
 */
@property (strong, nonatomic) UIColor *boxNormalColor;

/**
 * 高亮的颜色
 */
@property (strong, nonatomic) UIColor *boxHighlightColor;

/**
 * 光标颜色
 */
@property (strong, nonatomic) UIColor *tintColor;

/**
 * 文本颜色
 */
@property (strong, nonatomic) UIColor *textColor;

/**
 * 文本字体
 */
@property (strong, nonatomic) UIFont *font;

@end

NS_ASSUME_NONNULL_END
