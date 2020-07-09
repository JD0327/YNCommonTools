//
//  YNBaseViewController.h
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2020/3/3.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YNBaseViewController : UIViewController

/** 强制旋转屏幕 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation;

/** 自动旋转屏幕 */
- (void)autoInterfaceOrientation:(BOOL)isAuto;

@end

NS_ASSUME_NONNULL_END
