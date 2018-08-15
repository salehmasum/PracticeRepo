//
//  ChildrenModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"

typedef enum : NSUInteger {
    ChildStateAvailable     = 0,
    ChildStateBusy          = 1,
    ChildStateCheckAgeRange = 2,
    ChildStateConfirmed     = 3,
} ChildState;

@interface ChildrenModel : BaseModel
@property (copy, nonatomic) NSString *age;
@property (copy, nonatomic) NSString *fullName;
@property (copy, nonatomic) NSString *gender;
@property (copy, nonatomic) NSString *childIconPath;
@property (copy, nonatomic) NSString *timePeriod;
@property (copy, nonatomic) NSString *relationship;
@property (copy, nonatomic) NSString *childStatus;
@property (copy, nonatomic) NSString *childId;

@property (copy, nonatomic) NSString *birthday; 
@property (copy, nonatomic) NSString *emergencyContactPerson;
@property (copy, nonatomic) NSString *emergencyContactPhone;


//自定义字段
@property (assign, nonatomic) BOOL isMyChild;
@property (assign, nonatomic) BOOL myChild;
@property (assign, nonatomic) ChildState state;
@property (copy, nonatomic) NSString *stateStr;


@property (copy, nonatomic) NSString *childIcon;
@property (copy, nonatomic) NSString *childName;
@property (copy, nonatomic) NSString *status;
 

@end
