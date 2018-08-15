//
//  ProfileBabysittingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ProfileBabysittingVC.h"
#import "BProfileSettingVC.h"
#import "CreateBabySittingVC.h"
#import "PBabysittingListingsVC.h"
#import "PBabysittingReviewsVC.h"
@interface ProfileBabysittingVC ()

@end

@implementation ProfileBabysittingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = @[@{@"name":CustomLocalizedString(@"Create Babysitting Listing", @"profile"),
                          @"icon":@"elepant-blue",
                          @"selector":@"createBabySittingListing:"},
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
    return UserRoleTypeBabySitting;
}
- (void)editProfile:(id)sender{
    BProfileSettingVC *settingVC = [[BProfileSettingVC alloc] init];
    settingVC.title = @"Babysitting - Edit profile";
    settingVC.profileModel = self.profileModel;
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)createBabySittingListing:(id)sender{
    [self verifyChildrenLicenseForType:1 pass:nil];
}

- (void)listings:(id)sender{
    PBabysittingListingsVC *create  = [[PBabysittingListingsVC alloc] init];
    create.title = @"BabySitting Listing";
    create.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:create animated:YES];
} 
- (void)reviews:(id)sender{
    PBabysittingReviewsVC *sharecareReviews = [[PBabysittingReviewsVC alloc] init];
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
