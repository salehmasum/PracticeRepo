//
//  BabysittingCheckAvailabilityVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabysittingModel.h"
#import "BookingModel.h"

@interface BabysittingCheckAvailabilityVC : UIViewController
@property (strong, nonatomic) BookingModel *booking;
@property (strong, nonatomic) BabysittingModel *item;
@end
