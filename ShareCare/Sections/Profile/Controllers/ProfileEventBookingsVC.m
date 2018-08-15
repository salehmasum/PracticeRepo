//
//  ProfileEventBookingsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ProfileEventBookingsVC.h"

@interface ProfileEventBookingsVC ()

@end

@implementation ProfileEventBookingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (NSString *)headerTitleText{
    return @"";
}
- (NSString *)headerDescText{
    return @"You have no upcoming reservations.";
}

- (NSString *)api{
    return [NSString stringWithFormat:@"%@shareType=2&",API_BOOKING_OTHERS_LIST];
}



- (void)post:(id)sender{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source




@end
