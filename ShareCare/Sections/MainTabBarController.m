//
//  MainTabBarController.m
//  ShareCare
//
//  Created by 朱明 on 17/8/5.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeVC.h"
#import "FavoriteVC.h"
#import "BookingsVC.h"
#import "MessagesVC.h"
#import "ProfileVC.h"
#import "JPNavigationControllerKit.h"
#import "MyBookingsDetailVC.h"
#import "ChatViewController.h"
#import "AppDelegate.h"
#import "UIViewController+login.h" 
#import "ProfileModel.h"
#import "SCProfileSettingVC.h"
#import "MyBookingsDetailVC.h"
@import GooglePlaces;
@interface MainTabBarController (){
    AppDelegate *_appDelegate;
    NSURLSessionDataTask *_task;
    UIView *badgeView;
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error==nil && placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            
            if (place != nil) USERDEFAULT_COORDINATE_SET(place.coordinate);
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMessageStatusImage:) name:@"removeMessageStatusImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMessageStatusImage:) name:@"showMessageStatusImage" object:nil]; 
    
    
    [[UITabBar appearance]setBackgroundImage:[[UIImage alloc]init]]; 
    [[UITabBar appearance]setBackgroundColor:[UIColor whiteColor]];
    
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    HomeVC *vc1 = (HomeVC *)[board instantiateViewControllerWithIdentifier: @"HomeVC"]; 
    vc1.tabBarItem.title=CustomLocalizedString(@"Home", @"tabbar");
    vc1.tabBarItem.selectedImage = [UIImage imageNamed:@""]; 
     
    FavoriteVC *vc2 = (FavoriteVC *)[board instantiateViewControllerWithIdentifier: @"FavoriteVC"]; 
    vc2.tabBarItem.title=CustomLocalizedString(@"Favourites", @"tabbar");
    vc2.tabBarItem.selectedImage = [UIImage imageNamed:@""];
    vc2.tabBarItem.image = [UIImage imageNamed:@""];
     
    BookingsVC *vc3 = (BookingsVC *)[board instantiateViewControllerWithIdentifier: @"BookingsVC"]; 
    vc3.tabBarItem.title=CustomLocalizedString(@"Bookings", @"tabbar");
    vc3.tabBarItem.selectedImage = [UIImage imageNamed:@""];
    vc3.tabBarItem.image = [UIImage imageNamed:@""];
    
    MessagesVC *vc4 = (MessagesVC *)[board instantiateViewControllerWithIdentifier: @"MessagesVC"];
    vc4.tabBarItem.title=CustomLocalizedString(@"Messages", @"tabbar");
    vc4.tabBarItem.selectedImage = [UIImage imageNamed:@""]; 
    vc4.tabBarItem.image = [UIImage imageNamed:@""];
    
    
    ProfileVC *vc5 = (ProfileVC *)[board instantiateViewControllerWithIdentifier: @"ProfileVC"]; 
    vc5.tabBarItem.title=CustomLocalizedString(@"Profile", @"tabbar");
    vc5.tabBarItem.selectedImage = [UIImage imageNamed:@""];
    vc5.tabBarItem.image = [UIImage imageNamed:@""];
     
    
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    nav1.title = CustomLocalizedString(@"Home", @"tabbar");
    nav1.tabBarItem.image = [UIImage imageNamed:@"home-disabled"];
    nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"home-enabled"];
    
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    nav2.title = CustomLocalizedString(@"Favourites", @"tabbar");
    nav2.tabBarItem.image = [UIImage imageNamed:@"favorites-disabled"];
    nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"favorites-enabled"];
    
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:vc3];
    nav3.title = CustomLocalizedString(@"Bookings", @"tabbar");
    nav3.tabBarItem.image = [UIImage imageNamed:@"booking-disabled"];
    nav3.tabBarItem.selectedImage = [UIImage imageNamed:@"bookings-enabled"];
    
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:vc4];
    nav4.title = CustomLocalizedString(@"Messages", @"tabbar");
    nav4.tabBarItem.image = [UIImage imageNamed:@"messages-disabled"];
    nav4.tabBarItem.selectedImage = [UIImage imageNamed:@"messages-enabled"];
