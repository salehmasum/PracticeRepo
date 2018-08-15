//
//  EventModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/31.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "EventModel.h"

@implementation EventModel

- (instancetype)init{
    if (self = [super init]) { 
        _ageRange = @"";
        _eventDescription = @"";
        _listingHeadline = @"";
        _maximumAttendees = @"";
       // _priceAdmission = [[EventPriceModel alloc] init];
        _address = @"";
        _whereToMeet = @"";
        _imagePath = @[];
        _adult = @"0";
        _child = @"0";
        _concession = @"0";
        _isFavorite = NO;
        _userName = @"";
        
        _reviewDto = @{};
        _reviewDtoList = @[];
        _totalStarRating = @"";
        _remainingPlace = @"";
        
        _startDate = @"";
        _endDate = @"";
        
        _startDateStr = @"";
        _endDateStr = @"";
        
        _whereToMeetLat = 0;
        _whereToMeetLon = 0;
        
        _addressLon = 0;
        _addressLat = 0;
        _reviewsCount = @"0";
        _thumbnail = @"";
        _eventStatus = @"4";
        
        _addressDetail =@"";
        _whereToMeetDetail =@"";
        return self;
    }
    return nil;
} 


- (NSString *)address{
    if ([_address containsString:ADDRESS_SEPARATED_STRING]) {
        return [_address componentsSeparatedByString:ADDRESS_SEPARATED_STRING].lastObject;
    }
    return _address;
}
- (NSString *)whereToMeet{
    if ([_whereToMeet containsString:ADDRESS_SEPARATED_STRING]) {
        return [_whereToMeet componentsSeparatedByString:ADDRESS_SEPARATED_STRING].lastObject;
    }
    return _whereToMeet;
}


- (NSString *)thumbnail{
    if (_thumbnail==nil || _thumbnail.length==0) {
        if (_imagePath.count) {
            return _imagePath.firstObject;
        }
    }
    return _thumbnail;
}

//"Fri Nov 10 • 10:24am"
- (void)setStartDate:(NSString *)startDate{
    if (startDate.length==19 && [startDate containsString:@"T"] && ![startDate containsString:@" • "]) {
        
        NSString *string = [startDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSDateFormatter *dateFormatter = [Util dateFormatter] ;
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
        NSDate *date=[dateFormatter dateFromString:string];
        
        _startDateStr = [self stringWithDate:date];
    }else{
        _startDateStr = startDate;
    }
    
    _startDate =startDate;
}
- (void)setEndDate:(NSString *)endDate{
    if (endDate.length==19 && [endDate containsString:@"T"] && ![endDate containsString:@" • "]) {
        
        NSString *string = [endDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSDateFormatter *dateFormatter = [Util dateFormatter] ;
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
        NSDate *date=[dateFormatter dateFromString:string];
        
        _endDateStr = [self stringWithDate:date];
    }else{
        _endDateStr = endDate;
    }
    
    _endDate =endDate;
}

//- (void)esetDateString:(NSString *)string{
//    NSArray *array = [string componentsSeparatedByString:@" • "];
//    NSString *dateString = array[0];
//    NSString *timeString = array[1];
//    NSArray *dates = [dateString componentsSeparatedByString:@" "];
//    NSString *month = dates[1];
//    NSString *day = dates[2];
//    NSString *week = dates[0];
//    
//    timeString = [timeString stringByReplacingOccurrencesOfString:@"am" withString:@":00"];
//    timeString = [timeString stringByReplacingOccurrencesOfString:@"pm" withString:@":00"];
//    
//    
//}

- (NSString *)stringWithDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [Util dateFormatter];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *dayStr = [dateFormatter stringFromDate:date];
    
    dayStr = [[dayStr componentsSeparatedByString:@", "] firstObject];
    
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *timeStr = [dateFormatter stringFromDate:date];
    
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];            
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    
    
    NSDateFormatter *formatter = [Util dateFormatter];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    
    
    
    NSString *weekDay = [Util weekdayLongStringFromDate:date];
    
    return [NSString stringWithFormat:@"%@ %ld/%02ld/%02ld • %@",weekDay,currentYear,currentMonth,currentDay,timeStr];
    return [NSString stringWithFormat:@"%@ %@ • %@",weekDay,dayStr,timeStr];
}





- (void)setReviewDto:(NSDictionary *)reviewDto{
    if ([[reviewDto allKeys] containsObject:@"reviewDtoList"]) {
        _reviewDtoList = reviewDto[@"reviewDtoList"];
    }
    if ([[reviewDto allKeys] containsObject:@"totalStarRating"]) {
        _totalStarRating = [NSString stringWithFormat:@"%f",[reviewDto[@"totalStarRating"] floatValue]/StarRatingScale];
    }
    _reviewsCount = reviewDto[@"reviewsCount"];
    _reviewDto = reviewDto;
}
- (void)setImagePathList:(NSArray *)imagePathList{
    if ([imagePathList isKindOfClass:[NSArray class]]) {
        NSMutableArray *photos = [NSMutableArray array]; 
        for (NSString *path in imagePathList) {
            [photos addObject:path];
        }
        _imagePath =[photos copy];
    }
    
} 
- (void)seteventDescription:(NSString *)eventDescription{
    if (eventDescription) {
        _eventDescription = eventDescription;
    }
}

- (void)setMaximumAttendees:(NSString *)maximumAttendees{
    _maximumAttendees = maximumAttendees;
    _remainingPlace = maximumAttendees;
}

//- (NSString *)child{
//    if ([_child isEqualToString:@"FREE"]) {
//        return @"FREE for kids";
//    }
//    return _child;
//}
- (void)setEnventDescription:(NSString *)enventDescription{
    _enventDescription = enventDescription;
    _eventDescription = enventDescription;
}
- (void)setChild:(NSString *)child{
    if ([child containsString:@"$"]) {
        _child = [child stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }else if ([child containsString:@"FREE"]) {
        _child = @"0";
    }else{
        _child = child;
    }
}
- (void)setAdult:(NSString *)adult{
    if ([adult containsString:@"$"]) {
        _adult = [adult stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }else if ([adult containsString:@"FREE"]) {
        _adult = @"0";
    }else{
        _adult = adult;
    }
}
- (void)setConcession:(NSString *)concession{
    if ([concession containsString:@"$"]) {
        _concession = [concession stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }else if ([concession containsString:@"FREE"]) {
        _concession = @"0";
    }else{
        _concession = concession;
    }
}
@end
@implementation EventPriceModel
- (instancetype)init{
    if (self = [super init]) {  
        _adult = @"";
        _child = @"";
        _concession = @"";
        return self;
    }
    return nil;
}
- (void)setChild:(NSString *)child{
    if ([child containsString:@"$"]) {
        _child = [child stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }else if ([child containsString:@"FREE"]) {
        _child = @"0";
    }else{
        _child = child;
    }
}
- (void)setAdult:(NSString *)adult{
    if ([adult containsString:@"$"]) {
        _adult = [adult stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }else if ([adult containsString:@"FREE"]) {
        _adult = @"0";
    }else{
        _adult = adult;
    }
}
- (void)setConcession:(NSString *)concession{
    if ([concession containsString:@"$"]) {
        _concession = [concession stringByReplacingOccurrencesOfString:@"$" withString:@""];
    }else if ([concession containsString:@"FREE"]) {
        _concession = @"0";
    }else{
        _concession = concession;
    }
}

@end
