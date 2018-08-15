//
//  ProfilePersonalVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ProfilePersonalVC.h"
#import "SProfileSettingVC.h" 
#import "CreateEventsVC.h"
#import "PEventListingsVC.h"
#import "HelpAndSupportVC.h"
#import "FeedbackVC.h"
#import "PEventReviewsVC.h"
#import "UIViewController+Create.h"
@interface ProfilePersonalVC ()

@end

@implementation ProfilePersonalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = @[@{@"name":CustomLocalizedString(@"Create Event Listing", @"profile"),
                          @"icon":@"elepant-blue",
                          @"selector":@"createEventListing:"},
                        @{@"name":CustomLocalizedString(@"Listings", @"profile"),
                          @"icon":@"listings",
                          @"selector":@"listings:"},
                        @{@"name":CustomLocalizedString(@"Settings", @"profile"),
                          @"icon":@"settings",
                          @"selector":@"settings:"},
                        @{@"name":CustomLocalizedString(@"Help & Support", @"profile"),
                          @"icon":@"help-and-support",
                          @"selector":@"helpAndSupport:"},
                        @{@"name":CustomLocalizedString(@"Give us feedback", @"profile"),
                          @"icon":@"feeback",
                          @"selector":@"feeback:"},
                        ]; 
    
    
    /*
     
     @{@"name":CustomLocalizedString(@"Reviews", @"profile"),
     @"icon":@"reviews",
     @"selector":@"reviews:"},
     */
  
}
- (UserRoleType)roleType{
    return UserRoleTypeEvent;
}
- (void)editProfile:(id)sender{
    SProfileSettingVC *settingVC = [[SProfileSettingVC alloc] init];
    settingVC.roleType = UserRoleTypeEvent;
    settingVC.profileModel = self.profileModel;
    settingVC.title = @"Edit Personal Profile";
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (void)createEventListing:(id)sender{
//    CreateEventsVC *create  = [[CreateEventsVC alloc] init];
//    create.title = @"Event Holder Listing";
//    create.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:create animated:YES];
    
    [self verifyChildrenLicenseForType:2 pass:nil];
}
- (void)listings:(id)sender{
    PEventListingsVC *sharecareListings = [[PEventListingsVC alloc] init];
    sharecareListings.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sharecareListings animated:YES];
}

- (void)helpAndSupport:(id)sender{
    HelpAndSupportVC *create  = [[HelpAndSupportVC alloc] init];
    create.title = @"";
    create.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:create animated:YES];
}
- (void)feeback:(id)sender{
    FeedbackVC *create  = [[FeedbackVC alloc] init];
    create.title = @"";
    create.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:create animated:YES];
}

- (void)reviews:(id)sender{
    PEventReviewsVC *sharecareReviews = [[PEventReviewsVC alloc] init];
    sharecareReviews.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sharecareReviews animated:YES];
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
