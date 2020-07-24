//
//  YNCommonMethod.h
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/3/6.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#ifndef YNCommonMethod_h
#define YNCommonMethod_h

#pragma mark - 视图相关扩展方法
__attribute((overloadable)) static inline CGRect
CGRectMake(CGPoint point, CGSize size)
{
  CGRect rect;
  rect.origin.x = point.x; rect.origin.y = point.y;
  rect.size.width = size.width; rect.size.height = size.height;
  return rect;
}

__attribute((overloadable)) static inline CGRect
CGRectMake(CGFloat x, CGFloat y, CGSize size)
{
  CGRect rect;
  rect.origin.x = x; rect.origin.y = y;
  rect.size.width = size.width; rect.size.height = size.height;
  return rect;
}

__attribute((overloadable)) static inline CGRect
CGRectMake(CGPoint point, CGFloat width, CGFloat height)
{
  CGRect rect;
  rect.origin.x = point.x; rect.origin.y = point.y;
  rect.size.width = width; rect.size.height = height;
  return rect;
}

#pragma mark - App版本相关扩展方法
__attribute((overloadable)) static inline NSString *
AppVersion(void)
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

__attribute((overloadable)) static inline NSString *
AppBuildVersion(void)
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

__attribute((overloadable)) static inline BOOL
AppisFirstLaunch(void)
{
    NSString *key = [NSString stringWithFormat:@"%@isFirstLaunch",AppVersion()];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL isFirst = [userDefault boolForKey:key];
    if (!isFirst) {
        [userDefault setBool:YES forKey:key];
        [userDefault synchronize];
    }
    return !isFirst;
}

__attribute((overloadable)) static inline BOOL
AppisFirstLaunchCurrentVersion(void)
{
    BOOL isFirst = AppisFirstLaunch();
    if (!isFirst) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *oldBundle = [userDefault stringForKey:@"appBundleVersionString"];
        NSString *newBundle = AppVersion();
        [userDefault setValue:newBundle forKey:@"appBundleVersionString"];
        return ![oldBundle isEqualToString:newBundle];
    }
    return YES;
}

__attribute((overloadable)) static inline BOOL
CheckWithVersion(NSString *version)
{
  NSString *currentVersion = AppVersion();
  if ([currentVersion isEqualToString:version]) {
      return NO;
  }
  NSArray *carray = [currentVersion componentsSeparatedByString:@"."];
  NSArray *narray = [version componentsSeparatedByString:@"."];
  NSInteger minCount = MIN(carray.count, narray.count);
  for (int i = 0; i < minCount; i++ ) {
      NSInteger befor = [[carray objectAtIndex:i] integerValue];
      NSInteger last  = [[narray objectAtIndex:i] integerValue];
      if (befor == last) {
          continue;
      }else {
          if (last > befor) {
              return YES;
          }else {
              return NO;
          }
      }
  }
  if (narray.count > carray.count) {
      narray = [narray subarrayWithRange:NSMakeRange(carray.count,  narray.count - carray.count)];
      for (NSString *string in narray) {
          if (string.integerValue > 0) {
              return YES;
          }
      }
  }
  return NO;
}

#pragma mark - 获取视图最上方控制器
__attribute((overloadable)) static inline UIViewController *
GetTopViewController(void) {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
            for (UIViewController *vc in topViewController.childViewControllers) {
                if ([vc isKindOfClass:[UINavigationController class]] && [(UINavigationController*)vc topViewController]) {
                    topViewController = vc;
                    break;
                }
            }
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            if (tab.viewControllers.count > 0) {
                topViewController = tab.selectedViewController;
            }else {
                topViewController = tab;
                break;
            }
        } else {
            break;
        }
    }
    return topViewController;
}

#pragma mark - 颜色相关扩展方法
__attribute((overloadable)) static inline UIColor *
ColorMake(CGFloat r, CGFloat g, CGFloat b, CGFloat a)
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

__attribute((overloadable)) static inline UIColor *
ColorMake(CGFloat r, CGFloat g, CGFloat b)
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

__attribute((overloadable)) static inline UIColor *
ColorMake(CGFloat w, CGFloat a)
{
    return [UIColor colorWithWhite:w/255.0 alpha:a];
}

__attribute((overloadable)) static inline UIColor *
ColorMakeWith16Color(NSInteger color, CGFloat alpha)
{
    return [UIColor colorWithRed:((float)((color & 0xFF0000) >> 16)) / 255.0 green:((float)((color & 0xFF00) >> 8)) / 255.0 blue :((float)(color & 0xFF)) / 255.0 alpha:alpha];
}

__attribute((overloadable)) static inline UIColor *
ColorMakeWith16Color(NSInteger color)
{
    return [UIColor colorWithRed:((float)((color & 0xFF0000) >> 16)) / 255.0 green:((float)((color & 0xFF00) >> 8)) / 255.0 blue :((float)(color & 0xFF)) / 255.0 alpha:1.0];
}

__attribute((overloadable)) static inline UIColor *
ColorMakeWithHashColor(NSString *hashColor, CGFloat alpha)
{
    //删除字符串中的空格
    NSString *cString = [[hashColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

__attribute((overloadable)) static inline UIColor *
ColorMakeWithHashColor(NSString *hashColor)
{
    return ColorMakeWithHashColor(hashColor, 1.0);
}

__attribute((overloadable)) static inline UIColor *
ColorMake(UIColor *lightColor, UIColor *darkColor)
{
    if (@available(iOS 13.0, *)) {
        UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return lightColor;
            }else {
                return darkColor;
            }
        }];
        return dyColor;
    }else{
        return lightColor;
    }
}

#endif /* YNCommonMethod_h */
