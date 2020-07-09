//
//  YNRBDMuteSwitch.h
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/7/7.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 用于回调当前静音按钮是否为静音状态的block
 @param isMute 如果静音按钮当前为静音状态，则为YES，否则为NO
 */
typedef void(^MuteBlock)(BOOL isMute);

/**
 用于回调当前真实音量的block
 
 @param currentRealVolume 当前的真实音量
 */
typedef void(^RealVolumeBlock)(CGFloat currentRealVolume);

/**
 用于监听音量变化的block
 @param oldVolume 原始音量值
 @param newVolume 新的音量值
 */
typedef void(^VolumeChangeBlock)(CGFloat oldVolume, CGFloat newVolume);

NS_ASSUME_NONNULL_BEGIN

@interface YNRBDMuteSwitch : NSObject

/**
 当前静音按钮是否为静音状态
 */
@property (nonatomic, copy) MuteBlock muteBlock;

/**
 当前的真实音量（静音按钮处于静音状态时音量为0）
 */
@property (nonatomic, copy) RealVolumeBlock realVolumeBlock;

/**
 监听音量变化（不考虑静音按钮处于静音状态的情况，该情况下仍正常返回实际的音量值，而不是0）
 */
@property (nonatomic, copy) VolumeChangeBlock volumeChangeBlock;


+(instancetype)share;

@end

NS_ASSUME_NONNULL_END
