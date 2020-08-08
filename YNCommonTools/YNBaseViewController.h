//
//  BaseViewController.h
//  RT
//
//  Created by 贾亚宁 on 2020/8/8.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import <RTRootNavigationController/RTRootNavigationController.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (Extension)
/**
 * 记录当前手机屏幕方向
 */
@property (assign, nonatomic) UIInterfaceOrientationMask yn_orientation;
/**
 * 是否允许使用第三方键盘
 */
@property (assign, nonatomic) BOOL allowOtherKeyBoard;

@end

@interface BaseRootNavigationController : RTRootNavigationController

@end

@interface YNBaseViewController : UIViewController
/**
 * 设置控制器富文本标题，注意：此富文本优先级高于Controller自身的title
 */
@property (strong, nonatomic) NSAttributedString *yn_attributeTitle;
/**
 * 设置返回按钮的图片
 */
@property (strong, nonatomic) UIImage *yn_backImage;
/**
 * 隐藏返回按钮
 */
@property (assign, nonatomic, getter=isHiddenBackButton) BOOL hiddenBackButton;
/**
 * 提供给子类重写返回按钮点击事件
 */
- (void)yn_customBackButtonClikedMethod:(UIButton *)backButton;
/**
 * 强制旋转屏幕
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation;


@end

NS_ASSUME_NONNULL_END
