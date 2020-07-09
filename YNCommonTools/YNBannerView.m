//
//  YNBannerView.m
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/7/8.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "YNBannerView.h"
#import "YNBannerShareManager.h"
#import <AudioToolbox/AudioToolbox.h>

#define BScreenWidth [UIScreen mainScreen].bounds.size.width
#define BScreenHeight [UIScreen mainScreen].bounds.size.height
// 判断是否是iphoneX
#define kBannerIPhoneX ({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

@interface YNBannerView ()
@property (strong, nonatomic) YNBannerViewMaker *maker;
@property (strong, nonatomic) UIImageView *appiconImg;
@property (strong, nonatomic) UILabel *titleL;
@property (strong, nonatomic) UILabel *contentL;
@property (strong, nonatomic) UILabel *timeL;
@property (strong, nonatomic) UIImageView *advertImg;
@property (assign, nonatomic) CGPoint startPoint;
@end

@implementation YNBannerView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 构造器 */
+ (YNBannerView *)bannerWithBlock:(void(^)(YNBannerViewMaker *make))block {
    // 1、获取单例类
    YNBannerShareManager *share = [YNBannerShareManager share];
    // 2、获取maker
    YNBannerViewMaker *maker = [YNBannerViewMaker defaultMaker];
    block(maker);
    // 3、判断内容
    if (maker.content.length == 0 || maker.content == nil || [maker.content isEqualToString:@""]) {
        return nil;
    }
    // 4、检查消息缓存数组是否还存有数据，如果没有数据，则需要立即弹出最新消息，如果消息数组中有数据，则将此消息放入消息缓存队列，等待被执行
    if (share.makers.count > 0) {
        [share.makers addObject:maker];
    }else {
        // 消息数组中没有数据，需要查看时间是否超出1s
        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
        if (timestamp - share.timestamp <= 1) {
            // 未超过1s的数据，需要放入消息缓存队列中
            [share.makers addObject:maker];
            // 检查轮询是否开启
            if (!share.rollTimer) {
                share.rollTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:share selector:@selector(rollTimerMethod) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:share.rollTimer forMode:NSRunLoopCommonModes];
            }
        }else {
            share.timestamp = timestamp;
            // 超过1s的消息，需要立即弹出
            return [YNBannerView bannerViewWithMaker:maker];
        }
    }
    return nil;
}

+ (void)banner {
    if ([YNBannerShareManager share].makers.count > 0) {
        YNBannerViewMaker *maker = (YNBannerViewMaker *)[YNBannerShareManager share].makers.firstObject;
        [YNBannerShareManager share].timestamp = [[NSDate date] timeIntervalSince1970];
        [[YNBannerView bannerViewWithMaker:maker] show];
        [[YNBannerShareManager share].makers removeObjectAtIndex:0];
    }
}

/** 执行方法 */
+ (YNBannerView *)bannerViewWithMaker:(YNBannerViewMaker *)maker {
    // 1、获取单例类
    YNBannerShareManager *share = [YNBannerShareManager share];
    // 2、创建弹框
    if (!share.acView) {
        share.acView = [[YNBannerView alloc] initWithFrame:CGRectZero maker:maker];
        return (YNBannerView *)share.acView;
    }
    share.bcView = [[YNBannerView alloc] initWithFrame:CGRectZero maker:maker];
    return (YNBannerView *)share.bcView;
}

- (instancetype)initWithFrame:(CGRect)frame maker:(YNBannerViewMaker *)maker {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 添加屏幕旋转通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarOrientationNotification) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        // 添加敲击和横扫手势
        self.maker = maker;
        [self addGestureRecognizer];
        // 设置圆角阴影
        self.layer.cornerRadius = 13;
        self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
        self.layer.shadowRadius = 3.5;
        self.layer.shadowOpacity = 0.35;
        self.layer.shadowOffset = CGSizeZero;
        // 添加子视图
        [self addSubview:self.appiconImg];
        [self addSubview:self.titleL];
        [self addSubview:self.timeL];
        [self addSubview:self.contentL];
        [self addSubview:self.advertImg];
    }
    return self;
}

- (void)setMaker:(YNBannerViewMaker *)maker {
    _maker = maker;
    self.titleL.textColor = maker.titleColor;
    self.contentL.textColor = maker.contentColor;
    self.timeL.textColor = maker.timeColor;
    self.frame = CGRectMake(self.fixedX, -self.fixedY-self.contentHeight, self.fixedWidth, self.contentHeight);
}

- (void)applicationDidChangeStatusBarOrientationNotification {
    // 切换横竖屏后需要重新计算frame
    if (self) {
        self.frame = CGRectMake(self.fixedX, self.fixedY, self.fixedWidth, self.contentHeight);
    }
}

- (void)addGestureRecognizer {
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpGesture:)];
    swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUpGesture];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapGesture:(UITapGestureRecognizer *)sender {
    NSNotification *notification = [[NSNotification alloc] initWithName:YNBannerViewDidClickedNotification object:self.maker.payload userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self hidden];
}

- (void)swipeUpGesture:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        [self hidden];
    }
}

