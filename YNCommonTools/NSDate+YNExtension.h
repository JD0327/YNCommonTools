//
//  NSDate+YNExtension.h
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2020/3/4.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (YNExtension)

#pragma mark - Component Properties
@property (assign, nonatomic, readonly) NSInteger yn_year;                  // 年
@property (assign, nonatomic, readonly) NSInteger yn_month;                 // 月
@property (assign, nonatomic, readonly) NSInteger yn_day;                   // 日
@property (assign, nonatomic, readonly) NSInteger yn_hour;                  // 时
@property (assign, nonatomic, readonly) NSInteger yn_minute;                // 分
@property (assign, nonatomic, readonly) NSInteger yn_second;                // 秒
@property (assign, nonatomic, readonly) long long yn_timestamp;             // 时间戳（秒）
@property (assign, nonatomic, readonly) long long yn_timestamps;            // 时间戳（毫秒）
@property (assign, nonatomic, readonly) NSInteger yn_weekday;               // 星期几，1~7 = 周日~周六
@property (assign, nonatomic, readonly) NSInteger yn_weekdayOrdinal;        // 这个月的第几个周几
@property (assign, nonatomic, readonly) NSInteger yn_weekOfMonth;           // 本周是这个月的第几个周
@property (assign, nonatomic, readonly) NSInteger yn_weekOfYear;            // 本周是这一年的第几个周
@property (assign, nonatomic, readonly) NSInteger yn_quarter;               // 季度
@property (assign, nonatomic, readonly) BOOL yn_isLeapMonth;                // 是否闰月
@property (assign, nonatomic, readonly) BOOL yn_isLeapYear;                 // 是否闰年
@property (assign, nonatomic, readonly) BOOL yn_isToday;                    // 是否今天
@property (assign, nonatomic, readonly) BOOL yn_isYesterday;                // 是否昨天

/** 获取偏移年*/
- (NSDate *)yn_dateByOffsetYears:(NSInteger)years;

/** 获取偏移月 */
- (NSDate *)yn_dateByOffsetMonths:(NSInteger)months;

/** 获取偏移周 */
- (NSDate *)yn_dateByOffsetWeeks:(NSInteger)weeks;

/** 获取偏移天 */
- (NSDate *)yn_dateByOffsetDays:(NSInteger)days;

/** 获取偏移小时 */
- (NSDate *)yn_dateByOffsetHours:(NSInteger)hours;

/** 获取偏移分钟 */
- (NSDate *)yn_dateByOffsetMinutes:(NSInteger)minutes;

/** 获取偏移秒 */
- (NSDate *)yn_dateByOffsetSeconds:(NSInteger)seconds;

/** 获取格式化的时间，时区是东八区 */
- (NSString *)yn_stringWithFormat:(NSString *)format;

/** 将时间字符串格式化为时间 */
+ (NSDate *)yn_dateWithString:(NSString *)dateString format:(NSString *)format;

/** 将时间戳转为时间 */
+ (NSDate *)yn_dataWithTimeStamp:(long long)timestamp;

/** 消息化当前的时间，例如：刚刚，1分钟前，2分钟前，1小时前 */
+ (NSString *)yn_stringWithWithDate:(NSDate *)date;

/** 消息化当前的时间，例如：刚刚，1分钟前，2分钟前，1小时前 */
+ (NSString *)yn_stringWithTimeStamp:(long long)timestamp;

/** 消息化当前的时间，例如：刚刚，1分钟前，2分钟前，1小时前 */
+ (NSString *)yn_stringWithDateString:(NSString *)dateString format:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
