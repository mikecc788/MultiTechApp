//
//  NSDate+LFS.h
//  TestFeel
//
//  Created by app on 2023/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, NSDateFormaterMode) {
    /** 日期格式：农历*/
    NSDateFormaterModeLunar,
    /** 日期格式：yyyy-MM-dd HH:mm:ss（标准格式）*/
    NSDateFormaterModeStandard,
    /** 日期格式：yyyy-MM-dd hh:mm:ss（12小时制）*/
    NSDateFormaterModeStandard12,
    /** 日期格式：yyyy-MM-dd HH:mm*/
    NSDateFormaterModeDemotion,
    /** 日期格式：yyyy-MM-dd hh:mm（12小时制）*/
    NSDateFormaterModeDemotion12,
    /** 日期格式：yyyy-MM-dd*/
    NSDateFormaterModeDayDefault,
    /** 日期格式：yyyy年MM月dd日*/
    NSDateFormaterModeDayAnother,
    /** 日期格式：HH:mm:ss*/
    NSDateFormaterModeTimeStandard,
    /** 日期格式：hh:mm:ss（12小时制）*/
    NSDateFormaterModeTimeStandard12,
    /** 日期格式：HH:mm*/
    NSDateFormaterModeTimeDemotion,
    /** 日期格式：hh:mm（12小时制）*/
    NSDateFormaterModeTimeDemotion12
};
@interface NSDateFormatter (LFS)

+ (NSDateFormatter *)dateFormaterWithMode:(NSDateFormaterMode)formaterMode;

@end

@interface NSDate (LFS)
-(BOOL)isToday;
- (BOOL)isLastWeek;
/// NSDate -> 格式化NSDate
/// @param formaterMode 日期格式
-(NSDate *)dateToDateWithFormaterMode:(NSDateFormaterMode)formaterMode;
@end

NS_ASSUME_NONNULL_END