//    nav4.tabBarItem.badgeValue = @"";
//    nav4.tabBarItem.badgeColor = COLOR_BLUE;
    
    UINavigationController *nav5 = [[UINavigationController alloc]initWithRootViewController:vc5];
    nav5.title = CustomLocalizedString(@"Profile", @"tabbar");
    nav5.tabBarItem.image = [UIImage imageNamed:@"profile-disabled"];
    nav5.tabBarItem.selectedImage = [UIImage imageNamed:@"profile-enabled"];
    
    self.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
    
    _appDelegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    //前台收到消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveStateActiveNotification:) name:@"applicationDidReceiveStateActiveNotification" object:nil];
    //用户未登录
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidNotLoginNotification:) name:@"applicationDidNotLoginNotification" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryBookingDetailBookingId:) name:@"queryBookingDetail" object:nil];
    
    [self applicationDidBecomeActiveNotification:nil];
}

- (void)removeMessageStatusImage:(NSNotification *)notification{
    //显示  
    [self hideBadgeOnItemIndex:3];
}
- (void)showMessageStatusImage:(NSNotification *)notification{
    //隐藏  
    [self showBadgeOnItemIndex:3];  
    
} 
//显示小红点  
- (void)showBadgeOnItemIndex:(int)index{    
    //移除之前的小红点  
  //  [self removeBadgeOnItemIndex:index];  
    
    //新建小红点  
    if (badgeView == nil) {
        badgeView = [[UIView alloc]init];  
        badgeView.tag = 888 + index;  
        badgeView.layer.cornerRadius = 5;//圆形  
        badgeView.backgroundColor = COLOR_BLUE;//颜色：红色  
        CGRect tabFrame = self.tabBar.frame;  
        
        //确定小红点的位置  
        float percentX = (index +0.6) / 5;  
        CGFloat x = ceilf(percentX * tabFrame.size.width);  
        CGFloat y = ceilf(0.1 * tabFrame.size.height-3);  
        badgeView.frame = CGRectMake(x, y, 10, 10);//圆形大小为10  
        [self.tabBar addSubview:badgeView];  
    }
    
    badgeView.hidden = NO;
    
}  
//隐藏小红点  
- (void)hideBadgeOnItemIndex:(int)index{  
    //移除小红点  
  //  [self removeBadgeOnItemIndex:index];  
    
    
    badgeView.hidden = YES;
}  
//移除小红点  
- (void)removeBadgeOnItemIndex:(int)index{  
    //按照tag值进行移除  
    for (UIView *subView in self.tabBar.subviews) {  
        if (subView.tag == 888+index) {  
            [subView removeFromSuperview];  
        }  
    }  
}  

- (void)applicationDidNotLoginNotification:(NSNotification *)notification{ 
    [SVProgressHUD dismiss];
    NSLog(@"%@",notification.object);
    _task = (NSURLSessionDataTask *)notification.object; 
    [self loginForState:kUSER_LOGIN_STATE];
}
- (void)loginRequestSuccess{
    NSLog(@"loginRequestSuccess");
}
- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification{ 
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"openNotificationDetail"]) {
       [self openNotification];
    } 
}


- (void)applicationDidReceiveStateActiveNotification:(NSNotification *)notification{
    NSDictionary *notificationMsg = _appDelegate.notification;
    if (![[notificationMsg allKeys] containsObject:@"type"]) {
        NSDictionary *aps = notificationMsg[@"aps"];
        
        
        id alert = aps[@"alert"];
        NSString *content = @"You have received a message.";
        if ([alert isKindOfClass:[NSDictionary class]]) {
            content = [NSString stringWithFormat:@"%@",alert[@"body"]];
        }else{
            content = [NSString stringWithFormat:@"%@",alert];
        }
        
        UIAlertController *alertController = [UIAlertController 
                                              alertControllerWithTitle:@"Message" 
                                              message:content
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Go Back" 
                                                               style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { 
                                                               }]; 
        
        [alertController addAction:cancelAction]; 
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        MessageType type = (MessageType)[_appDelegate.notification[@"type"] integerValue];
        if(type==MessageTypeCertificateAuditFaild || type==MessageTypeCertificateAuditSuccess){
            //证书审核是否通过
            [self showAlertType:type];
        }
    }
    
}


