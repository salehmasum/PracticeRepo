//
//  BaseBookingsTableVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseModel.h"
#import "BookingModel.h"
#import "BaseTableViewController.h"

typedef enum : NSUInteger {
    BookingStatusPast,
    BookingStatusUpcoming,
} BookingStatus;

@interface BaseBookingsTableVC : BaseTableViewController

@property (assign, nonatomic) BookingStatus status;
@end