/** 展示 */
- (void)show {
    __weak typeof(self)weakSelf = self;
    // 发送通知
    NSNotification *notification = [[NSNotification alloc] initWithName:YNBannerViewDidShowNotification object:self.maker.payload userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    // 停止计时器的操作
    if ([YNBannerShareManager share].hiddenTimer) {
        [[YNBannerShareManager share].hiddenTimer invalidate];
        [YNBannerShareManager share].hiddenTimer = nil;
    }
    // 禁止响铃和震动
    if (!self.maker.isNoRingAndVibrate) {
        // 禁止响铃
        if (self.maker.noRing) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }else {
            [YNRBDMuteSwitch share].muteBlock = ^(BOOL isMute) {
                if (!isMute) {
                    SystemSoundID soundID = weakSelf.maker.soundID;
                    if (weakSelf.maker.soundName) {
                        NSURL *url = [[NSBundle mainBundle] URLForResource:weakSelf.maker.soundName withExtension:nil];
                        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
                    }
                    AudioServicesPlaySystemSound(soundID);
                }else {
                    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                }
            };
        }
    }
    // 进行赋值
    self.appiconImg.image = self.maker.icon;
    self.titleL.text = self.maker.title;
    self.timeL.text = self.maker.date;
    if ([self.maker.advertImg isKindOfClass:[UIImage class]]) {
        self.advertImg.image = self.maker.advertImg;
    }else if ([self.maker.advertImg isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *)self.maker.advertImg;
        if ([string containsString:@"http"]) {
            __weak typeof(self)weakSelf = self;
            [[[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    weakSelf.advertImg.image = [UIImage imageWithData:data];
                }];
            }] resume];
        }else {
            self.advertImg.image = [UIImage imageNamed:string];
        }
    }else {
        self.maker.advertImg = nil;
    }
    [self.maker.window addSubview:self];
    [self.maker.window bringSubviewToFront:self];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.frame = CGRectMake(weakSelf.fixedX, weakSelf.fixedY, weakSelf.fixedWidth, weakSelf.contentHeight);
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if ([YNBannerShareManager share].bcView) {
            [[YNBannerShareManager share].acView removeFromSuperview];
            [YNBannerShareManager share].acView = [YNBannerShareManager share].bcView;
            [YNBannerShareManager share].bcView = nil;
        }
        [YNBannerShareManager share].hiddenTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:strongSelf selector:@selector(hidden) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:[YNBannerShareManager share].hiddenTimer forMode:NSRunLoopCommonModes];
    }];
}

/** 隐藏 */
- (void)hidden {
    // 发送通知
    NSNotification *notification = [[NSNotification alloc] initWithName:YNBannerViewDidHiddenNotification object:self.maker.payload userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    // 停止计时器的操作
    if ([YNBannerShareManager share].hiddenTimer) {
        [[YNBannerShareManager share].hiddenTimer invalidate];
        [YNBannerShareManager share].hiddenTimer = nil;
    }
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        weakSelf.frame = CGRectMake(weakSelf.fixedX, -weakSelf.fixedY-weakSelf.contentHeight, weakSelf.fixedWidth, weakSelf.contentHeight);
    } completion:^(BOOL finished) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [weakSelf removeFromSuperview];
            [YNBannerShareManager share].acView = nil;
        }];
    }];
}

#pragma  - mark lazy
- (UIImageView *)appiconImg {
    if (!_appiconImg) {
        _appiconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        _appiconImg.layer.masksToBounds = YES;
        _appiconImg.layer.cornerRadius = 5;
    }
    return _appiconImg;
}

- (UIImageView *)advertImg {
    if (!_advertImg) {
        _advertImg = [[UIImageView alloc] init];
        _advertImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _advertImg;
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.font = [UIFont systemFontOfSize:14];
    }
    return _titleL;
}

- (UILabel *)contentL {
    if (!_contentL) {
        _contentL = [[UILabel alloc] init];
        _contentL.font = [UIFont systemFontOfSize:16];
        _contentL.numberOfLines = 2;
    }
    return _contentL;
}

- (UILabel *)timeL {
    if (!_timeL) {
        _timeL = [[UILabel alloc] init];
        _timeL.font = [UIFont systemFontOfSize:14];
        _timeL.textAlignment = NSTextAlignmentRight;
        _timeL.adjustsFontSizeToFitWidth = YES;
    }
    return _timeL;
}

- (CGFloat)fixedX {
    return (kBannerIPhoneX && ![self isPortrait]) ? 128 : 8;
}

- (CGFloat)fixedY {
    if (kBannerIPhoneX && [self isPortrait]) {
        return 40;
    }
    return [UIApplication sharedApplication].statusBarHidden ? 8 : 20;
}

- (CGFloat)fixedWidth {
    return (kBannerIPhoneX && ![self isPortrait]) ? BScreenWidth - 256 : BScreenWidth - 16;
}

- (CGFloat)contentHeight {
    if (self.maker.content.length == 0 || self.maker.content == nil || [self.maker.content isEqualToString:@""]) {
        return 0;
    }
    self.titleL.frame = CGRectMake(40, 10, self.fixedWidth-150, 22);
    self.timeL.frame = CGRectMake(self.fixedWidth-110, 10, 100, 20);
    self.contentL.text = self.maker.content;
    CGSize size = CGSizeZero;
    if (self.maker.advertImg) {
        self.advertImg.hidden = NO;
        self.advertImg.frame = CGRectMake(self.fixedWidth-50, 40, 40, 40);
        size = [self.contentL sizeThatFits:CGSizeMake(self.fixedWidth-70, MAXFLOAT)];
        if (size.height < 40) {
            size = self.advertImg.frame.size;
        }
        self.contentL.frame = CGRectMake(10, 40, self.fixedWidth-70, size.height);
    }else {
        self.advertImg.hidden = YES;
        size = [self.contentL sizeThatFits:CGSizeMake(self.fixedWidth-20, MAXFLOAT)];
        self.contentL.frame = CGRectMake(10, 40, self.fixedWidth-20, size.height);
    }
    return 50 + size.height;
}

- (BOOL)isPortrait {
    return BScreenWidth < BScreenHeight;
}

@end
