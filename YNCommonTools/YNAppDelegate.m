//
//  YNAppDelegate.m
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2020/3/3.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "YNAppDelegate.h"

@implementation YNAppDelegate

#pragma  - mark 屏幕旋转
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return self.orientation;
}

#pragma mark - 第三方键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier {
    if (!self.isAllowOtherKeyboard) {
        if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
            return NO;
        }
    }
    return YES;
}

@end
