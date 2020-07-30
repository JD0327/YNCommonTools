//
//  TWTextInputView.m
//  YNTableView
//
//  Created by 贾亚宁 on 2019/11/18.
//  Copyright © 2019 贾亚宁. All rights reserved.
//

#import "TWTextInputView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <objc/runtime.h>

#define COUNT_LABEL_HEIGHT 30.f

@implementation TWTextInputViewConfig

+ (instancetype)defaultConfig {
    TWTextInputViewConfig *config = [[TWTextInputViewConfig alloc] init];
    config.maxCount = 0;
    config.enbleEmoji = YES;
    config.enbleControl = YES;
    config.keyType = TWTextViewReturnKeyTypeEnter;
    config.enbleAutoUpdateHeight = NO;
    config.regular = @"";
    config.errorColor = [UIColor colorWithRed:242/255.0 green:48/255.0 blue:48/255.0 alpha:0.5];
    return config;
}

@end

@interface TWTextField : UITextField
@property (strong, nonatomic) TWTextInputViewConfig *config;
@end

@implementation TWTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (!self.config.enbleControl) {
        return NO;
    }
    BOOL success = [super canPerformAction:action withSender:sender];
    if (action == @selector(paste:) ||
        action == @selector(cut:) ||
        action == @selector(copy:) ||
        action == @selector(select:) ||
        action == @selector(selectAll:)) {
        return success;
    }
    return NO;
}

@end

@interface TWTextView : UITextView
@property (strong, nonatomic) TWTextInputViewConfig *config;
@end

@implementation TWTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (!self.config.enbleControl) {
        return NO;
    }
    BOOL success = [super canPerformAction:action withSender:sender];
    if (action == @selector(paste:) ||
        action == @selector(cut:) ||
        action == @selector(copy:) ||
        action == @selector(select:) ||
        action == @selector(selectAll:)) {
        return success;
    }
    return NO;
}

@end

@interface TWTextInputView () <UITextFieldDelegate, UITextViewDelegate, CAAnimationDelegate>
@property (assign, nonatomic) CGFloat originHeight;
@end

@implementation TWTextInputView
{
    TWTextField *_textField;
    TWTextView *_textView;
    TWTextInputViewStyle _style;
    BOOL _isAnimation;
    UILabel *_countLabel;
    UITextView *_placeholderTextView;
    NSString *_noteString;
    TWTextInputViewConfig *_config;
}

+ (void)load {
    SEL orig_present = @selector(setBackgroundColor:);
    SEL swiz_present = @selector(swiz_setBackgroundColor:);
    [TWTextInputView swizzleMethods:[self class] originalSelector:orig_present swizzledSelector:swiz_present];
}

+ (void)swizzleMethods:(Class)class originalSelector:(SEL)origSel swizzledSelector:(SEL)swizSel {
    
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method swizMethod = class_getInstanceMethod(class, swizSel);
    
    //class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, origSel, method_getImplementation(swizMethod), method_getTypeEncoding(swizMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizSel, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        //origMethod and swizMethod already exist
        method_exchangeImplementations(origMethod, swizMethod);
    }
}

