//
//  YNBannerViewMaker.h
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/7/8.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YNBannerViewMaker : UIView
/**
 *  展示icon，默认为App图标
 */
@property(strong, nonatomic) UIImage  *icon;
/**
 *  标题，默认为App的名称
 */
@property (strong, nonatomic) NSString *title;
/**
 *  标题颜色
 */
@property (strong, nonatomic) UIColor *titleColor;
/**
 *  内容颜色
 */
@property (strong, nonatomic) UIColor *contentColor;
/**
 *  时间颜色
 */
@property (strong, nonatomic) UIColor *timeColor;
/**
 *  时间，默认为“现在”
 */
@property (strong, nonatomic) NSString *date;
/**
 *  展示的内容，如果内容为空，则调用无效
 */
@property (strong, nonatomic) NSString *content;
/**
 *  展示的内容广告图，可以是程序内容的图片，也可以是网络图片
 */
@property (strong, nonatomic, nullable) id advertImg;
/**
 *  内容折叠，当内容过长，并且超过2行时，进行弹框折叠，默认为YES。
 *  弹框被展示或为NO时，内容最多展示4行。
 */
@property (assign, nonatomic, getter=isFold) BOOL fold;
/**
 *  停留时间，默认为4.0s
 */
@property (assign, nonatomic) NSTimeInterval stayDuration;
/**
 *  展示声音，默认为系统铃音，ID = 1312
 */
@property (assign, nonatomic) UInt32 soundID;
/**
 *  禁止响铃和震动
 */
@property (assign, nonatomic, getter=isNoRingAndVibrate) BOOL noRingAndVibrate;
/**
 *  禁止响铃
 */
@property (assign, nonatomic, getter=isNoRing) BOOL noRing;
/**
 *  指定响铃文件
 */
@property (strong, nonatomic) NSString *soundName;
/**
 *  静音时是否支持震动，YES 支持 NO 不支持  默认为YES
 */
@property (assign, nonatomic, getter=isVibrateOnMute) BOOL vibrateOnMute;
/**
 *  需要展示在window上，在iOS13中增加UIScene使得window成为不固定，所以需要指定window
 *  默认认为程序中只存在一个window
 */
@property (nonatomic, weak) UIWindow *window;
/**
 *  扩展字段，在用户点击弹框时所携带的返回内容
 */
@property (nonatomic) id payload;
/**
 *  默认
 */
+ (YNBannerViewMaker *)defaultMaker;

@end

NS_ASSUME_NONNULL_END
