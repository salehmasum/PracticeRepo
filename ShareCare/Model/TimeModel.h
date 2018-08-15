//
//  TimeModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"

@interface TimeModel : BaseModel
@property (nonatomic, copy) NSString  *timeString;//2017-12-07 09:13:03
@property (nonatomic, copy) NSString  *week;
@property (nonatomic, copy) NSString  *shortWeek;
@property (nonatomic, copy) NSString  *day;
@property (nonatomic, copy) NSString  *month;
@property (nonatomic, copy) NSString  *shortMonth;
@property (nonatomic, copy) NSString  *year;
@property (nonatomic, copy) NSString  *hour;
@property (nonatomic, copy) NSString  *minutes;
@property (nonatomic, copy) NSString  *seconds;
@end
