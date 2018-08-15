//
//  ProfileShareCareVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ProfileShareCareVC.h"
#import "PShareCareListingsVC.h"
#import "BProfileSettingVC.h"
#import "CreateShareCareVC.h"
#import "PShareCareReviewsVC.h"
#import "SCProfileSettingVC.h"

@interface ProfileShareCareVC ()

@end

@implementation ProfileShareCareVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = @[@{@"name":CustomLocalizedString(@"Create EleCare Listing", @"profile"),
                          @"icon":@"elepant-blue",
                          @"selector":@"createShareCareListing:"},
                        @{@"name":CustomLocalizedString(@"Reviews", @"profile"),
                          @"icon":@"reviews",
                          @"selector":@"reviews:"},
                        @{@"name":CustomLocalizedString(@"Listings", @"profile"),
                          @"icon":@"listings",
                          @"selector":@"listings:"},
                        @{@"name":CustomLocalizedString(@"Settings", @"profile"),
                          @"icon":@"settings",
                          @"selector":@"settings:"}, 
                        ]; 
}
- (UserRoleType)roleType{
    return UserRoleTypeShareCare;
}
- (void)editProfile:(id)sender{
    SCProfileSettingVC *settingVC = [[SCProfileSettingVC alloc] init];
    settingVC.profileModel = self.profileModel;
    settingVC.title = @"EleCare - Edit profile";
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}


- (void)createShareCareListing:(id)sender{
    [self verifyChildrenLicenseForType:0 pass:nil];
}

- (void)listings:(id)sender{
    PShareCareListingsVC *sharecareListings = [[PShareCareListingsVC alloc] init];
    sharecareListings.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sharecareListings animated:YES];
}

- (void)reviews:(id)sender{
    PShareCareReviewsVC *sharecareReviews = [[PShareCareReviewsVC alloc] init];
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
