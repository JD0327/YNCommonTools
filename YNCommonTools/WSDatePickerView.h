//
//  WSDatePickerView.h
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/3/5.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+YNExtension.h"

NS_ASSUME_NONNULL_BEGIN

// 日期选择的类型
typedef NS_ENUM(NSInteger, WSDateStyle) {
    WSDateStyleShowYearMonthDayHourMinute  = 0,//年月日时分
    WSDateStyleShowMonthDayHourMinute,//月日时分
    WSDateStyleShowYearMonthDay,//年月日
    WSDateStyleShowMonthDay,//月日
    WSDateStyleShowHourMinute,//时分
    WSDateStyleShowYearMonth // 年月
};

@interface WSDatePickerConfig : NSObject

/** 日期选择控件的配置 */
+ (WSDatePickerConfig *)share;
/** 大号年份字体颜色(默认灰色)想隐藏可以设置为clearColor */
@property (strong, nonatomic) UIColor *yearLabelColor;
/** 确定按钮颜色 */
@property (strong, nonatomic) UIColor *doneButtonColor;
/** 确定按钮字体 */
@property (strong, nonatomic) UIFont  *doneButtonFont;
/** 年-月-日-时-分 文字颜色 */
@property (strong, nonatomic) UIColor *dateLabelColor;
/** 滚轮日期颜色 */
@property (strong, nonatomic) UIColor *datePickerColor;

@end

@interface WSDatePickerView : UIView

/** 限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期 */
@property (strong, nonatomic) NSDate *maxLimitDate;

/** 限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期 */
@property (strong, nonatomic) NSDate *minLimitDate;

/** 默认滚动到当前时间 */
- (instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *date))completeBlock;

/** 滚动到指定的的日期 */
- (instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *date))completeBlock;

/** 呈现 */
- (void)show;

@end

NS_ASSUME_NONNULL_END
