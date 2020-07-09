//
//  NSDate+YNExtension.m
//  YNCommonToolsExample
//
//  Created by 贾亚宁 on 2020/3/4.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "NSDate+YNExtension.h"

@implementation NSDate (YNExtension)

- (NSInteger)yn_year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)yn_month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)yn_day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)yn_hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)yn_minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)yn_second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (long long)yn_timestamp {
    return [self timeIntervalSince1970];
}

- (long long)yn_timestamps {
    return [self timeIntervalSince1970]*1000;
}

- (NSInteger)yn_weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)yn_weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)yn_weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)yn_weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)yn_quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)yn_isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)yn_isLeapYear {
    NSUInteger yn_year = self.yn_year;
    return ((yn_year % 400 == 0) || ((yn_year % 100 != 0) && (yn_year % 4 == 0)));
}

- (BOOL)yn_isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate date].yn_day == self.yn_day;
}

- (BOOL)yn_isYesterday {
    NSDate *added = [self yn_dateByOffsetDays:1];
    return [added yn_isToday];
}

- (NSDate *)yn_dateByOffsetYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)yn_dateByOffsetMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)yn_dateByOffsetWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)yn_dateByOffsetDays:(NSInteger)days {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)yn_dateByOffsetHours:(NSInteger)hours {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hours];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)yn_dateByOffsetMinutes:(NSInteger)minutes {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:minutes];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)yn_dateByOffsetSeconds:(NSInteger)seconds {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:seconds];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSString *)yn_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

+ (NSDate *)yn_dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSDate *)yn_dataWithTimeStamp:(long long)timestamp {
    NSString *time = [NSString stringWithFormat:@"%lld",timestamp];
    NSTimeInterval interval = 0.f;
    if (time.length >= 13) {
        time = [time substringWithRange:NSMakeRange(0, 13)];
        interval = [time doubleValue] / 1000.0;
    }else {
        interval = [time doubleValue];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}

+ (NSString *)yn_stringWithWithDate:(NSDate *)date {
    
    double currTime = (long)[date timeIntervalSince1970];
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    double distanceTime = now - currTime;
    NSString * distanceStr;
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:date];
    
    [df setDateFormat:@"dd"];
    NSString * nowDay = [df stringFromDate:[NSDate date]];
    NSString * lastDay = [df stringFromDate:date];
    
    //小于一分钟
    if (distanceTime < 60) {
        distanceStr = @"刚刚";
    }
    //时间小于一个小时
    else if (distanceTime <60*60) {
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }
    //时间小于一天
    else if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){
        distanceStr = [NSString stringWithFormat:@"今天%@",timeStr];
    }
    else if(distanceTime<24*60*60*3 && [nowDay integerValue] != [lastDay integerValue]){
        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天%@",timeStr];
        }
        else if ([nowDay integerValue] - [lastDay integerValue] == 2 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 2)) {
            distanceStr = [NSString stringWithFormat:@"前天%@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:date];
        }
    }else {
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:date];
    }
    return distanceStr;
}

+ (NSString *)yn_stringWithTimeStamp:(long long)timestamp {
    NSDate *date = [NSDate yn_dataWithTimeStamp:timestamp];
    return [NSDate yn_stringWithWithDate:date];
}

+ (NSString *)yn_stringWithDateString:(NSString *)dateString format:(NSString *)format {
    NSDate *date = [NSDate yn_dateWithString:dateString format:format];
    return [NSDate yn_stringWithWithDate:date];
}
@end
