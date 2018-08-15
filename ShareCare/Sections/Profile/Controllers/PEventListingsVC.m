//
//  PEventListingsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "PEventListingsVC.h"
#import "ProfileEventListingVC.h"
#import "ProfileEventBookingsVC.h"

@interface PEventListingsVC ()

@end

@implementation PEventListingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSString *)navTitle{
    return CustomLocalizedString(@"Event Listings", @"profile");
}

- (NSArray *)vcArr{    
    ProfileEventListingVC *listVC = [[ProfileEventListingVC alloc] init]; 
    
    ProfileEventBookingsVC *bookingsVC = [[ProfileEventBookingsVC alloc] init]; 
    
    return @[listVC,bookingsVC];
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
