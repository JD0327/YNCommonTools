//
//  YNAppDelegate.h
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2020/3/3.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YNAppDelegate : UIResponder
/** 主窗口 */
@property (strong, nonatomic) UIWindow *window;
/** 是否允许旋转屏幕 */
@property (assign, nonatomic) UIInterfaceOrientationMask orientation;
/** 是否允许第三方键盘 */
@property (assign, nonatomic, getter=isAllowOtherKeyboard) BOOL allowOtherKeyboard;
@end

NS_ASSUME_NONNULL_END
