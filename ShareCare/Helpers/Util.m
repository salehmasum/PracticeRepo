//
//  Util.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "Util.h"

@implementation Util
#pragma mark - 正则表达式
//邮箱
//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    
    NSString *emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
} 
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,177,180,189
     */
    NSString * MOBILE =@"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM =@"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU =@"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT =@"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
 
//获取当地时间
+ (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [Util dateFormatter];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
+ (NSString *)getTimeFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [Util dateFormatter];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}
//将字符串转成NSDate类型
+ (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [Util dateFormatter];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
//获取几个月后的日期
+ (NSString *)GetAfterMonth:(NSInteger)count {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    [components setMonth:([components month]+count)];
    components.day = 1;
    NSDate *newDate = [gregorian dateFromComponents:components];
    //两个月后的1号往前推1天，即为下个月最后一天  
    newDate = [newDate dateByAddingTimeInterval:-1];
    NSDateFormatter *dateday = [Util dateFormatter];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:newDate];
}
 
+ (NSInteger)getCurrentYear{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    return components.year;
}

+ (NSString *)fileName{
    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
    // 要解决此问题，
    // 可以在上传时使用当前的系统事件作为文件名
    NSDateFormatter *formatter = [Util dateFormatter];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *name = [NSString stringWithFormat:@"%@%u.png", str,arc4random()%900+100];
    NSLog(@"file name:%@",name);
    return name;
}
+ (UIImage *)weekDayImageAtIndex:(NSInteger)index{
    switch (index) {
        case 1:
            return kIMAGE_WEEK_MONDAY;
            break;
        case 2:
            return kIMAGE_WEEK_TUESDAY;
            break;
            
        case 3:
            return kIMAGE_WEEK_WEDNESDAY;
            break;
            
        case 4:
            return kIMAGE_WEEK_THURSDAY;
            break;
            
        case 5:
            return kIMAGE_WEEK_FRIDAY;
            break;
            
        case 6:
            return kIMAGE_WEEK_SATURDAY;
            break;
            
        case 7:
            return kIMAGE_WEEK_SUNDAY;
            break; 
        default:
            break;
    }
    return nil;
}


+ (NSString*)convertToJSONStringFrom:(NSDictionary *)dic
{
    
 //   return dic;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData) 
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}

+ (NSDateFormatter *)dateFormatter{
    NSDateFormatter *format = [[NSDateFormatter alloc] init] ;
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
//    NSLog(@"language:%@", [NSLocale preferredLanguages]);
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
//    [format setLocale:locale];
//    NSLog(@"%@",[locale objectForKey:NSLocaleLanguageCode]);
    
    return format;
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sun", @"Mon", @"Tues", @"Wed", @"Thur", @"Fri", @"Sat", nil];
    
    return [self weekdayFromArr:weekdays date:inputDate];
}   
+ (NSString*)weekdayLongStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    
    return [self weekdayFromArr:weekdays date:inputDate];
} 

+ (NSString *)weekdayFromArr:(NSArray *)arr date:(NSDate*)inputDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    //    
    //    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [arr objectAtIndex:theComponents.weekday];
}


//+ (NSString *)dateFormatter:(StringFormatter)formatter date:(NSDate *)date{
//    
//}

+ (NSString *)yyyyMMddHHmmss:(NSDate *)date{
    return [self yyyyMMddHHmmss:date seperateStr:@"T"];
}
+ (NSString *)yyyyMMddHHmmss:(NSDate *)date seperateStr:(NSString *)string{
    NSDateFormatter *dateFormatter = [Util dateFormatter] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *str = [dateFormatter stringFromDate:date];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:string];
    return str;
}

+ (NSDate *)stringFormatDate:(NSDate *)date time:(NSDate *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    
    [formatter setDateFormat:@"HH"];
    NSInteger currentHH=[[formatter stringFromDate:time]integerValue];
    [formatter setDateFormat:@"mm"];
    NSInteger currentMM=[[formatter stringFromDate:time] integerValue];
    [formatter setDateFormat:@"ss"];
    NSInteger currentSS=[[formatter stringFromDate:time] integerValue];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld %02ld:%02ld:%02ld",currentYear,currentMonth,currentDay,currentHH,currentMM,currentSS];
    NSDateFormatter *dateFormatter = [Util dateFormatter] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *mydate=[dateFormatter dateFromString:dateString];
    return mydate;
}

