//
//  ReviewsViewController.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewsCell.h"
#import "ReportAlertView.h"
#import "BaseTableViewController.h"

@interface ReviewsViewController : BaseTableViewController<ReviewsCellDelagete>
@property (strong, nonatomic) NSArray *reviewDtoList;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ReportAlertView *reportAlert;

@property (strong, nonatomic) NSString *reviewType;
@property (strong, nonatomic) NSString *reviewTypeId;

@end
