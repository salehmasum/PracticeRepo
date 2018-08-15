//
//  PShareCareListingsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/11.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "PShareCareListingsVC.h"
#import "PSCListingsVC.h"
#import "PSCBookingsVC.h"
@interface PShareCareListingsVC ()

@end

@implementation PShareCareListingsVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 //   [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     
    self.view.backgroundColor = [UIColor whiteColor];
    __block typeof(self) tmpSelf = self;
    [self.navMenu setBackImage:[UIImage imageNamed:@"back-button-blue"] action:^{
        [tmpSelf.navigationController popViewControllerAnimated:YES]; 
    }];
    self.title = self.navTitle;
    [self.contentView setFrame:CGRectMake(0, NAVIGATION_MENU_HEIGHT, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-( NAVIGATION_MENU_HEIGHT))];
    
    self.segHead.frame = CGRectMake(0, 55*TX_SCREEN_OFFSET+24*iSiPhoneX , SCREEN_WIDTH, 40);
    self.segScroll.frame =CGRectMake(0, CGRectGetMaxY(self.segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(self.segHead.frame));
}



#pragma mark --------------------------------------------------
#pragma mark Setup

- (MenuType)menuType{
    return MenuTypePushView;
}
- (UIColor *)titleColor{
    return COLOR_GRAY;
} 
- (NSString *)navTitle{
    return CustomLocalizedString(@"EleCare Listings", @"profile");
}

- (NSArray *)menuItems{
    return @[CustomLocalizedString(@"LISTINGS", @"profile"),
             CustomLocalizedString(@"BOOKINGS", @"profile")
             ];
} 
 

- (NSArray *)vcArr{    
    PSCListingsVC *listVC = [[PSCListingsVC alloc] init]; 
    
    PSCBookingsVC *bookingsVC = [[PSCBookingsVC alloc] init]; 
    
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