- (void)openNotification{
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"openNotificationDetail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *aps = _appDelegate.notification;
    @try { 
        if ([[aps allKeys] containsObject:@"type"]) {
            MessageType type = (MessageType)[aps[@"type"] integerValue];
            if (type== MessageTypeBOOKING) {
                
        //        [self performSelector:@selector(queryBookingDetail) withObject:nil afterDelay:1];
            }else if(type == MessageTypeTEXT ||
                     type == MessageTypePICTURE ||
                     type == MessageTypeVIDEO ||
                     type == MessageTypeVOICE){
                [SVProgressHUD showWithStatus:TEXT_LOADING];
                [self performSelector:@selector(queryChatViewController) withObject:nil afterDelay:1];
            }else if(type==MessageTypeCertificateAuditFaild || type==MessageTypeCertificateAuditSuccess){
                //证书审核是否通过
                [self editEleCare];
            }
        }else{
            
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
- (void)queryBookingDetail{
    [SVProgressHUD dismiss]; 
    
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    
    MyBookingsDetailVC *detail  = [[MyBookingsDetailVC alloc] initWithNibName:NSStringFromClass([BookingDetailVC class]) bundle:nil];
    detail.hidesBottomBarWhenPushed = YES; 
    detail.bookingId = _appDelegate.notification[@"bookingId"];  
    [nav pushViewController:detail animated:YES];
}

//openfile消息，查看订单详情
- (void)queryBookingDetailBookingId:(NSNotification *)notification{
    [SVProgressHUD dismiss]; 
   
    [self showBookingDetail:[NSString stringWithFormat:@"%@",notification.object[@"bookingId"]] 
               pubAccountId:[NSString stringWithFormat:@"%@",notification.object[@"pubAccountId"]] ];
    
//    [SVProgressHUD showWithStatus:TEXT_LOADING];
//    
//    __weak typeof(self) weakSelf = self;
//    [ShareCareHttp GET:API_BOOKING_DETAIL withParaments:@[notification.object] withSuccessBlock:^(id response) {
//        
//        BookingModel *booking = [BookingModel modelWithDictionary:response]; 
//        [weakSelf showBookingDetail:notification.object pubAccountId:booking.pubAccountId];
//   //     [SVProgressHUD dismiss];
//    } withFailureBlock:^(NSString *error) {
//        [SVProgressHUD showErrorWithStatus:error];
//    }];
    
    
}
- (void)showBookingDetail:(id)bookingId pubAccountId:(NSString *)pubAccountId{
    UINavigationController *nav = self.viewControllers[self.selectedIndex]; 
    
    
    if ([pubAccountId isEqualToString:kUSER_ID]) {
        MyBookingsDetailVC *detail  = [[MyBookingsDetailVC alloc] initWithNibName:NSStringFromClass([BookingDetailVC class]) bundle:nil];
        detail.hidesBottomBarWhenPushed = YES; 
        detail.bookingId = bookingId;  
        [nav pushViewController:detail animated:YES];
    }else{
        BookingDetailVC *detail  = [[BookingDetailVC alloc] init];
        detail.hidesBottomBarWhenPushed = YES; 
        detail.bookingId = bookingId; 
        [nav pushViewController:detail animated:YES];
    }
    
    
    
    
}
- (void)queryChatViewController{
    [SVProgressHUD dismiss];
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    ChatViewController *detail = [[ChatViewController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
    detail.toUserName = _appDelegate.notification[@"userName"];  
    detail.toUser = _appDelegate.notification[@"accountId"];  
    detail.toUserIcon = _appDelegate.notification[@"userIcon"];
    
    NSMutableArray *navVCs= [NSMutableArray arrayWithArray:nav.viewControllers];
    if ([navVCs.lastObject isKindOfClass:[ChatViewController class]]) {
        [navVCs replaceObjectAtIndex:navVCs.count-1 withObject:detail];
        nav.viewControllers = navVCs;
    }else{
        [nav pushViewController:detail animated:YES];
    }
    
    
}
- (void)showAlertType:(MessageType)type{
    
    //证书审核  5失败，6成功
    NSString *title = @"Oops! Something went wrong! ";
    NSString *message = @"Looks like there was an issue processing your Police Check or Working with Children’s check. We’ve sent you an email with instructions on how to proceed." ;
    
    if (type == MessageTypeCertificateAuditSuccess) {
        title = @"Congratulations! You’re an approved EleCarer.";
        message = @"Your Police Check and Working with Children’s Check have been approved.";
    }
    
    
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:title 
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Go Back" 
                                                           style:UIAlertActionStyleDefault 
                                                         handler:^(UIAlertAction * _Nonnull action) { 
                                                         }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"View Profile" 
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) { 
                                                           
                                                       }];
    [alertController addAction:saveAction];
    [self presentViewController:alertController animated:YES completion:^{ 
    }];
}

- (void)editEleCare{
    SCProfileSettingVC *settingVC = [[SCProfileSettingVC alloc] init];
    settingVC.profileModel = [[ProfileModel alloc] init];
    settingVC.title = @"EleCare - Edit profile";
    settingVC.hidesBottomBarWhenPushed = YES;
    
    UINavigationController *nav = self.viewControllers[self.selectedIndex];
    [nav pushViewController:settingVC animated:YES];
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
