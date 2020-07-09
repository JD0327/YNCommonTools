//
//  WSDatePickerView.m
//  YNCommonTest
//
//  Created by 贾亚宁 on 2020/3/5.
//  Copyright © 2020 贾亚宁. All rights reserved.
//

#import "WSDatePickerView.h"

#define kPickerSize self.datePicker.frame.size
#define RGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define RGB(r, g, b) RGBA(r,g,b,1)


#define MAXYEAR 5000
#define MINYEAR 1970
#define PICKER_HEIGHT 270.f

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kIPhoneX ({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

typedef void(^doneBlock)(NSDate *);

@implementation WSDatePickerConfig

+ (WSDatePickerConfig *)share {
    static WSDatePickerConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[[self class] alloc] init];
        [config defaultConfig];
    });
    return config;
}

- (void)defaultConfig {
    self.yearLabelColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:245/255.0 alpha:1];
    self.dateLabelColor = [UIColor colorWithRed:85/255.0 green:87/255.0 blue:89/255.0 alpha:1];
    self.datePickerColor = [UIColor colorWithRed:85/255.0 green:87/255.0 blue:89/255.0 alpha:1];
    self.doneButtonColor = [UIColor colorWithRed:85/255.0 green:87/255.0 blue:89/255.0 alpha:1];
    self.doneButtonFont = [UIFont systemFontOfSize:17];
}

@end

@interface WSDatePickerView () <UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate> {
    //日期存储数组
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minuteArray;
    NSString *_dateFormatter;
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    NSInteger preRow;
    
    NSDate *_startDate;
}

@property (strong, nonatomic) UIView *buttomView;
@property (strong, nonatomic) UILabel *showYearView;
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) UIPickerView *datePicker;
@property (strong, nonatomic) NSDate *scrollToDate;//滚到指定日期
@property (copy,   nonatomic) doneBlock doneBlock;
@property (assign, nonatomic) WSDateStyle datePickerStyle;

@end

@implementation WSDatePickerView

/**
 默认滚动到当前时间
 */
- (instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *date))completeBlock {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        
        self.datePickerStyle = datePickerStyle;
        switch (datePickerStyle) {
            case WSDateStyleShowYearMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case WSDateStyleShowMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case WSDateStyleShowYearMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case WSDateStyleShowMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case WSDateStyleShowHourMinute:
                _dateFormatter = @"HH:mm";
                break;
            case WSDateStyleShowYearMonth:
                _dateFormatter = @"yyyy-MM";
                break;
            default:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
        }
        
        [self setupUI];

        [self defaultConfig];
        
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

/**
 滚动到指定的的日期
 */
- (instancetype)initWithDateStyle:(WSDateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *date))completeBlock {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        
        self.datePickerStyle = datePickerStyle;
        self.scrollToDate = scrollToDate;
        switch (datePickerStyle) {
            case WSDateStyleShowYearMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case WSDateStyleShowMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case WSDateStyleShowYearMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case WSDateStyleShowMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case WSDateStyleShowHourMinute:
                _dateFormatter = @"HH:mm";
                break;
            case WSDateStyleShowYearMonth:
                _dateFormatter = @"yyyy-MM";
                break;
            default:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
        }
        
        [self setupUI];
        [self defaultConfig];
        
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
    }
    return self;
}

