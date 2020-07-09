//
//  YNBannerView.h
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/7/8.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "YNBannerViewMaker.h"
#import "YNRBDMuteSwitch.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  弹框事件监听 - （弹框出现）
 */
static NSString *const YNBannerViewDidShowNotification      = @"YNBannerViewDidShowNotification";
/**
 *  弹框事件监听 - （弹框消失）
 */
static NSString *const YNBannerViewDidHiddenNotification    = @"YNBannerViewDidHiddenNotification";
/**
 *  弹框事件监听 - （弹框被点击）
 */
static NSString *const YNBannerViewDidClickedNotification   = @"YNBannerViewDidClickedNotification";

@interface YNBannerView : UIView
/**
 *  构造器
 */
+ (YNBannerView *)bannerWithBlock:(void(^)(YNBannerViewMaker *make))block;
/**
 *  轮询定时器执行方法，单独调用此方法无效
 */
+ (void)banner;
/**
 *  展示
 */
- (void)show;

@end

NS_ASSUME_NONNULL_END
