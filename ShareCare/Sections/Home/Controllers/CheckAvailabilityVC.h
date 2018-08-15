//
//  CheckAvailabilityVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckAvailabilityCell.h"
#import "WhosComingVC.h"
#import "ShareCareModel.h"
#import "ZPicker.h"
#import "BookingModel.h"

@interface CheckAvailabilityVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray *_dataSource;
    NSDate *_selectedDate;
    
    BOOL _isConfirmViewShow;
}
@property (strong, nonatomic) ShareCareModel *item;
@property (strong, nonatomic) NSString *availableTime;
@property (strong, nonatomic) BookingModel *booking;
@property (strong, nonatomic) NSArray *childrens;
@end