+ (NSDate *)minTimeFromDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld 00:00:00",currentYear,currentMonth,currentDay];
    NSDateFormatter *dateFormatter = [Util dateFormatter] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *mydate=[dateFormatter dateFromString:dateString];
    return [mydate laterDate:[NSDate date]];
}

+ (NSDate *)maxTimeFromDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    
    
    NSString *dateString = [NSString stringWithFormat:@"%ld-%02ld-%02ld 23:59:59",currentYear,currentMonth,currentDay];
    NSDateFormatter *dateFormatter = [Util dateFormatter] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *mydate=[dateFormatter dateFromString:dateString];
    return mydate;
}
+ (NSTimeInterval)dateTimeDifferenceWithStartTime:(NSDate *)start endTime:(NSDate *)end{
    return 0;
}


+ (void)showAlertTitle:(NSString *)title message:(NSString *)message target:(id)target cancel:(CancelBlock)cancelBlock okBlock:(OKBlock)okBlock{
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:CustomLocalizedString(@"Are you sure you want to Log Out of EleCare?", @"setting") 
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Go Back", @"setting") 
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                               cancelBlock();
                                                           }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Log Out", @"setting") 
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                           okBlock();
                                                       }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [target presentViewController:alertController animated:YES completion:nil];
}

+ (UIImage *)bookingStateImage:(BookingState)state{
    switch (state) {
        case BookingStatePENDING:
            return BookingStateIMAGE_PENDING;
            break;
        case BookingStateCONFIRMED:
            return BookingStateIMAGE_CONFIRMED;
            break;
        case BookingStateDECLINED:
        case BookingStateTransactionFailed:
            return BookingStateIMAGE_DECLINED;
            break;
        case BookingStateRUNNING:
            return BookingStateIMAGE_RUNNING;
            break;
        case BookingStateINREVIEW:
            return BookingStateIMAGE_INREVIEW;
            break;
        case BookingStateCURRENTLY_NOT_RUNNING:
            return BookingStateIMAGE_CURRENTLY_NOT_RUNNING;
            break;
        case BookingStateEXPIRED:
            return BookingStateIMAGE_EXPIRED;
            break;
        case BookingStateCOMPLETED:
            return BookingStateIMAGE_COMPLETED;
            break;
        case BookingStateCANCEL:
            return BookingStateIMAGE_CANCELED;
            break;
            
        default:
            break;
    }
    return BookingStateIMAGE_PENDING;
}

+ (NSString *)uuid{
    NSString *string= kBraintreeCustomerIdentifier;
    if (string.length > 0) {
        return string;
    }else{
        string = [[NSUUID UUID] UUIDString];
        USERDEFAULT_SET_BraintreeCustimerID(string);
        return string;
    }
}
+ (NSString *)distanceTimeWithBeforeTime:(double)beTime  
{  
    if (beTime>1516934071000) {
        beTime = beTime/1000;
    }
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];  
    double distanceTime = now - beTime;  
    NSString * distanceStr;  
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];  
    NSDateFormatter * df = [[NSDateFormatter alloc]init];  
    [df setDateFormat:@"HH:mm"];  
    NSString * timeStr = [df stringFromDate:beDate];  
    
    [df setDateFormat:@"dd"];  
    NSString * nowDay = [df stringFromDate:[NSDate date]];  
    NSString * lastDay = [df stringFromDate:beDate];  
    
//    if (distanceTime < 60) {//小于一分钟  
//        distanceStr = @"刚刚";  
//    }else if (distanceTime <60*60) {//时间小于一个小时  
//        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];  
//    }else 
        
    if(distanceTime <24*60*60 && [nowDay integerValue] == [lastDay integerValue]){//时间小于一天
        distanceStr = [NSString stringWithFormat:@"%@",timeStr];  
    }else if(distanceTime<24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){  
        
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {  
            distanceStr = [NSString stringWithFormat:@"Yesterday %@",timeStr];  
        }  
        else{  
            [df setDateFormat:@"MM-dd HH:mm"];  
            distanceStr = [df stringFromDate:beDate];  
        }  
        
    }  
    else if(distanceTime <24*60*60*365){  
        [df setDateFormat:@"MM-dd HH:mm"];  
        distanceStr = [df stringFromDate:beDate];  
    }  
    else{  
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];  
        distanceStr = [df stringFromDate:beDate];  
    }  
    return distanceStr;  
}  