- (void)swiz_setBackgroundColor:(UIColor *)backgroundColor {
    [self swiz_setBackgroundColor:[UIColor clearColor]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(TWTextInputViewStyle)style config:(void (^)(TWTextInputViewConfig * _Nonnull config))maker {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        TWTextInputViewConfig *config = [TWTextInputViewConfig defaultConfig];
        maker(config);
        _config = config;
        _style = style;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField = [[TWTextField alloc] init];
        _textField.delegate = self;
        _textField.config = _config;
        _textField.backgroundColor = [UIColor clearColor];
        [_textField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
    }
    if (_style == TWTextInputViewStyleTextView) {
        
        if (_config.maxCount > 0) {
            _countLabel = [[UILabel alloc] init];
            _countLabel.font = [UIFont systemFontOfSize:13];
            _countLabel.textColor = [UIColor colorWithRed:132/255.0 green:132/255.0 blue:147/255.0 alpha:1];
            _countLabel.text = [NSString stringWithFormat:@"0/%ld",(long)_config.maxCount];
            _countLabel.backgroundColor = [UIColor clearColor];
            _countLabel.textAlignment = NSTextAlignmentRight;
            [self addSubview:_countLabel];
        }
        
        _placeholderTextView = [[UITextView alloc] init];
        _placeholderTextView.backgroundColor = [UIColor clearColor];
        _placeholderTextView.textContainerInset = UIEdgeInsetsMake(5, 0, 5, 0);
        _placeholderTextView.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
        [self addSubview:_placeholderTextView];
        
        _textView = [[TWTextView alloc] init];
        _textView.delegate = self;
        _textView.config = _config;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textContainerInset = UIEdgeInsetsMake(5, 0, 5, 0);
        [self addSubview:_textView];
        
        if (_config.enbleAutoUpdateHeight) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
            _textView.layoutManager.allowsNonContiguousLayout = NO;
            _textView.scrollEnabled = NO;
        }
        if (@available(iOS 11.0, *)) {
            _textView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    [self setFont:[UIFont systemFontOfSize:14]];
}

#pragma  - mark drawRect
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.originHeight = rect.size.height;
}

#pragma  - mark layoutSubviews
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField.frame = self.bounds;
    }
    
    if (_style == TWTextInputViewStyleTextView) {
        if (_config.maxCount > 0) {
            _countLabel.frame = CGRectMake(5, CGRectGetHeight(self.frame)-COUNT_LABEL_HEIGHT, CGRectGetWidth(self.frame)-10, COUNT_LABEL_HEIGHT);
            _placeholderTextView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-COUNT_LABEL_HEIGHT);
            _textView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-COUNT_LABEL_HEIGHT);
        }else {
            _placeholderTextView.frame = self.bounds;
            _textView.frame = self.bounds;
        }
    }
}

- (void)becomeFirstResponder {
    if (_style == TWTextInputViewStyleTextFiled) {
        [_textField becomeFirstResponder];
    }
    if (_style == TWTextInputViewStyleTextView) {
        [_textView becomeFirstResponder];
    }
}

- (void)resignFirstResponder {
    if (_style == TWTextInputViewStyleTextFiled) {
        [_textField resignFirstResponder];
    }
    if (_style == TWTextInputViewStyleTextView) {
        [_textView resignFirstResponder];
    }
}

#pragma  - mark textView - Delegate
- (void)textViewDidChange:(UITextView *)textView {
    
    _placeholderTextView.hidden = textView.hasText;
    
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && position) {
        return;
    }
    
    NSRange selectedTextRange = [textView selectedRange];
    
    if (!_config.enbleEmoji) {
        NSString *text = [self disable_emoji:textView.text];
        if (![text isEqualToString:textView.text]) {
            textView.text = text;
        }
    }
    
    if (textView.text.length > _config.maxCount && _config.maxCount > 0) {
        textView.text = [textView.text substringToIndex:_config.maxCount];
        [textView.undoManager removeAllActions];
    }
    
    _countLabel.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)textView.text.length,(long)_config.maxCount];
    
    if ([self.delegate respondsToSelector:@selector(inputViewDidChange:)]) {
        [self.delegate inputViewDidChange:self];
    }
    
    if (_config.enbleAutoUpdateHeight) {
        [self autoUpdateHeightWithTextView:_textView];
    }
    
    _placeholderTextView.hidden = textView.hasText;
    
    [textView scrollRangeToVisible:textView.selectedRange];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        textView.selectedRange = selectedTextRange;
    });
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        if (textView.text.length >= _config.maxCount && ![text isEqualToString:@""] && _config.maxCount > 0) {
            [self viewShake];
            return NO;
        }
    }
    
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(inputViewShouldReturn:)]) {
            [self.delegate inputViewShouldReturn:self];
        }
        if (_config.keyType == TWTextViewReturnKeyTypeFinish) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    if (!_config.enbleEmoji) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
            if ([text isEqualToString:@""]) {
                return YES;
            }
            return NO;
        }
