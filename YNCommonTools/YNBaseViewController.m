//
//  YNBaseViewController.m
//  RT
//
//  Created by 贾亚宁 on 2020/8/8.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "YNBaseViewController.h"
#import <objc/runtime.h>

static NSString *YNOrientationKey           = @"YNOrientationKey";
static NSString *YNAllowOtherKeyBoardKey    = @"YNAllowOtherKeyBoardKey";

@implementation UIApplication (Extension)

- (void)setYn_orientation:(UIInterfaceOrientationMask)yn_orientation {
    objc_setAssociatedObject(self, &YNOrientationKey, @(yn_orientation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIInterfaceOrientationMask)yn_orientation {
    return [objc_getAssociatedObject(self, &YNOrientationKey) integerValue];
}

- (void)setAllowOtherKeyBoard:(BOOL)allowOtherKeyBoard {
    objc_setAssociatedObject(self, &YNAllowOtherKeyBoardKey, @(allowOtherKeyBoard), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)allowOtherKeyBoard {
    return [objc_getAssociatedObject(self, &YNAllowOtherKeyBoardKey) boolValue];
}

@end

@implementation BaseRootNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (![viewController isKindOfClass:[RTContainerController class]]) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end

@interface YNBaseViewController ()
@property (strong, nonatomic) UIButton *navigation_back_btn;
@property (strong, nonatomic) UILabel *navigation_title_label;
@end

@implementation YNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = self.navigationController.navigationBar.frame.size;
    if (self.isLiuHai && [UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait) {
        _navigation_back_btn.frame =  CGRectMake(34, 0, size.height, size.height);
        _navigation_title_label.frame = CGRectMake(size.height+34, 0, size.width-(size.height+34)*2, size.height);
    }else {
        _navigation_back_btn.frame =  CGRectMake(0, 0, size.height, size.height);
        _navigation_title_label.frame = CGRectMake(size.height, 0, size.width-size.height*2, size.height);
    }
#pragma clang diagnostic pop
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight) {
        [UIApplication sharedApplication].yn_orientation = UIInterfaceOrientationMaskLandscape;
    }else {
        [UIApplication sharedApplication].yn_orientation = UIInterfaceOrientationMaskPortrait;
    }
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        UIInterfaceOrientation val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    
    // 添加返回按钮
    if (!_navigation_back_btn && !_hiddenBackButton) {
        _navigation_back_btn = [UIButton buttonWithType:UIButtonTypeSystem];
        if (!self.yn_backImage) {
            [_navigation_back_btn setImage:[UIImage imageNamed:@"Resources.bundle/nav_back_btn"] forState:normal];
        }else {
            [_navigation_back_btn setImage:self.yn_backImage forState:normal];
        }
        [_navigation_back_btn addTarget:self action:@selector(yn_customBackButtonClikedMethod:) forControlEvents:UIControlEventTouchUpInside];
        _navigation_back_btn.tintColor = self.navigationController.navigationBar.tintColor;
        [self.navigationController.navigationBar addSubview:_navigation_back_btn];
    }
    
    // 添加标题
    if (!_navigation_title_label) {
        _navigation_title_label = [[UILabel alloc] init];
        _navigation_title_label.clipsToBounds = YES;
        _navigation_title_label.numberOfLines = 2;
        _navigation_title_label.backgroundColor = [UIColor clearColor];
        _navigation_title_label.textAlignment = NSTextAlignmentCenter;
        _navigation_title_label.font = [UIFont boldSystemFontOfSize:17];
        _navigation_title_label.textColor = self.navigationController.navigationBar.tintColor;
        if (self.yn_attributeTitle.length > 0) {
            self.title = @"";
            _navigation_title_label.attributedText = self.yn_attributeTitle;
        }
        [self.navigationController.navigationBar addSubview:_navigation_title_label];
    }
    
    return [UIBarButtonItem new];
}

/** 提供给子类重写返回按钮点击事件 */
- (void)yn_customBackButtonClikedMethod:(UIButton *)backButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isLiuHai {
    BOOL isPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        isPhoneX = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0.0;
    }
    return isPhoneX;
}

@end
