//
//  HEventDetailVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HBaseDetailVC.h"
#import "EventModel.h"
#import "EventWhosComingVC.h"
#import "BookingModel.h"

@interface HEventDetailVC : HBaseDetailVC

@property (strong, nonatomic) BookingModel *booking;
//@property (strong, nonatomic) EventModel *item;
@end
