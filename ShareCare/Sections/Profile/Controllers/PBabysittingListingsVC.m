//
//  PBabysittingListingsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "PBabysittingListingsVC.h"
#import "PBSListingsVC.h"
#import "PBSBookingsVC.h"

@interface PBabysittingListingsVC ()

@end

@implementation PBabysittingListingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSString *)navTitle{
    return CustomLocalizedString(@"Babysitting Listings", @"profile");
}

- (NSArray *)vcArr{    
    PBSListingsVC *listVC = [[PBSListingsVC alloc] init]; 
    
    PBSBookingsVC *bookingsVC = [[PBSBookingsVC alloc] init]; 
    
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
