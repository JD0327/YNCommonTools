//
//  NextViewController.m
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2019/6/5.
//  Copyright © 2019 贾亚宁. All rights reserved.
//

#import "NextViewController.h"
#import "YNCommonTools.h"
#import <Masonry.h>

@interface NextViewController () <UITableViewDelegate,UITableViewDataSource>
 
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rt_title = @"测试测试";
    
    self.rt_disableFullScreenPop = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage yn_imageWithColor:[UIColor orangeColor]] forBarMetrics:UIBarMetricsDefault];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
        }
    }];
    
    self.tableView.mj_header = [YNRefreshNormalHeader headerWithRefreshingBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.dataList addObject:@"123"];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
    }];
    
    self.tableView.mj_footer = [YNRefreshNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.dataList addObject:@"123"];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count+30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = @[].mutableCopy;
    }
    return _dataList;
}

@end
