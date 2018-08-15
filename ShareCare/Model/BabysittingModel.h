//
//  BabysittingModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/31.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"
#import "WeekdayTimeModel.h" 
#import "CredentialsModel.h"
#import "AgeRangeModel.h"
@interface BabysittingModel : BaseModel

//@property (nonatomic, copy) NSString *availableTime;
//@property (nonatomic, copy) NSString *babyAgeRange;
//@property (nonatomic, copy) NSString *credentials;

@property (nonatomic, strong) WeekdayTimeModel *availableTimeModel;
@property (nonatomic, strong) AgeRangeModel *babyAgeRangeModel;
@property (nonatomic, strong) CredentialsModel *credentialsModel; 

@property (nonatomic, copy) NSString  *accountId;
@property (nonatomic, copy) NSString *availableTime;
@property (nonatomic, copy) NSString *babyAgeRange;
@property (nonatomic, copy) NSString *credentials;
@property (nonatomic, copy) NSString *chargePerHour;
@property (nonatomic, copy) NSString *headLine;
@property (nonatomic, copy) NSString *aboutMe;
@property (nonatomic, copy) NSString *photoNumPerDay;
@property (nonatomic, copy) NSString *babyAgeClassify;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, strong) NSArray *photosPath;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, copy) NSString  *userName;
@property (nonatomic, copy) NSString  *update;
@property (nonatomic, copy) NSString  *babysittingStatus;

@property (nonatomic, copy) NSDictionary  *reviewDto;
@property (nonatomic, strong) NSArray  *reviewDtoList;
@property (nonatomic, copy) NSString  *totalStarRating;
@property (nonatomic, copy) NSString  *reviewsCount;
@property (nonatomic, copy) NSString  *thumbnail;//缩略图


@property (assign, nonatomic) double addressLon;
@property (assign, nonatomic) double addressLat;
@property (nonatomic, copy) NSString  *address; 
@property (nonatomic, copy) NSString  *addressDetail; 


@end 