- (void)setupUI {
    
    // 点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    // 设置初始背景颜色
    self.backgroundColor = RGBA(0, 0, 0, 0);
    
    // 添加底部展示视图
    self.buttomView = [[UIView alloc] initWithFrame:CGRectMake(10, kScreenHeight, kScreenWidth-20, PICKER_HEIGHT)];
    self.buttomView.backgroundColor = [UIColor whiteColor];
    self.buttomView.layer.cornerRadius = 10;
    self.buttomView.layer.masksToBounds = YES;
    [self addSubview:self.buttomView];
    
    // 添加确定按钮
    self.doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.doneBtn setTitle:@"确定" forState:normal];
    [self.doneBtn setTitleColor:[UIColor whiteColor] forState:normal];
    self.doneBtn.titleLabel.font = [WSDatePickerConfig share].doneButtonFont;
    self.doneBtn.backgroundColor = [WSDatePickerConfig share].doneButtonColor;
    self.doneBtn.frame = CGRectMake(0, PICKER_HEIGHT-45, self.buttomView.frame.size.width, 45);
    [self.doneBtn addTarget:self action:@selector(doneButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttomView addSubview:self.doneBtn];
    
    // 添加Label
    self.showYearView = [[UILabel alloc] init];
    self.showYearView.userInteractionEnabled = YES;
    self.showYearView.text = @"1970";
    self.showYearView.textColor = [WSDatePickerConfig share].yearLabelColor;
    self.showYearView.font = [UIFont systemFontOfSize:100];
    self.showYearView.textAlignment = NSTextAlignmentCenter;
    self.showYearView.frame = CGRectMake(0, 0, self.buttomView.frame.size.width, PICKER_HEIGHT-45);
    [self.buttomView addSubview:self.showYearView];
    
    [[UIApplication sharedApplication].delegate.window bringSubviewToFront:self];
    
    [self.showYearView addSubview:self.datePicker];
}

- (void)defaultConfig {
    
    if (!_scrollToDate) {
        _scrollToDate = [NSDate date];
    }
    //循环滚动时需要用到
    preRow = (self.scrollToDate.yn_year-MINYEAR)*12+self.scrollToDate.yn_month-1;
    
    //设置年月日时分数据
    _yearArray = [self setArray:_yearArray];
    _monthArray = [self setArray:_monthArray];
    _dayArray = [self setArray:_dayArray];
    _hourArray = [self setArray:_hourArray];
    _minuteArray = [self setArray:_minuteArray];
    
    for (int i=0; i<60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0<i && i<=12)
            [_monthArray addObject:num];
        if (i<24)
            [_hourArray addObject:num];
        [_minuteArray addObject:num];
    }
    for (NSInteger i=MINYEAR; i<=MAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    
    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate yn_dateWithString:@"5000-12-31 23:59" format:@"yyyy-MM-dd HH:mm"];
    }
    //最小限制
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate yn_dateWithString:@"1970-01-01 00:00" format:@"yyyy-MM-dd HH:mm"];
    }
}

