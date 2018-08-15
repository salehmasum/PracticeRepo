//
//  Util.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AgeRangeModel.h"
typedef void(^CancelBlock)(void);
typedef void(^OKBlock)(void);


typedef enum : NSUInteger {
    StringFormatterYYYYMMDDHHMMSS,
    StringFormatterHHMMAP,
    StringFormatterWEEKMMDDHHMMAP,
} StringFormatter;

@interface Util : NSObject
//邮箱
+ (BOOL) validateEmail:(NSString *)email;
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobileNum;


+ (NSString *)dateFormatter:(StringFormatter)formatter date:(NSDate *)date;
//获取当地时间
+ (NSString *)getCurrentTime;
//将字符串转成NSDate类型
+ (NSDate *)dateFromString:(NSString *)dateString;
//获取几个月后的日期
+ (NSString *)GetAfterMonth:(NSInteger)count;
+ (NSString *)getTimeFromDate:(NSDate *)date;//YYYY-MM-dd
+ (NSInteger)getCurrentYear;

//根据date获取当天最后时刻
+ (NSDate *)maxTimeFromDate:(NSDate *)date;
//根据date获取当天最早时刻
+ (NSDate *)minTimeFromDate:(NSDate *)date;
//两个时间相差秒数
+ (NSTimeInterval)dateTimeDifferenceWithStartTime:(NSDate *)start endTime:(NSDate *)end;
+ (NSString *)yyyyMMddHHmmss:(NSDate *)date;


+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;

+ (NSDate *)stringFormatDate:(NSDate *)date time:(NSDate *)time;

+ (NSDateFormatter *)dateFormatter;

+ (NSString *)fileName;

+ (UIImage *)weekDayImageAtIndex:(NSInteger)index;//星期缩写
+ (NSString*)weekdayLongStringFromDate:(NSDate*)inputDate;

+ (NSString*)convertToJSONStringFrom:(NSDictionary *)dic;

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

//退出登录
+ (void)showAlertTitle:(NSString *)title message:(NSString *)message target:(id)target cancel:(CancelBlock)cancelBlock okBlock:(OKBlock)okBlock;
 

+ (void)saveUserName:(NSString *)name userIcon:(NSString *)icon;
//*******订单相关*****************************************

+ (UIImage *)bookingStateImage:(BookingState)state;
+ (NSString *)uuid;


//判断小孩是否符合年龄段
+ (BOOL)checkAge:(NSString *)age birthday:(NSString *)birthday withAgeRange:(AgeRangeModel *)ageRange;


//倒数8-5位*号代替
+ (NSString *)dealWithString:(NSString *)string;
@end
