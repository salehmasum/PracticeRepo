//
//  AppDelegate+Notification.m
//  ShareCare
//
//  Created by 朱明 on 2018/4/19.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "AppDelegate+Notification.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@implementation AppDelegate (Notification)

- (void)configPushNotification:(id)target{
#if TARGET_IPHONE_SIMULATOR  
    NSLog(@"run on simulator");  
    USERDEFAULT_SET_APNS_DEVICE_TOKEN(@"simulatordevicetoken");
#else  
    NSLog(@"run on device");  
#endif
    
    //消息推送
    //    [FIRApp configure];
    //    [FIRMessaging messaging].delegate = self;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = target;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
            NSLog(@"````````````````");
            
        }];
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
@end
