//
//  NotificationInitVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "NotificationInitVC.h"
#import "AppDelegate.h"
#import "BeforeJoinVC.h"
#import <UserNotifications/UserNotifications.h>
@interface NotificationInitVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation NotificationInitVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.self.facebookBtn.layer.masksToBounds = YES;
    [self setup];
}
- (void)setup{ 
    self.titleLabel.text = CustomLocalizedString(@"Turn on notifications?", @"notify");
    self.titleLabel.font = TX_FONT(32);
     
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)skipAction:(id)sender {
}
- (IBAction)notifyMeAction:(id)sender { 
    

//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0  
//    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];  
//    if (setting.types != UIUserNotificationTypeNone) {  
//        NSLog(@"Notification status Open"); 
//        [self pushNextViewController];
//    }else{
//        
//        NSLog(@"Notification status close"); 
//        [self showAlert];
//    }
//#else  
//    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];  
//    if (type != UIRemoteNotificationTypeNone) {   
//        NSLog(@"Notification status Open");
//        [self pushNextViewController];
//    }else{
//        
//        NSLog(@"Notification status close"); 
//        [self showAlert];
//    }
//#endif    
//     
//}
//
//- (void)showAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:CustomLocalizedString(@"\"EleCare\" Would Like to Send You Notifications", @"signup") message:@"Notifcations may include alerts, sounds,and icon badges. These can be configured in Settings." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Don’t Allow", @"signup") 
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                               [self pushNextViewController];
                                                           }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Allow", @"signup") 
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
//                                                           if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone) {  
//                                                               [self openSettings];
//                                                           } else{ 
//                                                               [self pushNextViewController];
//                                                           } 
                                                           
                                                           [self checkNotificationStatus];
                                                           
                                                       }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil]; 
}

- (void)checkNotificationStatus{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0  
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];  
    if (setting.types != UIUserNotificationTypeNone) {  
        NSLog(@"Notification status Open"); 
        [self pushNextViewController];
    }else{
        
        NSLog(@"Notification status close"); 
        [self openSettings];
    }
#else  
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];  
    if (type != UIRemoteNotificationTypeNone) {   
        NSLog(@"Notification status Open");
        [self pushNextViewController];
    }else{
        
        NSLog(@"Notification status close"); 
        [self openSettings];
    }
#endif    
}



- (void)openSettings{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString]; 
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        
    } 
}
- (void)pushNextViewController{
     [self loginForState:LoginStateEmail];
//    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
//    BeforeJoinVC *notifyVC = (BeforeJoinVC *)[board instantiateViewControllerWithIdentifier: @"BeforeJoinVC"];
//    [self.navigationController pushViewController:notifyVC animated:YES]; 
}
- (void)receiveAPNSdeviceToken:(NSNotification *)notification{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    
//    BeforeJoinVC *nextVC = [sb instantiateViewControllerWithIdentifier:@"BeforeJoinVC"]; 
//    [self.navigationController pushViewController:nextVC animated:YES];
    
    
    [self pushNextViewController];
}





@end
