//
//  SReviewsAboutYouVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ReportAlertView.h"

@interface SReviewsAboutYouVC : BaseTableViewController
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) ReportAlertView *reportAlert;
@property (assign, nonatomic) NSInteger reviewType;

@end

