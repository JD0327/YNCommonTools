//
//  YNBannerViewMaker.m
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/7/8.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "YNBannerViewMaker.h"

@implementation YNBannerViewMaker

//TODO: 默认
+ (YNBannerViewMaker *)defaultMaker {
    YNBannerViewMaker *maker = [[YNBannerViewMaker alloc] init];
    maker.icon = [UIImage imageNamed:@"AppIcon40x40"] ?: [UIImage imageNamed:@"AppIcon60x60"] ?: [UIImage imageNamed:@"AppIcon80x80"] ?: [UIImage imageNamed:@"AppIcon"];
    if (maker.icon.size.width<=0) {
        maker.icon = [UIImage imageNamed:@"Resources.bundle/ynbannerview_icon"];
    }
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    maker.title = [infoDictionary objectForKey:@"CFBundleDisplayName"] ?: [infoDictionary objectForKey:@"CFBundleName"];
    maker.titleColor = [UIColor colorWithRed:78/255.0 green:79/255.0 blue:82/255.0 alpha:1];
    maker.contentColor = [UIColor colorWithRed:17/255.0 green:17/255.0 blue:18/255.0 alpha:1];
    maker.timeColor = [UIColor colorWithRed:78/255.0 green:79/255.0 blue:82/255.0 alpha:1];
    maker.date = @"现在";
    maker.content = @"";
    maker.stayDuration = 4;
    maker.soundID = 1312;
    maker.vibrateOnMute = YES;
    maker.fold = YES;
    maker.noRing = NO;
    maker.noRingAndVibrate = NO;
    maker.window = [[UIApplication sharedApplication].windows lastObject];
    return maker;
}

@end
