//
//  YNRefreshConfig.h
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2020/3/5.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YNRefreshConfig : NSObject

/** 配置刷新 */
+ (YNRefreshConfig *)share;

/** 上拉刷新-普通状态 */
@property (strong, nonatomic) NSString *headerIdleString;

/** 上拉刷新-普通状态 */
@property (strong, nonatomic) NSString *headerPullingString;

/** 上拉刷新-普通状态 */
@property (strong, nonatomic) NSString *headerRefreshingString;

/** 上拉刷新-普通状态 */
@property (strong, nonatomic) NSString *footerIdleString;

/** 上拉刷新-普通状态 */
@property (strong, nonatomic) NSString *footerPullingString;

/** 上拉刷新-普通状态 */
@property (strong, nonatomic) NSString *footerRefreshingString;

/** 上拉刷新-普通状态 */
@property (strong, nonatomic) NSString *footerNoMoreDataString;

/** 文字字体 */
@property (strong, nonatomic) UIFont *font;

/** 文字颜色 */
@property (strong, nonatomic) UIColor *textColor;

/** 下拉刷新控件的高度 */
@property (assign, nonatomic) CGFloat headerHeight;

/** 上拉加载控件的a高度 */
@property (assign, nonatomic) CGFloat footerHeight;

/** 加载圈和文字之间的距离 */
@property (assign, nonatomic) CGFloat space;

/** 加载圈颜色 */
@property (strong, nonatomic) UIColor *loadingColor;

/** 加载圈的大小 */
@property (assign, nonatomic) CGFloat loadingWidth;

/** 加载圈的线宽 */
@property (assign, nonatomic) CGFloat lineWidth;

@end

NS_ASSUME_NONNULL_END
