//
//  BabysittingReviewBookingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/20.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BabysittingReviewBookingVC.h"
#import "BabysittingModel.h"

@interface BabysittingReviewBookingVC (){
    BabysittingModel *_babysitting;
}

@end

@implementation BabysittingReviewBookingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.booking.careType = @"1";
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
