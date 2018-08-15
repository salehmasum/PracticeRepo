//
//  PBSBookingsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "PBSBookingsVC.h"

@interface PBSBookingsVC ()

@end

@implementation PBSBookingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (NSString *)headerTitleText{
    return @"";
}
- (NSString *)headerDescText{
    return @"You have no upcoming reservations.";
}
- (NSString *)api{
    return [NSString stringWithFormat:@"%@shareType=1&",API_BOOKING_OTHERS_LIST];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


@end
