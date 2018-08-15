//
//  BookingModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/20.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"

@interface BookingModel : BaseModel

@property (nonatomic, copy) NSString  *accountId;  //下单者id
@property (nonatomic, copy) NSString  *pubAccountId;//发布者id
@property (nonatomic, copy) NSString  *pubUserIcon;//发布者
@property (nonatomic, copy) NSString  *pubUserName;//发布者
@property (nonatomic, assign) BOOL hasReview;//是否已被评论

//添加订单
@property (nonatomic, copy) NSString  *careId;
@property (nonatomic, copy) NSString  *typeId;
@property (nonatomic, copy) NSString  *careType;
@property (nonatomic, copy) NSString  *peopleNums;
@property (nonatomic, copy) NSString  *startDate;//2017-11-24T13:01:50
@property (nonatomic, copy) NSString  *endDate;//2017-11-24T13:01:50
@property (nonatomic, copy) NSString  *stayDays;
@property (nonatomic, copy) NSString  *totalPrice;
@property (nonatomic, copy) NSString  *unitPrice;
@property (nonatomic, copy) NSString  *timePeriod;//时间段
@property (nonatomic, strong) NSArray *whoIsComings;
@property (nonatomic, copy) NSString  *adultPrice;
@property (nonatomic, copy) NSString  *toUserName;
@property (nonatomic, strong) NSArray *shareIcon;
@property (nonatomic, copy) NSString  *thumbnail;//缩略图


@property (nonatomic, copy) NSString  *bookingid;
@property (nonatomic, copy) NSString  *bookingId;

@property (assign, nonatomic) double whereToMeetLat;
@property (assign, nonatomic) double whereToMeetLon;
@property (nonatomic, copy) NSString  *whereToMeet;
@property (assign, nonatomic) double addressLon;
@property (assign, nonatomic) double addressLat;
@property (copy, nonatomic) NSString *bookingCode;

@property (copy, nonatomic) NSString *rejectReason;

//booking 列表
@property (nonatomic, copy) NSString  *bookingStatus;
@property (nonatomic, copy) NSString  *createTime;
@property (nonatomic, copy) NSString  *shareAddress;
@property (nonatomic, copy) NSString  *updateTime;


//额外参数
@property (nonatomic, strong) NSArray *times;
@property (nonatomic, copy) NSString  *firstPic;
@property (nonatomic, copy) NSString  *userIcon;
@property (nonatomic, copy) NSString  *userName;
@property (nonatomic, copy) NSString  *unitPriceStr;
@property (nonatomic, assign) NSInteger remainingPlace;


@property (nonatomic, copy) NSString  *startDateStr;//界面显示格式
@property (nonatomic, copy) NSString  *endDateStr;//界面显示格式
@end
