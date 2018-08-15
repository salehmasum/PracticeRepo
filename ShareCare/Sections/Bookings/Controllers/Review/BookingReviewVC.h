//
//  BookingReviewVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingModel.h"


@protocol BookingAddReviewDelegate<NSObject>
- (void)addReviewWith:(BookingModel *)booking;
@end
@interface BookingReviewVC : UITableViewController
@property (assign, nonatomic) id<BookingAddReviewDelegate>delegate;
@property (strong, nonatomic) BookingModel *booking;
@property (strong, nonatomic) NSString *bookingId;

@end
