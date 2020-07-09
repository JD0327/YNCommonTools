//
//  YNBannerShareManager.h
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/7/8.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YNBannerShareManager : UIView

+ (YNBannerShareManager *)share;

@property (assign, nonatomic) NSInteger showCount;

@property (strong, nonatomic) NSMutableArray *makers;

@property (strong, nonatomic, nullable) NSTimer *rollTimer;

@property (strong, nonatomic, nullable) NSTimer *hiddenTimer;

@property (assign, nonatomic) NSTimeInterval timestamp;

@property (strong, nonatomic, nullable) UIView *acView;

@property (strong, nonatomic, nullable) UIView *bcView;

- (void)rollTimerMethod;

@end

NS_ASSUME_NONNULL_END
