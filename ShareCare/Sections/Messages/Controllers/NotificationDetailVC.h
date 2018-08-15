//
//  NotificationDetailVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationDetailVC : UITableViewController<ContactSharecarerDelegate>

@property (nonatomic, assign)  BookingState bookingState;
@property (strong, nonatomic) NSString *bookingId;
@property (strong, nonatomic) BookingModel *booking;

@end
