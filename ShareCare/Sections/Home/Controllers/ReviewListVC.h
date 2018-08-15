//
//  ReviewListVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ReviewsCell.h"
#import "ReportAlertView.h"

@interface ReviewListVC : BaseTableViewController<ReviewsCellDelagete>
@property (strong, nonatomic) NSArray *reviewDtoList;
@property (strong, nonatomic) ReportAlertView *reportAlert;

@property (strong, nonatomic) NSString *reviewType;
@property (strong, nonatomic) NSString *reviewTypeId;

@end
