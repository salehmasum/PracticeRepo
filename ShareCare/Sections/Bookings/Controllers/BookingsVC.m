//
//  BookingsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BookingsVC.h" 
#import "BPastVC.h"
#import "BUpcomingVC.h"

@interface BookingsVC ()

@end

@implementation BookingsVC

 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view. 
     
}
#pragma mark --------------------------------------------------
#pragma mark Setup

- (NSArray *)vcArr{    
    BPastVC *viewController1 = [[BPastVC alloc] init];
    BUpcomingVC *viewController2 = [[BUpcomingVC alloc] init];
    
    return @[viewController1,viewController2];
}

- (NSString *)navTitle{
    return CustomLocalizedString(@"Bookings", @"home");
}
- (NSArray *)menuItems{
    return @[CustomLocalizedString(@"PAST", @"Bookings"),
             CustomLocalizedString(@"UPCOMING", @"Bookings")
             ];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