- (void)addLabelWithName:(NSArray *)nameArr {
    for (id subView in self.showYearView.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }
    for (int i=0; i<nameArr.count; i++) {
        CGFloat labelX = kPickerSize.width/(nameArr.count*2)+12+kPickerSize.width/nameArr.count*i;
        UILabel *label = [[UILabel alloc] init];
        if (0 == i) {
            label.frame = CGRectMake(labelX+8, self.showYearView.frame.size.height/2-15/2.0, 15, 15);
        }else {
            label.frame = CGRectMake(labelX, self.showYearView.frame.size.height/2-15/2.0, 15, 15);
        }
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [WSDatePickerConfig share].dateLabelColor;
        label.backgroundColor = [UIColor clearColor];
        [self.showYearView addSubview:label];
    }
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (self.datePickerStyle) {
        case WSDateStyleShowYearMonthDayHourMinute:
            [self addLabelWithName:@[@"年",@"月",@"日",@"时",@"分"]];
            return 5;
        case WSDateStyleShowMonthDayHourMinute:
            [self addLabelWithName:@[@"月",@"日",@"时",@"分"]];
            return 4;
        case WSDateStyleShowYearMonthDay:
            [self addLabelWithName:@[@"年",@"月",@"日"]];
            return 3;
        case WSDateStyleShowMonthDay:
            [self addLabelWithName:@[@"月",@"日"]];
            return 2;
        case WSDateStyleShowHourMinute:
            [self addLabelWithName:@[@"时",@"分"]];
            return 2;
        case WSDateStyleShowYearMonth:
            [self addLabelWithName:@[@"年",@"月"]];
            return 2;
        default:
            return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

-(NSArray *)getNumberOfRowsInComponent {
    
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = _monthArray.count;
    NSInteger dayNum = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
    NSInteger hourNum = _hourArray.count;
    NSInteger minuteNUm = _minuteArray.count;
    
    NSInteger timeInterval = MAXYEAR - MINYEAR;
    
    switch (self.datePickerStyle) {
        case WSDateStyleShowYearMonthDayHourMinute:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case WSDateStyleShowMonthDayHourMinute:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case WSDateStyleShowYearMonthDay:
            return @[@(yearNum),@(monthNum),@(dayNum)];
            break;
        case WSDateStyleShowMonthDay:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum)];
            break;
        case WSDateStyleShowHourMinute:
            return @[@(hourNum),@(minuteNUm)];
            break;
        case WSDateStyleShowYearMonth:
            return @[@(yearNum),@(monthNum)];
            break;
        default:
            return @[];
            break;
    }
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height <= 1)
        {
            singleLine.backgroundColor = RGBA(220, 220, 220, 1);
        }
    }

    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:16]];
    }
    NSString *title;
    
    switch (self.datePickerStyle) {
        case WSDateStyleShowYearMonthDayHourMinute:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            if (component==2) {
                title = _dayArray[row];
            }
            if (component==3) {
                title = _hourArray[row];
            }
            if (component==4) {
                title = _minuteArray[row];
            }
            break;
        case WSDateStyleShowYearMonthDay:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            if (component==2) {
                title = _dayArray[row];
            }
            break;
        case WSDateStyleShowMonthDayHourMinute:
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row];
            }
            if (component==2) {
                title = _hourArray[row];
            }
            if (component==3) {
                title = _minuteArray[row];
            }
            break;
        case WSDateStyleShowMonthDay:
            if (component==0) {
                title = _monthArray[row%12];
            }
            if (component==1) {
                title = _dayArray[row];
            }
            break;
        case WSDateStyleShowHourMinute:
            if (component==0) {
                title = _hourArray[row];
            }
            if (component==1) {
                title = _minuteArray[row];
            }
            break;
        case WSDateStyleShowYearMonth:
            if (component==0) {
                title = _yearArray[row];
            }
            if (component==1) {
                title = _monthArray[row];
            }
            break;
        default:
            title = @"";
            break;
    }
    
    customLabel.text = title;
    customLabel.textColor = [WSDatePickerConfig share].datePickerColor;
    return customLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (self.datePickerStyle) {
        case WSDateStyleShowYearMonthDayHourMinute:{
            
            if (component == 0) {
                yearIndex = row;
                
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
                
            }
        }
            break;
            
            
        case WSDateStyleShowYearMonthDay:{
            
            if (component == 0) {
                yearIndex = row;
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
        }
            break;
            
            
        case WSDateStyleShowMonthDayHourMinute:{
            
            
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 2) {
                hourIndex = row;
            }
            if (component == 3) {
                minuteIndex = row;
            }
            
            if (component == 0) {
                
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
            
        }
            break;
            
        case WSDateStyleShowMonthDay:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 0) {
                
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
        }
            break;
            
        case WSDateStyleShowHourMinute:{
            if (component == 0) {
                hourIndex = row;
            }
            if (component == 1) {
                minuteIndex = row;
            }
        }
            break;
        case WSDateStyleShowYearMonth:{
            if (component == 0) {
                yearIndex = row;
                self.showYearView.text =_yearArray[yearIndex];
            }
            if (component == 1) {
                monthIndex = row;
            }
        }
            break;
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex],_hourArray[hourIndex],_minuteArray[minuteIndex]];
    
    self.scrollToDate = [self dateWithdate:[NSDate yn_dateWithString:dateStr format:@"yyyy-MM-dd HH:mm"] formatter:_dateFormatter];
    
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }
    
    _startDate = self.scrollToDate;
}

- (NSDate *)dateWithdate:(NSDate *)date formatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = formatter;
    NSString *selfStr = [fmt stringFromDate:date];
    return [fmt dateFromString:selfStr];
}

