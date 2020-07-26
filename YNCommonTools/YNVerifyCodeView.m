//
//  YNVerifyCodeView.m
//  TestField-Example
//
//  Created by 贾亚宁 on 2020/7/25.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "YNVerifyCodeView.h"

@interface YNVerifyCodeView () <UITextFieldDelegate>
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) UIView *boxView;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIView *labelView;
@property (strong, nonatomic) UITextField *textField;
@property (assign, nonatomic) YNVerifyCodeViewStyle style;
@property (strong, nonatomic) UIView *cursorView;

@property (assign, nonatomic) BOOL enableAuto;
@property (copy, nonatomic) void(^complete)(NSString *text);
@end

@implementation YNVerifyCodeView

/**
 * 构造器
 * @param count 验证码数量
 */
- (instancetype)initWithCount:(NSInteger)count style:(YNVerifyCodeViewStyle)style {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        // 验证码个数
        self.count = count;
        self.style = style;
        self.spaceWidth = 10.f;
        self.boxNormalColor = [UIColor colorWithWhite:243/255.0 alpha:1];
        self.boxHighlightColor = [UIColor orangeColor];
        // 初始化控件
        [self setup];
    }
    return self;
}

- (void)setup {
    // 添加父视图
    [self addSubview:self.textField];
    [self addSubview:self.maskView];
    [self addSubview:self.boxView];
    [self addSubview:self.labelView];
    if (self.style == YNVerifyCodeViewStyleCursor) {
        [self.maskView addSubview:self.cursorView];
    }
    // 根据数量添加子视图
    for (int i = 0; i < self.count; i ++) {
        [self.labelView addSubview:self.label];
        [self.boxView addSubview:self.box];
    }
}

#pragma mark - self's Method
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textField.frame = self.bounds;
    self.maskView.frame = self.bounds;
    self.boxView.frame = self.bounds;
    self.labelView.frame = self.bounds;
    
    CGFloat itemW = (self.frame.size.width - self.spaceWidth * (self.count - 1)) / self.count;
    
    for (int i = 0; i < self.count; i ++) {
        UILabel *label = (UILabel *)[self.labelView.subviews objectAtIndex:i];
        label.frame = CGRectMake((itemW+self.spaceWidth)*i, 0, itemW, self.labelView.frame.size.height);
        UIView  *box = [self.boxView.subviews objectAtIndex:i];
        if (self.style == YNVerifyCodeViewStyleCursor || self.style == YNVerifyCodeViewStyleHighlightLine) {
            box.frame = CGRectMake((itemW+self.spaceWidth)*i, self.boxView.frame.size.height-2, itemW, 2);
        }else if (self.style == YNVerifyCodeViewStyleBox) {
            box.frame = CGRectMake((itemW+self.spaceWidth)*i, 0, itemW, self.boxView.frame.size.height);
        }
    }
    
    if (self.style == YNVerifyCodeViewStyleCursor) {
        self.cursorView.frame = CGRectMake(0, self.frame.size.height*0.3, 2.2, self.frame.size.height*0.4);
        self.cursorView.center = CGPointMake(itemW*0.5, self.cursorView.center.y);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
    [self.textField becomeFirstResponder];
}

#pragma mark - Custon's Method
- (void)startAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    animation.values = @[@0,@1];
    animation.keyTimes = @[@0.5,@1];
    animation.duration = 1.3;
    animation.repeatCount = OPEN_MAX;
    animation.removedOnCompletion = NO;
    [self.cursorView.layer addAnimation:animation forKey:@"Opacity_Animation"];
}

- (void)enableAutoBlockToMaxCountComplete:(void(^)(NSString *text))complete {
    self.complete = complete;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.cursorView.hidden = NO;
    [self startAnimation];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.cursorView.hidden = YES;
    [self.cursorView.layer removeAllAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        if (textField.text.length >= self.count && ![string isEqualToString:@""]) {
            return NO;
        }
    }
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length > 0) {
        NSPredicate *regular = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [NSString stringWithFormat:@"^[0-9]{0,%ld}",self.count]];
        return [regular evaluateWithObject:toString];
    }
    return YES;
}

