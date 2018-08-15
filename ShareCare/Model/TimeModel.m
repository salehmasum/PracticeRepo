//
//  TimeModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "TimeModel.h"

@implementation TimeModel

- (instancetype)init{    
    if (self = [super init]) { 
        _timeString = @"";
        _week = @"";
        _shortWeek = @"";
        _day = @"";
        _month = @"";
        _shortMonth = @"";
        _year = @"";
        _hour = @"";
        _minutes = @"";
        _seconds = @"";
        return self;    
    }    
    return nil;
} 


- (void)setTimeString:(NSString *)timeString{//2017-12-07 09:13:03
    if (timeString && timeString.length) {
        NSDateFormatter *dateFormatter = [Util dateFormatter];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
        NSDate *date= [dateFormatter dateFromString:timeString];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        
        [formatter setDateFormat:@"yyyy"];
        NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
        [formatter setDateFormat:@"MM"];
        NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
        [formatter setDateFormat:@"dd"];
        NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
        [formatter setDateFormat:@"HH"];
        NSInteger currentHH=[[formatter stringFromDate:date]integerValue];
        [formatter setDateFormat:@"mm"];
        NSInteger currentMM=[[formatter stringFromDate:date] integerValue];
        [formatter setDateFormat:@"ss"];
        NSInteger currentSS=[[formatter stringFromDate:date] integerValue];
        
        _week = [self weekdayStringFromDate:date];
        _shortWeek = [self weekdayLongStringFromDate:date];
        
        _day = [NSString stringWithFormat:@"%ld",currentDay];
        _year = [NSString stringWithFormat:@"%ld",currentYear];
        
        _month = [self monthStringFromIndex:currentMonth];
        _shortMonth = [self shortMonthStringFromIndex:currentMonth];
        
        _hour = [NSString stringWithFormat:@"%ld",currentHH];
        _minutes = [NSString stringWithFormat:@"%ld",currentMM];
        _seconds = [NSString stringWithFormat:@"%ld",currentSS];
        
        
    }
}

- (NSString *)monthStringFromIndex:(NSInteger)index{
    NSArray *array = @[[NSNull null],@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"Aguest",@"September",@"October",@"November",@"December"];
    return array[index];
}
- (NSString *)shortMonthStringFromIndex:(NSInteger)index{
    NSArray *array = @[[NSNull null],@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"June",@"July",@"Aug",@"Sept",@"Pct",@"Nov",@"Dec"];
    return array[index];
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sun", @"Mon", @"Tues", @"Wed", @"Thur", @"Fri", @"Sat", nil];
    
    return [self weekdayFromArr:weekdays date:inputDate];
}   
- (NSString*)weekdayLongStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil];
    
    return [self weekdayFromArr:weekdays date:inputDate];
} 

- (NSString *)weekdayFromArr:(NSArray *)arr date:(NSDate*)inputDate{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    //    
    //    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [arr objectAtIndex:theComponents.weekday];
}
@end