+ (void)saveUserName:(NSString *)name userIcon:(NSString *)icon{
    NSString * fullName =  [NSString stringWithFormat:@"%@",name];
    NSString * userIcon =  [NSString stringWithFormat:@"%@",icon]; 
    if (fullName.length!=0) { 
        USERDEFAULT_SET(@"userName", fullName); 
    }
    
    if (userIcon.length!=0) { 
        USERDEFAULT_SET(@"userIcon", userIcon);
    }
}


+ (BOOL)checkAge:(NSString *)age birthday:(NSString *)birthday withAgeRange:(AgeRangeModel *)ageRange{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *birthdayDate = [dateFormatter dateFromString:birthday];
    
    BOOL result1 = NO;
    BOOL result2 = NO;
    BOOL result3 = NO;
    BOOL result4 = NO;
    BOOL result5 = NO;
    NSTimeInterval time = 365 * 24 * 60 * 60;//一年的秒数
    if (ageRange.age0_1) {
        NSDate * lastYear = [[NSDate date] dateByAddingTimeInterval:-time];
        result1 = [self compareDate:lastYear anotherDate:birthdayDate];
    }
    if (ageRange.age1_2) {
        NSDate * lastYear1 = [[NSDate date] dateByAddingTimeInterval:-time];
        NSDate * lastYear2 = [[NSDate date] dateByAddingTimeInterval:-time*2];
        if ([self compareDate:lastYear2 anotherDate:birthdayDate] &&
            [self compareDate:birthdayDate anotherDate:lastYear1]) {
            result2 = YES;
        } 
        
    }
    if (ageRange.age2_3) {
        NSDate * lastYear1 = [[NSDate date] dateByAddingTimeInterval:-time*2];
        NSDate * lastYear2 = [[NSDate date] dateByAddingTimeInterval:-time*3];
        if ([self compareDate:lastYear2 anotherDate:birthdayDate] &&
            [self compareDate:birthdayDate anotherDate:lastYear1]) {
            result3 = YES;
        } 
    }
    if (ageRange.age3_5) {
        NSDate * lastYear1 = [[NSDate date] dateByAddingTimeInterval:-time*3];
        NSDate * lastYear2 = [[NSDate date] dateByAddingTimeInterval:-time*5];
        if ([self compareDate:lastYear2 anotherDate:birthdayDate] &&
            [self compareDate:birthdayDate anotherDate:lastYear1]) {
            result4 = YES;
        } 
        
    }
    if (ageRange.age5) {
        NSDate * lastYear = [[NSDate date] dateByAddingTimeInterval:-time*5];
        result5 = [self compareDate:birthdayDate anotherDate:lastYear];
    }
    
    
    
    return result1 || result2 || result3 || result4 || result5;
}
/****
 ios比较日期大小默认会比较到秒
 ****/
+(BOOL)compareDate:(NSDate *)oneDay anotherDate:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return NO;
    }
    else if (result ==NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return YES;
    }
    //NSLog(@"Both dates are the same");
    return NO;
    
}


+ (NSString *)dealWithString:(NSString *)string
{
    if (string.length<=8) {
        return string;
    }
    
    NSString *tempStr= [string substringWithRange:NSMakeRange(string.length-8, 4)];
    
    return [string stringByReplacingOccurrencesOfString:tempStr withString:@" **** "];;
    
    NSString *doneTitle = @"";
    int count = 0;
    for (int i = 0; i < string.length; i++) { 
        count++;
        doneTitle = [doneTitle stringByAppendingString:[string substringWithRange:NSMakeRange(i, 1)]];
        if (count == 4 && i<8) {
            doneTitle = [NSString stringWithFormat:@"%@ ", doneTitle];
            count = 0;
        }else{
            doneTitle = [NSString stringWithFormat:@"%@", doneTitle];
        }
        
    }
    NSLog(@"%@", doneTitle); 
    
    doneTitle = [doneTitle stringByReplacingOccurrencesOfString:tempStr withString:@" **** "];
    
     
    return doneTitle;
}

@end
