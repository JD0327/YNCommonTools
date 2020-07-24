// Copyright (c) 2016 rickytan <ricky.tan.xin@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>

@class RTRootNavigationController;

IB_DESIGNABLE
@interface UIViewController (RTRootNavigationController)
/**
 *  setting title
 */
@property (nonatomic, strong) IBInspectable NSString *rt_title;
/**
 *  setting atttitle
 */
@property (nonatomic, strong) IBInspectable NSAttributedString *rt_attributedTitle;
/**
 * 为路由而生
 */
@property (nonatomic, strong) IBInspectable NSDictionary *rt_routerUserInfo;
/*!
 *  @brief set this property to @b YES to disable interactive pop
 */
@property (nonatomic, assign) IBInspectable BOOL rt_disableInteractivePop;

/*!
 * @brief set this property to @b YES to disable full screen pop
 */
@property (nonatomic, assign) IBInspectable BOOL rt_disableFullScreenPop;

/**
 * @brief set this property to @b YES to hides BottomBar,  It must be assigned at initialization.
 */
@property (nonatomic, assign) IBInspectable BOOL rt_hidesBottomBarWhenPushed;
/**
 * @brief set this property to @b YES to hides backButton
 */
@property (nonatomic, assign) IBInspectable BOOL rt_hidesBackButton;
/**
 * @brief set @b rt_backButton image
 */
@property (nonatomic, strong) UIImage *rt_backBtnImage;
/*!
 *  @brief @c self\.navigationControlle will get a wrapping @c UINavigationController, use this property to get the real navigation controller
 */
@property (nonatomic, readonly, strong) RTRootNavigationController *rt_navigationController;

/*!
 *  @brief Override this method to provide a custom subclass of @c UINavigationBar, defaults return nil
 *
 *  @return new UINavigationBar class
 */
- (Class)rt_navigationBarClass;

/**
 * 自定义返回按钮点击事件
 */
- (void)customBackButtonMethod:(UIButton *)sender;

@end
