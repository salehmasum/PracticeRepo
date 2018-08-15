//
//  ProfileVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ProfileVC.h" 
#import "ProfilePersonalVC.h"
#import "ProfileShareCareVC.h"
#import "ProfileBabysittingVC.h"

@interface ProfileVC (){
}

@property (strong, nonatomic) ProfilePersonalVC    *personalVC;
@property (strong, nonatomic) ProfileShareCareVC   *shareCareVC;
@property (strong, nonatomic) ProfileBabysittingVC *babysittingVC;
@end



@implementation ProfileVC

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
  //  [self getProfile];
} 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
}
- (void)getProfile{
    __weak typeof(self) weakself = self;
    NSArray *array = @[kUSER_TOKEN]; 
    [ShareCareHttp GET:API_USER withParaments:array withSuccessBlock:^(id response) { 
        
        USERDEFAULT_SET(@"email", response[@"email"]);
        USERDEFAULT_SET(@"userId", response[@"id"]);
        USERDEFAULT_SET(@"userName", response[@"name"]);
        USERDEFAULT_SET(@"hashPassword", response[@"hashPassword"]);
        [weakself resetProfile];
    } withFailureBlock:^(NSString *error) {
        //  [SVProgressHUD showErrorWithStatus:error]; 
    }];
}

- (void)resetProfile{
    switch (_currentSelectedIndex) {
        case 0:
            //[self.personalVC initData];
            [self.babysittingVC initData];

            break;
        case 1:
            [self.shareCareVC initData];
            break;
        case 2:
            //[self.babysittingVC initData];
            [self.personalVC initData];

            break;
            
        default:
            break;
    }
}

#pragma mark --------------------------------------------------
#pragma mark Setup

- (ProfilePersonalVC *)personalVC{
    if (!_personalVC) {
        _personalVC = [[ProfilePersonalVC alloc] init];
    }
    return _personalVC;
}

- (ProfileShareCareVC *)shareCareVC{
    if (!_shareCareVC) {
        _shareCareVC = [[ProfileShareCareVC alloc] init];
    }
    return _shareCareVC;
}
- (ProfileBabysittingVC *)babysittingVC{
    if (!_babysittingVC) {
        _babysittingVC = [[ProfileBabysittingVC alloc] init];
    }
    return _babysittingVC;
}



- (NSArray *)vcArr{    
    
   // return @[self.personalVC,self.shareCareVC,self.babysittingVC];
    return @[self.babysittingVC,self.shareCareVC,self.personalVC];
}
- (NSString *)navTitle{
    return CustomLocalizedString(@"Profile", @"home");
}
- (NSArray *)menuItems{
//    return @[CustomLocalizedString(@"PERSONAL", @"Profile"),
//             CustomLocalizedString(@"ELECARE", @"Profile"),
//             CustomLocalizedString(@"BABYSITTING", @"Profile")
//             ];
    return @[CustomLocalizedString(@"BABYSITTING", @"Profile"),
             CustomLocalizedString(@"ELECARE", @"Profile"),
             CustomLocalizedString(@"PERSONAL", @"Profile")
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
