//
//  EventModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/31.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"

@class EventPriceModel;
@interface EventModel : BaseModel



@property (assign, nonatomic) double whereToMeetLat;
@property (assign, nonatomic) double whereToMeetLon;
@property (assign, nonatomic) double addressLon;
@property (assign, nonatomic) double addressLat;

@property (nonatomic, copy) NSString  *accountId;
@property (nonatomic, copy) NSString *ageRange;
@property (nonatomic, copy) NSString *eventDescription;
@property (nonatomic, copy) NSString *enventDescription;
@property (nonatomic, copy) NSString *listingHeadline;
@property (nonatomic, copy) NSString *maximumAttendees;
@property (nonatomic, copy) NSString *remainingPlace;
//@property (nonatomic, strong) EventPriceModel *priceAdmission; 
@property (nonatomic, copy) NSString *adult;
@property (nonatomic, copy) NSString *child;
@property (nonatomic, copy) NSString *concession;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *whereToMeet;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, strong) NSArray *imagePathList;
@property (nonatomic, strong) NSArray *imagePath;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, copy) NSString  *userName;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, copy) NSString *startDateStr;
@property (nonatomic, copy) NSString *endDateStr;
@property (nonatomic, copy) NSString *eventStatus; 

@property (nonatomic, copy) NSDictionary  *reviewDto;
@property (nonatomic, strong) NSArray  *reviewDtoList;
@property (nonatomic, copy) NSString  *totalStarRating;
@property (nonatomic, copy) NSString  *reviewsCount;
@property (nonatomic, copy) NSString  *thumbnail;//缩略图


@property (nonatomic, copy) NSString *addressDetail;
@property (nonatomic, copy) NSString *whereToMeetDetail;


@end

@interface EventPriceModel : BaseModel

@property (nonatomic, copy) NSString *adult;
@property (nonatomic, copy) NSString *child;
@property (nonatomic, copy) NSString *concession;
@end
 

