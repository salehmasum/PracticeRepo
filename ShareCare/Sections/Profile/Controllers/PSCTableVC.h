//
//  PSCTableVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/11.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "BookingModel.h"
#import "BookingDetailVC.h"
#import "UpcomingCell.h"

@interface PSCTableVC : BaseTableViewController

@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *headerTitleLabel;
@property (strong, nonatomic) UIView *footerView;


- (NSString *)headerTitleText;
- (NSString *)headerDescText;

@end
