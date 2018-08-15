//
//  BaseProfileTableVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileModel.h"
#import "HeadImage.h"
#import "SettingsTableVC.h"
#import "UIViewController+Create.h"
@interface BaseProfileTableVC : UITableViewController 
@property (strong, nonatomic) NSArray *dataSource; 
@property (strong, nonatomic) ProfileModel *profileModel;
@property (assign, nonatomic) UserRoleType roleType;
- (void)initData;

- (void)editProfile:(id)sender;
@end
