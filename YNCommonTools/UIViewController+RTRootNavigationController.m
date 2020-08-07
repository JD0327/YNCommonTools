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

#import <objc/runtime.h>

#import "UIViewController+RTRootNavigationController.h"
#import "RTRootNavigationController.h"

static const char RTNavigationBackButtonImage = '\0';

@implementation UIViewController (RTRootNavigationController)
@dynamic rt_disableInteractivePop;
@dynamic rt_disableFullScreenPop;
@dynamic rt_hidesBottomBarWhenPushed;

- (void)setRt_disableInteractivePop:(BOOL)rt_disableInteractivePop
{
    objc_setAssociatedObject(self, @selector(rt_disableInteractivePop), @(rt_disableInteractivePop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rt_disableInteractivePop
{
    return [objc_getAssociatedObject(self, @selector(rt_disableInteractivePop)) boolValue];
}

- (void)setRt_disableFullScreenPop:(BOOL)rt_disableFullScreenPop
{
    objc_setAssociatedObject(self, @selector(rt_disableFullScreenPop), @(rt_disableFullScreenPop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rt_disableFullScreenPop
{
    return [objc_getAssociatedObject(self, @selector(rt_disableFullScreenPop)) boolValue];
}

- (void)setRt_hidesBottomBarWhenPushed:(BOOL)rt_hidesBottomBarWhenPushed
{
    objc_setAssociatedObject(self, @selector(rt_hidesBottomBarWhenPushed), @(rt_hidesBottomBarWhenPushed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rt_hidesBottomBarWhenPushed
{
    return [objc_getAssociatedObject(self, @selector(rt_hidesBottomBarWhenPushed)) boolValue];
}

- (void)setRt_backBtnImage:(UIImage *)rt_backBtnImage {
    objc_setAssociatedObject(self, &RTNavigationBackButtonImage, rt_backBtnImage, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)rt_backBtnImage {
    return objc_getAssociatedObject(self, &RTNavigationBackButtonImage);
}

- (Class)rt_navigationBarClass
{
    return nil;
}

- (void)setRt_hidesBackButton:(BOOL)rt_hidesBackButton {
    objc_setAssociatedObject(self, @selector(rt_hidesBackButton), @(rt_hidesBackButton), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rt_hidesBackButton {
    return [objc_getAssociatedObject(self, @selector(rt_hidesBackButton)) boolValue];
}

- (RTRootNavigationController *)rt_navigationController
{
    UIViewController *vc = self;
    while (vc && ![vc isKindOfClass:[RTRootNavigationController class]]) {
        vc = vc.navigationController;
    }
    return (RTRootNavigationController *)vc;
}

- (void)setRt_title:(NSString *)rt_title {
    objc_setAssociatedObject(self, @selector(rt_title), rt_title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UILabel *labelView = (UILabel *)[self.navigationController.navigationBar viewWithTag:-275799581];
    if (labelView) {
        labelView.text = rt_title;
    }
}

- (NSString *)rt_title {
    return objc_getAssociatedObject(self, @selector(rt_title));
}

- (void)setRt_attributedTitle:(NSAttributedString *)rt_attributedTitle {
    objc_setAssociatedObject(self, @selector(rt_attributedTitle), rt_attributedTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UILabel *labelView = (UILabel *)[self.navigationController.navigationBar viewWithTag:-275799581];
    if (labelView) {
        labelView.attributedText = rt_attributedTitle;
    }
}

- (NSAttributedString *)rt_attributedTitle {
    return objc_getAssociatedObject(self, @selector(rt_attributedTitle));
}

- (void)setRt_routerUserInfo:(NSDictionary *)rt_routerUserInfo {
    objc_setAssociatedObject(self, @selector(rt_routerUserInfo), rt_routerUserInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)rt_routerUserInfo {
    return objc_getAssociatedObject(self, @selector(rt_routerUserInfo));
}

/**
 * 自定义返回按钮点击事件
 */
- (void)customBackButtonMethod:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
