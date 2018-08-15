//
//  EnumMacro.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//


#ifndef EnumMacro_h
#define EnumMacro_h

@protocol ContactSharecarerDelegate <NSObject>

- (void)contactShareCarer;

@end
//登录状态
typedef enum : NSUInteger {
    LoginStateNO,
    LoginStateEmail,
    LoginStateFacebook,
} LoginState;


//用户角色
typedef enum : NSUInteger {
    UserRoleTypeShareCare =0,
    UserRoleTypeBabySitting = 1,
    UserRoleTypeEvent = 2,
} UserRoleType;

#define SHARE_TYPE_SHARECARE @"SHARECATE"
#define SHARE_TYPE_BABYSITTING @"BABYSITTING"
#define SHARE_TYPE_EVENT @"EVENT" 

#define SHARE_TYPE_FOR(type) type==0?SHARE_TYPE_SHARECARE:(type==1?SHARE_TYPE_BABYSITTING:SHARE_TYPE_EVENT)
//订单状态

typedef enum : NSUInteger {
    
    //订单相关
    BookingStatePENDING   =0,
    BookingStateCONFIRMED =1,
    BookingStateDECLINED  =2,
    BookingStateEXPIRED   =3,
    BookingStateCOMPLETED =7,
    BookingStateCANCEL    =8,
    BookingStateTransactionFailed = 9,
    
    
    //listing
    BookingStateRUNNING   =4,
    BookingStateINREVIEW  =5,
    BookingStateCURRENTLY_NOT_RUNNING =6,
} BookingState;

//typedef enum : NSUInteger {
//    
//    ChildrenStateAvailable   =0,
//    ChildrenStateBusy   =1,
//    ChildrenStateCheckAgeRange  =2,
//    ChildrenStateConfirmed   =3, 
//    ChildrenState   =4, 
//} ChildrenState;




#define BookingStateIMAGE_PENDING               [UIImage imageNamed:@"pending"]
#define BookingStateIMAGE_CONFIRMED             [UIImage imageNamed:@"confirmed"]
#define BookingStateIMAGE_EXPIRED               [UIImage imageNamed:@"expired"]
#define BookingStateIMAGE_DECLINED              [UIImage imageNamed:@"declined"]
#define BookingStateIMAGE_RUNNING               [UIImage imageNamed:@"running"]
#define BookingStateIMAGE_INREVIEW              [UIImage imageNamed:@"inreview"]
#define BookingStateIMAGE_CURRENTLY_NOT_RUNNING [UIImage imageNamed:@"currentlynotrunning"]
#define BookingStateIMAGE_COMPLETED [UIImage imageNamed:@"completed"]
#define BookingStateIMAGE_CANCELED [UIImage imageNamed:@"canceled"]

#define BOOKING_IMAGE_STATE(state) [Util bookingStateImage:state]

#endif /* EnumMacro_h */
