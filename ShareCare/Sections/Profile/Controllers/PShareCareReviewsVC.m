//
//  PShareCareReviewsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "PShareCareReviewsVC.h"
#import "SReviewsAboutYouVC.h"
#import "SReviewByYouVC.h"

@interface PShareCareReviewsVC ()

@end

@implementation PShareCareReviewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSString *)navTitle{
    return CustomLocalizedString(@"EleCare Reviews", @"profile");
}

- (NSArray *)menuItems{
    return @[CustomLocalizedString(@"REVIEWS ABOUT YOU", @"profile"),
             CustomLocalizedString(@"REVIEWS BY YOU", @"profile")
             ];
} 
- (NSArray *)vcArr{    
    SReviewsAboutYouVC *about = [[SReviewsAboutYouVC alloc] init]; 
    
    SReviewByYouVC *byYou = [[SReviewByYouVC alloc] init]; 
    
    return @[about,byYou];
}
@end
