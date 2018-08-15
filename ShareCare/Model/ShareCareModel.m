//
//  ShareCareModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/31.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ShareCareModel.h"

@implementation ShareCareModel
- (instancetype)init{
    if (self = [super init]) {   
        _address = @"";
        _availableTime = @"";
        _childrenNums = @"";
        _headline = @"";
        _moneyPerDay = @"";
        _photosPerDay = @"";
        _shareCareContent = @"";
         _photosPath = @[];
        _isFavorite = NO;
        _userName = @"";
        
        _reviewDto = @{};
        _reviewDtoList = @[];
        _totalStarRating = @"";
        
        _addressLon = 0;
        _addressLat = 0;
        _reviewsCount = @"0";
        _babyAgeRangeModel = [[AgeRangeModel alloc] init];
        _credentialsModel = [[CredentialsModel alloc] init];
        _credentials = @"";
        _babyAgeRange = @"";
        _thumbnail = @"";
        _joinChildrens = @[];
        _shareCareStatus = @"4";
        _addressDetail =@"";
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

- (NSString *)availableTimeEN{ 
    NSArray *times = [_availableTime componentsSeparatedByString:@","];
    NSDateFormatter *dateFormatter = [Util dateFormatter];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSMutableSet *weekDays = [NSMutableSet set];
    for (NSString *time in times) {
        NSString *string = [NSString stringWithFormat:@"%@s",[Util weekdayLongStringFromDate:[dateFormatter dateFromString:time]]];
        if ([string isEqualToString:@"Sundays"] || [string isEqualToString:@"Saturdays"]) {
            string = @"Weekends";
        }
        [weekDays addObject:string];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *weekdays_EN = @[@"Mondays", @"Tuesdays", @"Wednesdays", @"Thursdays", @"Fridays", @"Weekends"];
    for (NSInteger index=0; index<weekdays_EN.count; index++) {
        if ([weekDays containsObject:weekdays_EN[index]]) {
            [array addObject:weekdays_EN[index]];
        }
    }
    if (array.count>1) {
        NSString *lastObject  = array.lastObject;
        [array removeLastObject];
        NSString *result = [array componentsJoinedByString:@","];
        result = [NSString stringWithFormat:@"%@ and %@",result,lastObject];
        return [NSString stringWithFormat:@"%@ • 08:30am-06:00pm",result];
    }
    
    
    return [NSString stringWithFormat:@"%@ • 08:30am-06:00pm",array.firstObject];
}

- (NSString *)thumbnail{
    if (_thumbnail==nil || _thumbnail.length==0) {
        if (_photosPath.count) {
            return _photosPath.firstObject;
        }
    }
    return _thumbnail;
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

- (void)setPhotosPath:(NSArray *)photosPath{
    if ([photosPath isKindOfClass:[NSArray class]]) {
        NSMutableArray *photos = [NSMutableArray array]; 
        for (NSString *path in photosPath) {
            [photos addObject:path];
        }
        _photosPath =[photos copy];
    } 
}
- (void)setBabyAgeRange:(NSString *)babyAgeRange{
    _babyAgeRange = babyAgeRange;
    
    NSData *data = [babyAgeRange dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tempDictQueryDiamond = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    _babyAgeRangeModel = [AgeRangeModel modelWithDictionary:tempDictQueryDiamond];
}
- (void)setCredentials:(NSString *)credentials{
    _credentials = credentials;
    
    NSData *data = [credentials dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tempDictQueryDiamond = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    _credentialsModel = [CredentialsModel modelWithDictionary:tempDictQueryDiamond];
    
}
@end
