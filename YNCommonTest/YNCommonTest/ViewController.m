//
//  ViewController.m
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2019/5/14.
//  Copyright © 2019 贾亚宁. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"
#import "YNCommonTools.h"
#import "YNBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - 阿森纳近阿森纳费劲啊看是否那可是

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.rt_title = @"阿克苏缴费卡机是南方科技阿森纳法就开始内发送南方科技爱上你发送内发送那开发";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tap:) name:YNBannerViewDidClickedNotification object:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NextViewController *vc = [[NextViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 25, 25)];
//    imageView.image = [[UIImage imageNamed:@"cdp-data"] imageChangeColor:[UIColor orangeColor]];
//    [imageView yn_drawShadowWithOffset:CGSizeZero radius:1 color:[UIColor blackColor] opacity:0.6];
//    [self.view addSubview:imageView];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [imageView yn_shakeAnimationForView];
//    });
    
//    NSLog(@"%ld",[[NSDate date] yn_year]);
//    NSLog(@"%ld",[[NSDate date] yn_month]);
//    NSLog(@"%ld",[[NSDate date] yn_day]);
//    NSLog(@"%ld",[[NSDate date] yn_hour]);
//    NSLog(@"%ld",[[NSDate date] yn_minute]);
//    NSLog(@"%ld",[[NSDate date] yn_second]);
//    NSLog(@"%lld",[[NSDate date] yn_timestamp]);
//    NSLog(@"%lld",[[NSDate date] yn_timestamps]);
//    NSLog(@"%ld",[[NSDate date] yn_weekday]);
//    NSLog(@"%ld",[[NSDate date] yn_weekdayOrdinal]);
//    NSLog(@"%ld",[[NSDate date] yn_weekOfMonth]);
//    NSLog(@"%ld",[[NSDate date] yn_weekOfYear]);
//    NSLog(@"%ld",[[NSDate date] yn_quarter]);
//
//    NSLog(@"---------------------------");
//
//    NSLog(@"%@",NSDate.date);
//    NSLog(@"%@",[NSDate yn_dataWithTimeStamp:[NSDate date].yn_timestamps]);
//
//    NSLog(@"---------------------------");
//
//    NSLog(@"%@",[NSDate yn_stringWithTimeStamp:1583123339]);
//
//    NSLog(@"%@",[[NSDate yn_dataWithTimeStamp:1583123339] yn_stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]);
    
    
//    WSDatePickerView *picker = [[WSDatePickerView alloc] initWithDateStyle:WSDateStyleShowYearMonthDayHourMinute scrollToDate:[[NSDate date] yn_dateByOffsetMinutes:-10] CompleteBlock:^(NSDate * _Nonnull date) {
//
//    }];
//    [picker show];
    
//    [YNRBDMuteSwitch share].muteBlock = ^(BOOL isMute) {
//        NSLog(@"%d",isMute);
//    };
    
    [[YNBannerView bannerWithBlock:^(YNBannerViewMaker * _Nonnull make) {
        make.content = @"a按实际你发送方面两个接口反射镜DNF卡十多年急不可待深V亏损的就能看方面考虑到伴娘吗方式快是的暖不暖分开搜的那把接口是sdasd";
        make.advertImg = @"https://tpc.googlesyndication.com/simgad/14118940938322651230?sqp=4sqPyQQ7QjkqNxABHQAAtEIgASgBMAk4A0DwkwlYAWBfcAKAAQGIAQGdAQAAgD-oAQGwAYCt4gS4AV_FAS2ynT4&rs=AOga4ql6iHxSBclKsBZpm6voDKIYz5g8rQ";
        make.payload = @"草泥马";
    }] show];
    
    
//    [[YNBannerView bannerWithBlock:^(YNBannerViewMaker * _Nonnull make) {
//        make.content = @"13123123123";
//    }] show];
}

- (void)tap:(NSNotification *)notification {
    NSLog(@"%@",notification.object);
}

@end
