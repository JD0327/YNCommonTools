//
//  YNBannerShareManager.m
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/7/8.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "YNBannerShareManager.h"
#import "YNBannerView.h"

static YNBannerShareManager *_manager = nil;
static dispatch_once_t _onceToken;

@implementation YNBannerShareManager
/** 单例 */
+ (YNBannerShareManager *)share {
    dispatch_once(&_onceToken, ^{
        _manager = [[[self class] alloc] init];
    });
    return _manager;
}

- (NSMutableArray *)makers {
    if (!_makers) {
        _makers = @[].mutableCopy;
    }
    return _makers;
}

/** 消息队列 */
- (void)rollTimerMethod {
    if (self.makers.count > 0) {
        [YNBannerView banner];
    }else {
        [self.rollTimer invalidate];
        self.rollTimer = nil;
    }
}

@end
