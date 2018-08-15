//
//  SelectProfileVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/28.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildrenModel.h"
#import "BookingModel.h"
#import "ShareCareModel.h"

typedef void(^SelectProfileBlock)(ChildrenModel *child);

@interface SelectProfileVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
}
@property (strong, nonatomic) id item;
@property (strong, nonatomic) BookingModel *booking;
@property (strong, nonatomic) NSArray *childrens;  
@property (strong, nonatomic) NSArray *joinChildrens;  
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SelectProfileBlock selectProfile;

@end
