//
//  ViewController.m
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2019/5/14.
//  Copyright © 2019 贾亚宁. All rights reserved.
//

#import "ViewController.h"
#import "YNCommonTools.h"
#import <AFNetworking.h>
#import "NextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - 阿森纳近阿森纳费劲啊看是否那可是

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"首页";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(220, 100, 50, 50);
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonTap:(UIButton *)sender {
    NextViewController *vc = [[NextViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
