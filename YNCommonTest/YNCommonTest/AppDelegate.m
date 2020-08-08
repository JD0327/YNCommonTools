//
//  AppDelegate.m
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/3/5.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <RTRootNavigationController.h>
#import "YNRefreshConfig.h"
#import "WSDatePickerView.h"
#import "YNCommonMethod.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *ov = @"2.5.1";
    if (CheckWithVersion(ov)) {
        NSLog(@"是新版本 -- %@",AppVersion());
    }
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UITabBarController *tabbar = [[UITabBarController alloc] init];
    [tabbar setViewControllers:@[[[RTRootNavigationController alloc] initWithRootViewController:[[ViewController alloc] init]]]];
    self.window.rootViewController = tabbar;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
    
}

//#pragma  - mark 屏幕旋转
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
//    return [UIApplication sharedApplication].yn_orientation;
//}
//
//#pragma mark - 第三方键盘
//- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier {
//    if (![UIApplication sharedApplication].allowOtherKeyBoard) {
//        if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
//            return NO;
//        }
//    }
//    return YES;
//}

@end
