//
//  YNRBDMuteSwitch.m
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/7/7.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "YNRBDMuteSwitch.h"
#import <AVFoundation/AVFoundation.h>

#define XTKVOContext(A) static void * const A = (void*)&A
XTKVOContext(XTShow);

@interface YNRBDMuteSwitch ()

@property (nonatomic, strong) NSDate *beginPlayDate;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) BOOL forMuteBlock;
@property (nonatomic, assign) BOOL forRealVolumeBlock;

@end

@implementation YNRBDMuteSwitch

+(instancetype)share {
    
    static YNRBDMuteSwitch *monitor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [YNRBDMuteSwitch new];
        
        [[AVAudioSession sharedInstance] addObserver:monitor forKeyPath:@"outputVolume" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:XTShow];
        [monitor preplayAudioForVolumeChangeNoti];
    });

    return monitor;
    
}

/*
 为了让音量变化的监听生效而提前播放一段音频
 */
-(void)preplayAudioForVolumeChangeNoti{

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];//保证不会打断第三方app的音频播放
    NSString *itemVideoPath = [[NSBundle mainBundle] pathForResource:@"detection" ofType:@"aiff"];
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:itemVideoPath]];
    self.player = player;
    [player play];

}

#pragma mark - 判断当前是否为静音
-(void)setMuteBlock:(MuteBlock)muteBlock{
    [self monitorMute];
    if (muteBlock) {
        self.forMuteBlock = YES;
        _muteBlock = [muteBlock copy];
    }
}

-(void)monitorMute{
    
    NSDate *beginPlayDate = [NSDate date];
    self.beginPlayDate = beginPlayDate;
    
    CFURLRef soundFileURLRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("Resources.bundle/detection"), CFSTR("aiff"), NULL);
    SystemSoundID soundFileID;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundFileID);
    AudioServicesAddSystemSoundCompletion(soundFileID, NULL, NULL, soundCompletionBlock, (__bridge void*) self);
    AudioServicesPlaySystemSound(soundFileID);
    
}

static void soundCompletionBlock(SystemSoundID SSID, void *mySelf){
    AudioServicesRemoveSystemSoundCompletion(SSID);
    [[YNRBDMuteSwitch share] playToEnd];
}

-(void)playToEnd{
    NSTimeInterval playDuring = [[NSDate date] timeIntervalSinceDate:self.beginPlayDate];
    BOOL isMute;
    if (playDuring >= 0.1) {
        isMute = NO;
    }else{
        isMute = YES;
    }
    
    if (self.muteBlock && self.forMuteBlock) {
        self.forMuteBlock = NO;
        self.muteBlock(isMute);
    }
    
    if (self.realVolumeBlock && self.forRealVolumeBlock) {
        self.forRealVolumeBlock = NO;
        if (isMute) {
            self.realVolumeBlock(0);
        }else{
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            CGFloat systemVolume = audioSession.outputVolume;
            self.realVolumeBlock(systemVolume);
        }
    }
}

#pragma mark - 获取当前实际音量
-(void)setRealVolumeBlock:(RealVolumeBlock)realVolumeBlock{
    [self monitorMute];
    if (realVolumeBlock) {
        self.forRealVolumeBlock = YES;
        _realVolumeBlock = realVolumeBlock;
    }
}

#pragma mark - 音量变化监控
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (context == XTShow && [keyPath isEqualToString:@"outputVolume"]) {
        if (self.volumeChangeBlock) {
            self.volumeChangeBlock([change[@"old"] floatValue], [change[@"new"] floatValue]);
        }
    }
}


@end