#pragma clang diagnostic pop
    }
    
    if (_config.regular.length > 0) {
        NSString *toString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if (toString.length > 0) {
            NSPredicate *regular = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _config.regular];
            BOOL flag = [regular evaluateWithObject:toString];
            if (!flag) {
                [self viewShake];
                return NO;
            }
        }
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputViewDidEndEditing:)]) {
        [self.delegate inputViewDidEndEditing:self];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputViewDidBeginEditing:)]) {
        [self.delegate inputViewDidBeginEditing:self];
    }
}

- (void)autoUpdateHeightWithTextView:(TWTextView *)textView {
    CGSize size = [textView sizeThatFits:textView.frame.size];
    CGFloat currentHeight = size.height;
    if (_config.maxCount > 0) {
        currentHeight = size.height + COUNT_LABEL_HEIGHT;
    }
    if (self.updateViewHeight) {
        if (currentHeight > CGRectGetHeight(self.frame)) {
            self.updateViewHeight(currentHeight);
        }else if (currentHeight < CGRectGetHeight(self.frame) && currentHeight > self.originHeight) {
            self.updateViewHeight(currentHeight);
        }else if (currentHeight <= self.originHeight && self.originHeight != CGRectGetHeight(self.frame)) {
            self.updateViewHeight(self.originHeight);
        }
    }else {
        if (currentHeight > CGRectGetHeight(self.frame)) {
            CGRect frame = self.frame;
            frame.size.height = currentHeight;
            self.frame = frame;
            [self setNeedsLayout];
        }else if (currentHeight < CGRectGetHeight(self.frame) && currentHeight > self.originHeight) {
            CGRect frame = self.frame;
            frame.size.height = currentHeight;
            self.frame = frame;
            [self setNeedsLayout];
        }else if (currentHeight <= self.originHeight && self.originHeight != CGRectGetHeight(self.frame)) {
            CGRect frame = self.frame;
            frame.size.height = self.originHeight;
            self.frame = frame;
            [self setNeedsLayout];
        }
    }
}

- (void)statusBarOrientationDidChange:(NSNotificationCenter *)notification {
    [self setNeedsLayout];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self autoUpdateHeightWithTextView:self->_textView];
    });
}

#pragma  - mark textField - delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputViewShouldReturn:)]) {
        [self.delegate inputViewShouldReturn:self];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputViewDidEndEditing:)]) {
        [self.delegate inputViewDidEndEditing:self];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(inputViewDidBeginEditing:)]) {
        [self.delegate inputViewDidBeginEditing:self];
    }
}

- (void)textFieldTextDidChange:(UITextField *)textField {
    
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (selectedRange && position) {
        return;
    }
    
    UITextRange *selectedTextRange = [textField selectedTextRange];
    
    if (!_config.enbleEmoji) {
        NSString *text = [self disable_emoji:textField.text];
        if (![text isEqualToString:textField.text]) {
            textField.text = text;
        }
    }
    
    if (textField.text.length > _config.maxCount && _config.maxCount > 0) {
        textField.text = [textField.text substringToIndex:_config.maxCount];
        [textField.undoManager removeAllActions];
    }
    
    if ([self.delegate respondsToSelector:@selector(inputViewDidChange:)]) {
        [self.delegate inputViewDidChange:self];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        textField.selectedTextRange = selectedTextRange;
    });
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position) {
        if (textField.text.length >= _config.maxCount && ![string isEqualToString:@""] && _config.maxCount > 0) {
            [self viewShake];
            return NO;
        }
    }
    if (!_config.enbleEmoji) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            return NO;
        }
#pragma clang diagnostic pop
    }
    if (_config.regular.length > 0) {
        NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (toString.length > 0) {
            NSPredicate *regular = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", _config.regular];
            BOOL flag = [regular evaluateWithObject:toString];
            if (!flag) {
                [self viewShake];
                return NO;
            }
        }
    }
    return YES;
}


#pragma  - mark regular
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr {
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

#pragma  - mark non-emoji
- (NSString *)disable_emoji:(NSString *)text {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text options:0 range:NSMakeRange(0, [text length]) withTemplate:@""];
    return modifiedString;
    
}