- (void)yearChange:(NSInteger)row {
    
    monthIndex = row%12;
    
    //年份状态变化
    if (row-preRow <12 && row-preRow>0 && [_monthArray[monthIndex] integerValue] < [_monthArray[preRow%12] integerValue]) {
        yearIndex ++;
    } else if(preRow-row <12 && preRow-row > 0 && [_monthArray[monthIndex] integerValue] > [_monthArray[preRow%12] integerValue]) {
        yearIndex --;
    }else {
        NSInteger interval = (row-preRow)/12;
        yearIndex += interval;
    }
    
    self.showYearView.text = _yearArray[yearIndex];

    preRow = row;
}

#pragma mark - tools
//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month {
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num {
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated {
    if (!date) {
        date = [NSDate date];
    }
    
    [self DaysfromYear:date.yn_year andMonth:date.yn_month];
    
    yearIndex = date.yn_year-MINYEAR;
    monthIndex = date.yn_month-1;
    dayIndex = date.yn_day-1;
    hourIndex = date.yn_hour;
    minuteIndex = date.yn_minute;
    
    //循环滚动时需要用到
    preRow = (self.scrollToDate.yn_year-MINYEAR)*12+self.scrollToDate.yn_month-1;
    
    NSArray *indexArray;
    
    if (self.datePickerStyle == WSDateStyleShowYearMonthDayHourMinute)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == WSDateStyleShowYearMonthDay)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == WSDateStyleShowMonthDayHourMinute)
        indexArray = @[@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == WSDateStyleShowMonthDay)
        indexArray = @[@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == WSDateStyleShowHourMinute)
        indexArray = @[@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == WSDateStyleShowYearMonth)
        indexArray = @[@(yearIndex),@(monthIndex)];
    
    self.showYearView.text = _yearArray[yearIndex];
    
    [self.datePicker reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++) {
        if ((self.datePickerStyle == WSDateStyleShowMonthDayHourMinute || self.datePickerStyle == WSDateStyleShowMonthDay)&& i==0) {
            NSInteger mIndex = [indexArray[i] integerValue]+(12*(self.scrollToDate.yn_year - MINYEAR));
            [self.datePicker selectRow:mIndex inComponent:i animated:animated];
        } else {
            [self.datePicker selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if( [touch.view isDescendantOfView:self.buttomView]) {
        return NO;
    }
    return YES;
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    CGFloat y = 0.f;
    if (kIPhoneX) {
        y = kScreenHeight - PICKER_HEIGHT - 34;
    }else {
        y = kScreenHeight - PICKER_HEIGHT - 10;
    }
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.buttomView.frame = CGRectMake(10, y, kScreenWidth-20, PICKER_HEIGHT);
        weakSelf.backgroundColor = RGBA(0, 0, 0, 0.4);
    }];
}

- (void)dismiss {
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:.3 animations:^{
        weakSelf.buttomView.frame = CGRectMake(10, kScreenHeight, kScreenWidth-20, PICKER_HEIGHT);
        weakSelf.backgroundColor = RGBA(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [weakSelf.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [weakSelf removeFromSuperview];
    }];
}

- (void)doneButtonTap:(UIButton *)sender {
    _startDate = [self dateWithdate:self.scrollToDate formatter:_dateFormatter];
    self.doneBlock(_startDate);
    [self dismiss];
}

#pragma mark - getter / setter
-(UIPickerView *)datePicker {
    if (!_datePicker) {
        [self.showYearView layoutIfNeeded];
        _datePicker = [[UIPickerView alloc] initWithFrame:self.showYearView.bounds];
        _datePicker.showsSelectionIndicator = YES;
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
}

- (NSMutableArray *)setArray:(id)mutableArray {
    if (mutableArray){
        [mutableArray removeAllObjects];
    }else{
        mutableArray = [NSMutableArray array];
    }
    return mutableArray;
}

- (void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    if ([_scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        _scrollToDate = self.minLimitDate;
    }
    [self getNowDate:self.scrollToDate animated:NO];
}

@end