- (void)textFieldTextDidChanged:(UITextField *)textField {
    for (int i = 0; i < self.count; i ++) {
        UIView *box = [self.boxView.subviews objectAtIndex:i];
        box.backgroundColor = self.boxNormalColor;
        UILabel *label = (UILabel *)[self.labelView.subviews objectAtIndex:i];
        label.text = @"";
    }
    for (int i = 0; i < textField.text.length; i ++) {
        if (i < self.count) {
            if (self.style != YNVerifyCodeViewStyleCursor) {
                UIView *box = [self.boxView.subviews objectAtIndex:i];
                box.backgroundColor = self.boxHighlightColor;
            }
            UILabel *label = (UILabel *)[self.labelView.subviews objectAtIndex:i];
            label.text = [textField.text substringWithRange:NSMakeRange(i, 1)];
        }
    }
    CGFloat itemW = (self.frame.size.width - self.spaceWidth * (self.count - 1)) / self.count;
    if (textField.text.length >= self.count) {
        self.cursorView.hidden = YES;
    }else {
        self.cursorView.hidden = NO;
        self.cursorView.center = CGPointMake((itemW+self.spaceWidth)*textField.text.length+itemW*0.5, self.cursorView.center.y);
    }
    if (textField.text.length >= self.count) {
        if (self.complete) {
            self.complete(textField.text);
        }
    }
}

#pragma mark - Lazy getter & setter
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.hidden = YES;
        _textField.font = [UIFont systemFontOfSize:0];
        _textField.textColor = [UIColor clearColor];
        _textField.tintColor = [UIColor clearColor];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField addTarget:self action:@selector(textFieldTextDidChanged:) forControlEvents:UIControlEventEditingChanged];
        if (@available(iOS 12, *)) {
            _textField.textContentType = UITextContentTypeOneTimeCode;
        }else {
            if (@available(iOS 10.0, *)) {
                _textField.textContentType = @"one-time-code";
            }
        }
    }
    return _textField;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.userInteractionEnabled = NO;
        _maskView.backgroundColor = [UIColor clearColor];
        _maskView.clipsToBounds = YES;
    }
    return _maskView;
}

- (UIView *)labelView {
    if (!_labelView) {
        _labelView = [[UIView alloc] init];
        _labelView.userInteractionEnabled = NO;
        _labelView.backgroundColor = [UIColor clearColor];
        _labelView.clipsToBounds = YES;
    }
    return _labelView;
}

- (UIView *)boxView {
    if (!_boxView) {
        _boxView = [[UIView alloc] init];
        _boxView.userInteractionEnabled = NO;
        _boxView.backgroundColor = [UIColor clearColor];
        _boxView.clipsToBounds = YES;
    }
    return _boxView;
}

- (UIView *)cursorView {
    if (!_cursorView) {
        _cursorView = [[UIView alloc] init];
        _cursorView.userInteractionEnabled = NO;
        _cursorView.backgroundColor = [UIColor blackColor];
        _cursorView.clipsToBounds = YES;
        _cursorView.hidden = YES;
    }
    return _cursorView;
}

- (UILabel *)label {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = NO;
    label.font = [UIFont boldSystemFontOfSize:20];
    return label;
}

- (UIView *)box {
    UIView *box = [[UIView alloc] init];
    box.backgroundColor = self.boxNormalColor;
    box.clipsToBounds = YES;
    return box;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    for (UILabel *label in self.labelView.subviews) {
        label.font = font;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    for (UILabel *label in self.labelView.subviews) {
        label.textColor = textColor;
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.cursorView.backgroundColor = tintColor;
}

- (void)setSpaceWidth:(CGFloat)spaceWidth {
    _spaceWidth = spaceWidth;
    [self setNeedsDisplay];
}

- (NSString *)text {
    return self.textField.text;
}

@end
