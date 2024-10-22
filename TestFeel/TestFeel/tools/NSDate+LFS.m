//
//  NSDate+LFS.m
//  TestFeel
//
//  Created by app on 2023/4/8.
//

#import "NSDate+LFS.h"

@implementation NSDateFormatter (LFS)

+ (NSDateFormatter *)dateFormaterWithMode:(NSDateFormaterMode)formaterMode {
    NSString *stringFormat = @"";
    
    switch (formaterMode) {
        case NSDateFormaterModeLunar:
            
            break;
        case NSDateFormaterModeStandard:
            stringFormat = @"yyyy-MM-dd HH:mm:ss";
            break;
        case NSDateFormaterModeStandard12:
            stringFormat = @"yyyy-MM-dd hh:mm:ss";
            break;
        case NSDateFormaterModeDemotion:
            stringFormat = @"yyyy-MM-dd HH:mm";
            break;
        case NSDateFormaterModeDemotion12:
            stringFormat = @"yyyy-MM-dd hh:mm";
            break;
        case NSDateFormaterModeDayDefault:
            stringFormat = @"yyyy-MM-dd";
            break;
        case NSDateFormaterModeDayAnother:
            stringFormat = @"yyyy年MM月dd日";
            break;
        case NSDateFormaterModeTimeStandard:
            stringFormat = @"HH:mm:ss";
            break;
        case NSDateFormaterModeTimeStandard12:
            stringFormat = @"hh:mm:ss";
            break;
        case NSDateFormaterModeTimeDemotion:
            stringFormat = @"HH:mm";
            break;
        case NSDateFormaterModeTimeDemotion12:
            stringFormat = @"hh:mm";
            break;
        default:
            stringFormat = @"yyyy-MM-dd HH:mm:ss";
            break;
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:stringFormat];
    return dateFormat;
}

@end

@implementation NSDate (LFS)
#pragma mark - 判断是否为今天
-(BOOL)isToday{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
//    return (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}
#pragma mark - 判断是否为昨天
- (BOOL)isLastWeek{
    
    /*
     * 将日期格式化为 年-月-日 类型
     * 计算格式化后的时间差是否为一天
     */
    
    //获取格式化当前日期
    NSDate *nowDate = [NSDate dateToDate:[NSDate date] formaterMode:NSDateFormaterModeDemotion];

    //获取格式化目标日期
    NSDate *selfDate = [self dateToDateWithFormaterMode:NSDateFormaterModeDemotion];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获得nowDate和selfDate的差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
//    NSLog(@"day=%ld",cmps.day);
    return cmps.day < 8;
}
- (BOOL)isLastMonth{
    
    /*
     * 将日期格式化为 年-月-日 类型
     * 计算格式化后的时间差是否为一天
     */
    
    //获取格式化当前日期
    NSDate *nowDate = [NSDate dateToDate:[NSDate date] formaterMode:NSDateFormaterModeDemotion];

    //获取格式化目标日期
    NSDate *selfDate = [self dateToDateWithFormaterMode:NSDateFormaterModeDemotion];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获得nowDate和selfDate的差距
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
//    NSLog(@"day=%ld",cmps.day);
    return cmps.day < 30;
}
#pragma mark - NSDate -> 格式化NSDate
+(NSDate *)dateToDate:(NSDate *)date formaterMode:(NSDateFormaterMode)formaterMode{
    
    NSDateFormatter *formater = [NSDateFormatter dateFormaterWithMode:formaterMode];
    NSString *selfStr = [formater stringFromDate:date];
    return [formater dateFromString:selfStr];
}
/// NSDate -> 格式化NSDate
/// @param formaterMode 日期格式
-(NSDate *)dateToDateWithFormaterMode:(NSDateFormaterMode)formaterMode{
    NSDateFormatter *formater = [NSDateFormatter dateFormaterWithMode:formaterMode];
    NSString *selfStr = [formater stringFromDate:self];
    return [formater dateFromString:selfStr];
}
@end
