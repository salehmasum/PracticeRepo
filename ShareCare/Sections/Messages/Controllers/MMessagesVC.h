//
//  MMessagesVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
@interface MMessagesVC : UITableViewController
@property (strong, nonatomic) NSMutableArray *dataSource;
- (void)setMessageBlockNil;
- (void)initData;
@end
