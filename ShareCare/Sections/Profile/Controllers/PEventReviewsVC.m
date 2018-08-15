//
//  PEventReviewsVC.m
//  ShareCare
//
//  Created by 朱明 on 2018/1/3.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "PEventReviewsVC.h"
#import "EReviewByYouVC.h"
#import "EReviewsAboutYouVC.h"

@interface PEventReviewsVC ()

@end

@implementation PEventReviewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSString *)navTitle{
    return CustomLocalizedString(@"Event Reviews", @"profile");
}

- (NSArray *)menuItems{
    return @[CustomLocalizedString(@"REVIEWS ABOUT YOU", @"profile"),
             CustomLocalizedString(@"REVIEWS BY YOU", @"profile")
             ];
} 
- (NSArray *)vcArr{    
    EReviewsAboutYouVC *about = [[EReviewsAboutYouVC alloc] init]; 
    
    EReviewByYouVC *byYou = [[EReviewByYouVC alloc] init]; 
    
    return @[about,byYou];
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