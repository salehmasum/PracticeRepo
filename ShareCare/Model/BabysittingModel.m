//
//  BabysittingModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/31.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BabysittingModel.h"

@implementation BabysittingModel

- (instancetype)init{
    if (self = [super init]) { 
        _availableTimeModel = [[WeekdayTimeModel alloc] init];
        _babyAgeRangeModel = [[AgeRangeModel alloc] init];
        _credentialsModel = [[CredentialsModel alloc] init];
        
        _availableTime = @"";
        _credentials = @"";
        _babyAgeRange = @"";
        
        _chargePerHour = @"";
        _headLine = @"";
        _photoNumPerDay = @"";
        _babyAgeClassify = @"";
        _aboutMe = @"";
        _photosPath = @[];  
        _isFavorite = NO;
        _userName = @"";
        
        _reviewDto = @{};
        _reviewDtoList = @[];
        _totalStarRating = @"";
        _update = @"";
        _reviewsCount = @"0";
        _addressLon = 0;
        _addressLat = 0;
        
        _thumbnail = @"";
        _babysittingStatus = @"4";
        return self;
    }
    return nil;
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
- (NSString *)address{
    if (_address == nil || [_address isEqual:[NSNull null]]) {
        return @"";
    }
    return _address;
}
- (NSString *)thumbnail{
    if (_thumbnail==nil || _thumbnail.length==0) {
        if (_photosPath.count) {
            return _photosPath.firstObject;
        }
    }
    return _thumbnail;
}

- (void)setAvailableTime:(NSString *)availableTime{
    _availableTime = availableTime;
    
    NSData *data = [availableTime dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tempDictQueryDiamond = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    _availableTimeModel = [WeekdayTimeModel modelWithDictionary:tempDictQueryDiamond];
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
  
