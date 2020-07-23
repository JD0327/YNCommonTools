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

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - 阿森纳近阿森纳费劲啊看是否那可是

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.rt_title = @"首页";
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(220, 100, 50, 50);
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonTap:(UIButton *)sender {
    
//    NSDictionary *requestDic = @{
//        @"clientId" : @"test",
//        @"clientSecret" : @"111111",
//        @"imageCode" : @"930806",
//        @"password" : @"1111a11",
//        @"remeberMe" : @"0",
//        @"username" : @"admin"
//    };
    
//    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
//
//    AFHTTPRequestSerializer *serializer = [[AFHTTPRequestSerializer alloc] init];
//    [serializer setValue:@"zh-cn" forHTTPHeaderField:@"Accept-Language"];
//    manger.requestSerializer = serializer;
//
//    [manger POST:@"http://192.168.88.116:8080/auth/signIn" parameters:requestDic progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"%lld",uploadProgress.completedUnitCount);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error);
//    }];
    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURL *url = [NSURL URLWithString:@"http://192.168.88.116:8080/auth/signIn"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = [@"clientId=test&clientSecret=111111&imageCode=930806&password=111a111&remeberMe=0&username=admin" dataUsingEncoding:NSUTF8StringEncoding];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//           //8.解析数据
//           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//           NSLog(@"%@",dict);
//
//        NSLog(@"%@",response);
//       }];
//
//       //7.执行任务
//       [dataTask resume];
}


@end
