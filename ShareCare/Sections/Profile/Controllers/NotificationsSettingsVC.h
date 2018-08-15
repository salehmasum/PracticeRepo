//
//  NotificationsSettingsVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsSettingsVC : UITableViewController
@property (strong, nonatomic) NSArray *dataSource;
@property (assign, nonatomic) UserRoleType roleType;

@end
