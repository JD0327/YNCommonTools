//
//  YNBaseViewController.m
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2020/3/3.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "YNBaseViewController.h"
#import "YNAppDelegate.h"

@interface YNBaseViewController ()

@end

@implementation YNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

/** 强制旋转屏幕 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    YNAppDelegate *delegate = (YNAppDelegate *)[UIApplication sharedApplication].delegate;
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight) {
        delegate.orientation = UIInterfaceOrientationMaskLandscape;
    }else {
        delegate.orientation = UIInterfaceOrientationMaskPortrait;
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

/** 自动旋转屏幕 */
- (void)autoInterfaceOrientation:(BOOL)isAuto {
    YNAppDelegate *delegate = (YNAppDelegate *)[UIApplication sharedApplication].delegate;
    if (isAuto) {
        delegate.orientation = UIInterfaceOrientationMaskAll;
    }else {
        delegate.orientation = UIInterfaceOrientationMaskPortrait;
    }
}

@end
