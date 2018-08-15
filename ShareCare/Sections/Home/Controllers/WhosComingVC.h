//
//  WhosComingVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/28.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhosComingCell.h"
#import "ChildrenModel.h"
#import "ShareCareModel.h"
#import "BookingModel.h"

@interface WhosComingVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
}
@property (strong, nonatomic) BookingModel *booking;
@property (assign, nonatomic) NSInteger hasJoinChildrensNum;
@property (strong, nonatomic) id item;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *myChildrens;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;

@property (weak, nonatomic) IBOutlet UIButton *requestBtn;
@property (weak, nonatomic) IBOutlet UILabel *lbLocation;
@end
