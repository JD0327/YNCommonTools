//
//  BaseViewController.m
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2019/12/16.
//  Copyright © 2019 贾亚宁. All rights reserved.
//

#import "BaseViewController.h"
#import "YNCommonTools.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rt_hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
