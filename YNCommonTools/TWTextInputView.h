//
//  TWTextInputView.h
//  YNTableView
//
//  Created by 贾亚宁 on 2019/11/18.
//  Copyright © 2019 贾亚宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TWTextInputViewStyle) {
    TWTextInputViewStyleTextFiled,
    TWTextInputViewStyleTextView
};

typedef NS_ENUM(NSInteger, TWTextViewReturnKeyType) {
    TWTextViewReturnKeyTypeFinish,
    TWTextViewReturnKeyTypeEnter
};

// 金钱
static NSString * const TWRegularMoney = @"(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,8}(([.]\\d{0,2})?)))?";
// 身份证
static NSString * const TWRegularPersonCard = @"^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$";
// 邮箱
static NSString * const TWRegularEmail = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

// 输入框配置设置
@interface TWTextInputViewConfig : NSObject
/** 默认设置 */
+ (instancetype)defaultConfig;
/** 最大输入字数 */
@property (assign, nonatomic) NSInteger maxCount;
/** textView点击return是换行还是结束输入，默认是换行 */
@property (assign, nonatomic) TWTextViewReturnKeyType keyType;
/** 是否支持复制粘贴等操作，默认YES */
@property (assign, nonatomic) BOOL enbleControl;
/** 是否支持输入Emoji表情 ，默认YES */
@property (assign, nonatomic) BOOL enbleEmoji;
/** 是否支持自动更新高度，默认为NO。@b 注意：如果使用Masonry、SnapKit等自动布局第三方，请使用^updateViewHeight @b block回调*/
@property (assign, nonatomic) BOOL enbleAutoUpdateHeight;
/** 设置允许输入的字符，即正则表达式 */
@property (strong, nonatomic) NSString *regular;
/** 错误提示时的颜色, 默认为红色 */
@property (strong, nonatomic) UIColor *errorColor;
@end

@class TWTextInputView;
@protocol TWTextInputViewDelegate <NSObject>
@optional

/** 点击键盘return键回调 */
- (void)inputViewShouldReturn:(TWTextInputView *)inputView;
/** 文本正在输入变化监听 */
- (void)inputViewDidChange:(TWTextInputView *)inputView;
/** 结束输入 */
- (void)inputViewDidEndEditing:(TWTextInputView *)inputView;
/** 开始输入 */
- (void)inputViewDidBeginEditing:(TWTextInputView *)inputView;

@end

@interface TWTextInputView : UIView
/**
 * 构造器
 * @param style 类型，创建不同的输入框
 */
/** 构造器 */
- (instancetype)initWithStyle:(TWTextInputViewStyle)style config:(void(^)(TWTextInputViewConfig *config))maker;
/** 代理 */
@property (assign, nonatomic) id <TWTextInputViewDelegate> delegate;

#pragma  - mark textField 设置
/** 设置密文 */
- (void)setSecureTextEntry:(BOOL)secureTextEntry;
/** 设置清除按钮 */
- (void)setClearButtonMode:(UITextFieldViewMode)model;
#pragma  - mark textView 设置
/** 展示数字颜色 */
- (void)setCountColor:(UIColor *)countColor;
/** 展示数字字体 */
- (void)setCountFont:(UIFont *)countFont;
#pragma  - mark 公共设置
/** 粘贴板上的文字内容 */
@property (strong, nonatomic, readonly) NSString *pasteString;
/** 视图高度，提供给 */
@property (assign, nonatomic, readonly) CGFloat viewHeight;
/** @b 使用Masonry、SnapKit等第三方布局时使用更新控件高度的回调 */
@property (copy, nonatomic) void(^updateViewHeight)(CGFloat viewHeight);
/** 占位内容 */
@property (strong, nonatomic) NSString *placeHolder;
/** 文本框内容 */
@property (strong, nonatomic) NSString *text;
/** 文本颜色 */
@property (strong, nonatomic) UIColor *textColor;
/** 设置光标颜色 */
@property (strong, nonatomic) UIColor *tintColor;
/** 文本字体 */
@property (strong, nonatomic) UIFont *font;
/** 占位颜色 */
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor font:(UIFont * _Nullable)font;
/** 文本对齐方式 */
- (void)setAlignment:(NSTextAlignment)alignment;
/** 设置回车键 */
- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType;
/** 设置键盘 */
- (void)setKeyboardType:(UIKeyboardType)keyboardType;
/** 开始响应 */
- (void)becomeFirstResponder;
/** 失去焦点 */
- (void)resignFirstResponder;
/** 输入框抖动 */
- (void)viewShake;
@end

NS_ASSUME_NONNULL_END
