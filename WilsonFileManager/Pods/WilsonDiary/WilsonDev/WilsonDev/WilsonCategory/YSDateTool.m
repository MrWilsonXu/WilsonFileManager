//
//  YSDateTool.m
//  YSDateTool
//
//  Created by Wilson on 16/8/24.
//  Copyright © 2016年 WilsonXu. All rights reserved.
//

#import "YSDateTool.h"

@implementation YSDateTool

// 判断日期是否是本周
+ (BOOL)isThisWeek:(NSString *)dateString{
    // 需要设置三个参数
    NSDate *start;
    NSTimeInterval extends;
    
    NSCalendar *cal = [NSCalendar autoupdatingCurrentCalendar];
    //一周的第一天设置为周一
    [cal setFirstWeekday:2];
    
    // iOS8 后不用 NSWeekCalendarUnit
    BOOL success = [cal rangeOfUnit:NSCalendarUnitWeekOfYear startDate:&start interval: &extends forDate:[NSDate dateWithTimeIntervalSince1970:[dateString longLongValue]]];
    
    if(!success) {
        return NO;
    }
       
    NSTimeInterval dateInSecs = [[NSDate dateWithTimeIntervalSince1970:[dateString longLongValue]] timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs >= dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    } else {
        return NO;
    }
}

// 日期是否是今天
+ (BOOL)isToday:(NSString *)dateString {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    
    // 1. 获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2. 获得传来的时间戳的年月日
    NSDateComponents *selfCmps = [calendar components :unit fromDate:[NSDate dateWithTimeIntervalSince1970:[dateString longLongValue]]];
    
    //直接分别用当前对象和现在的时间进行比较，比较的属性就是年月日
    return (selfCmps. year == nowCmps. year ) && (selfCmps. month == nowCmps. month ) &&(selfCmps. day == nowCmps. day );
}

// 获取当天最后时间
+ (NSInteger)getCurrentDayLastTime {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yy-MM-dd HH-mm-ss"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateStr = [NSString stringWithFormat:@"%@",currentDate];
    NSString *lastDateString = [NSString stringWithFormat:@"%@ 23-59-59",[currentDateStr substringToIndex:10]];
    NSDate *setDate = [dateformatter dateFromString:lastDateString];
    NSInteger integerTime = [setDate timeIntervalSince1970];
    NSLog(@"当天最后的时间戳:%ld",(long)integerTime);
    
    return integerTime;
}

// 根据一个时间戳字符串生成一个date
+ (NSDate *)dateFromyyyyMMddHHmmss:(NSString *)string {
    if (!string.length) {
        string = @"1970-01-01 00:00:00";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yy-MM-dd HH-mm-ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

// 根据一个时间戳字符串生成一个date
+ (NSDate *)dateFromyyyyMMdd:(NSString *)string
{
    if (!string.length) {
        string = @"1970-01-01";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:string];
    return date;
}

// 根据一个date生成一个秒的时间戳
+ (NSString *)stringOfSecond {
    NSDate *date = [NSDate date];
    NSInteger second = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%ld",(long)second];
}

// 根据秒生成date
+ (NSDate *)dateFromSecond:(NSString *)timeStamp {
    if (timeStamp.length == 0) {
        timeStamp = @"0";
    }
    return [NSDate dateWithTimeIntervalSince1970:[timeStamp longLongValue]];
}

// 把时间戳转成时-分-秒
+ (NSString *)stringOfHHmmss:(NSString *)dateString {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH-mm-ss";
    NSString *tempstr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[dateString longLongValue]]];
    return tempstr;
}

// 把date转成汉子字符串
+ (NSString *)stringOfEEEEHHmm {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //setLocale 方法将其转为中文的日期表达
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    dateFormatter.dateFormat = @"EEEE HH:mm";
    NSString *tempstr = [dateFormatter stringFromDate:[NSDate date]];
    return tempstr;
}

// 世界时间转换为本地时间
- (NSDate *)worldDateToLocalDate:(NSDate *)date {
    //获取本地时区(中国时区)
    NSTimeZone* localTimeZone = [NSTimeZone localTimeZone];
    
    //计算世界时间与本地时区的时间偏差值
    NSInteger offset = [localTimeZone secondsFromGMTForDate:date];
    
    //世界时间＋偏差值 得出中国区时间
    NSDate *localDate = [date dateByAddingTimeInterval:offset];
    
    return localDate;
}

/**
 *  将时间戳转换成 时间字符串
 *  @param timestamp 时间戳
 *  @param format YYYY-MM-dd hh:mm:ss
 *  @return 时间字符串
 */
+ (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    // @"YYYY-MM-dd hh:mm:ss" 设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:format];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

/**
 *  将某个时间转化成 时间戳
 *  @param formatTime 时间字符串
 *  @param format 时间格式
 *  @return 时间戳
 */
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    NSDate* date = [formatter dateFromString:formatTime];
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    return timeSp;
}




@end
