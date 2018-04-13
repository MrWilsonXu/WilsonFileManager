//
//  YSDateTool.h
//  YSDateTool
//
//  Created by Wilson on 16/8/24.
//  Copyright © 2016年 WilsonXu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSDateTool : NSObject

// 日期是否是本周
+ (BOOL)isThisWeek:(NSString *)dateString;

// 日期是否是今天
+ (BOOL)isToday:(NSString *)dateString;

// 获取当天最后的时刻
+ (NSInteger)getCurrentDayLastTime;

// 根据一个时间戳字符串生成一个date 1970-1-1 00:00:00
+ (NSDate *)dateFromyyyyMMddHHmmss:(NSString *)string;

// 根据一个时间戳字符串生成一个date 1970-1-1
+ (NSDate *)dateFromyyyyMMdd:(NSString *)string;

// 根据一个date生成一个秒的时间戳
+ (NSString *)stringOfSecond;

// 根据秒生成date
+ (NSDate *)dateFromSecond:(NSString *)timeStamp;

// 把时间戳转成时分秒
+ (NSString *)stringOfHHmmss:(NSString *)dateString;

//把date（本周）转成时间字符串
+ (NSString *)stringOfEEEEHHmm;

/**
 *  将时间戳转换成 时间字符串
 *  @param timestamp 时间戳
 *  @param format YYYY-MM-dd hh:mm:ss
 *  @return 时间字符串
 */
+ (NSString *)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

/**
 *  将某个时间转化成 时间戳
 *  @param formatTime 时间字符串
 *  @param format 时间格式
 *  @return 时间戳
 */
+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

@end
