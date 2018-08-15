//
//  WeekdayTimeModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"

@interface WeekdayTimeModel : BaseModel
@property (nonatomic, copy) NSString *mon;
@property (nonatomic, copy) NSString *tues;
@property (nonatomic, copy) NSString *wed;
@property (nonatomic, copy) NSString *thur;
@property (nonatomic, copy) NSString *fri;
@property (nonatomic, copy) NSString *sat;
@property (nonatomic, copy) NSString *sun;
@end
