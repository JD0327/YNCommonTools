//
//  YNRefreshConfig.m
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2020/3/5.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "YNRefreshConfig.h"

@implementation YNRefreshConfig

+ (YNRefreshConfig *)share {
    static YNRefreshConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[[self class] alloc] init];
        [config defaultConfig];
    });
    return config;
}

/** 默认配置 */
- (void)defaultConfig {
    self.headerIdleString = @"下拉刷新...";
    self.headerPullingString = @"松手刷新...";
    self.headerRefreshingString = @"正在刷新...";
    self.footerIdleString = @"上拉加载...";
    self.footerPullingString = @"松手加载...";
    self.footerRefreshingString = @"正在加载...";
    self.footerNoMoreDataString = @"没有更多数据啦~";
    self.font = [UIFont boldSystemFontOfSize:13];
    self.textColor = [UIColor colorWithRed:85/255.0 green:87/255.0 blue:89/255.0 alpha:1];
    self.loadingColor = [UIColor colorWithRed:85/255.0 green:87/255.0 blue:89/255.0 alpha:1];
    self.headerHeight = 50.f;
    self.footerHeight = 50.f;
    self.space = 5.f;
    self.loadingWidth = 20.f;
    self.lineWidth = 1.5;
}

@end