#pragma  - mark shake
- (void)viewShake {
    if (_isAnimation) {
        return;
    }
    _isAnimation = YES;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    animation.duration = 0.5;
    animation.delegate = self;
    animation.fromValue = (id)_config.errorColor.CGColor;
    animation.toValue = (id)self.backgroundColor.CGColor;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.beginTime = 0.0f;
    [self.layer addAnimation:animation forKey:@"backgroundColor"];
    
    CGAffineTransform translateRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 4.f,0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity,-4.f,0.0);
    self.transform = translateLeft;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        weakSelf.transform = translateRight;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            weakSelf.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _isAnimation = NO;
    [self.layer removeAllAnimations];
}

- (NSString *)pasteString {
    return [UIPasteboard generalPasteboard].string;
}

#pragma  - mark setter
- (void)setText:(NSString *)text {
    if (_style == TWTextInputViewStyleTextView) {
        _textView.text = text;
        [self textViewDidChange:_textView];
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField.text = text;
    }
}

- (void)setFont:(UIFont *)font {
    if (_style == TWTextInputViewStyleTextView) {
        _placeholderTextView.font = font;
        _textView.font = font;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField.font = font;
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_style == TWTextInputViewStyleTextView) {
        _textView.textColor = textColor;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField.textColor = textColor;
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    if (_style == TWTextInputViewStyleTextView) {
        _placeholderTextView.text = placeHolder;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField.placeholder = placeHolder;
    }
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor font:(UIFont *)font {
    if (_style == TWTextInputViewStyleTextView) {
        _placeholderTextView.textColor = placeHolderColor;
        if (font) {
            _placeholderTextView.font = font;
        }
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        if (font) {
            _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" " attributes:@{NSForegroundColorAttributeName:placeHolderColor, NSFontAttributeName: font}];
        }else {
            _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@" " attributes:@{NSForegroundColorAttributeName:placeHolderColor}];
        }
    }
}

- (void)setCountColor:(UIColor *)countColor {
    _countLabel.textColor = countColor;
}

- (void)setCountFont:(UIFont *)countFont {
    _countLabel.font = countFont;
}

- (void)setAlignment:(NSTextAlignment)alignment {
    if (_style == TWTextInputViewStyleTextView) {
        _placeholderTextView.textAlignment = alignment;
        _textView.textAlignment = alignment;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField.textAlignment = alignment;
    }
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField.secureTextEntry = secureTextEntry;
    }
}

- (void)setClearButtonMode:(UITextFieldViewMode)model {
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField.clearButtonMode = model;
    }
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType {
    if (_style == TWTextInputViewStyleTextView) {
        _textView.returnKeyType = returnKeyType;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField.returnKeyType = returnKeyType;
    }
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    if (_style == TWTextInputViewStyleTextView) {
        _textView.keyboardType = keyboardType;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField.keyboardType = keyboardType;
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (_style == TWTextInputViewStyleTextView) {
        _textView.tintColor = tintColor;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        _textField.tintColor = tintColor;
    }
}

#pragma  - mark getter
- (NSString *)text {
    if (_style == TWTextInputViewStyleTextView) {
        return _textView.text;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        return _textField.text;
    }
    return @"";
}

- (UIFont *)font {
    if (_style == TWTextInputViewStyleTextView) {
        return _textView.font;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        return _textField.font;
    }
    return [UIFont new];
}

- (UIColor *)textColor {
    if (_style == TWTextInputViewStyleTextView) {
        return _textView.textColor;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        return _textField.textColor;
    }
    return [UIColor new];
}

- (NSString *)placeHolder {
    if (_style == TWTextInputViewStyleTextView) {
        return _placeholderTextView.text;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        return _textField.placeholder;
    }
    return @"";
}

- (UIColor *)tintColor {
    if (_style == TWTextInputViewStyleTextView) {
        return _textView.tintColor;
    }
    if (_style == TWTextInputViewStyleTextFiled) {
        return _textField.tintColor;
    }
    return [UIColor new];
}

- (CGFloat)viewHeight {
    CGSize size = [_textView sizeThatFits:_textView.frame.size];
    CGFloat currentHeight = size.height;
    if (_config.maxCount > 0) {
        currentHeight = size.height + COUNT_LABEL_HEIGHT;
    }
    return MAX(currentHeight, self.originHeight);
}
@end
