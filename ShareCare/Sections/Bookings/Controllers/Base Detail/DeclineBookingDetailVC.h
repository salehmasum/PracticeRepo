//
//  DeclineBookingDetailVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingModel.h"

@protocol DeclineBookingDelegate <NSObject>

- (void)declineBooking:(BookingModel *)book;

@end

@interface DeclineBookingDetailVC : UIViewController

@property (strong, nonatomic) BookingModel *booking;

@property (assign, nonatomic) id<DeclineBookingDelegate>delegate;
@end
