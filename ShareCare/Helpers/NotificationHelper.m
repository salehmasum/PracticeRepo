//
//  NotificationHelper.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "NotificationHelper.h"
#import "NotificationView.h"
static NotificationHelper *notification;  

@implementation NotificationHelper

+ (NotificationHelper *)sharedInstance{  
    static dispatch_once_t onceToken;  
    dispatch_once(&onceToken, ^{  
        notification = [[NotificationHelper alloc]init];  
    });  
    return notification;  
} 

+ (void)dismissView:(UIView *)nView{
    nView.center = CGPointMake(TX_SCREEN_WIDTH/2.0, -CGRectGetHeight(nView.frame)/2-10);
}

+ (void)registerLocalNotification:(MessageModel *)message{
    
    NotificationView *notificationView= [[NotificationView alloc] init];
    if (![message.toUserIcon isEqual:[NSNull null]]) {
        [notificationView.icon setImageWithURL:[NSURL URLWithString:URLStringForPath(message.toUserIcon)] 
                              placeholderImage:kDEFAULT_HEAD_IMAGE];

    }
    notificationView.lbName.text = message.toUserName;
   
    switch (message.type) {
        case MessageTypeTEXT: 
            notificationView.lbContent.text =message.content;
            break;
        case MessageTypePICTURE: 
            notificationView.lbContent.text =@"[You have received a photo]";
            break;
        case MessageTypeVOICE: 
            notificationView.lbContent.text =@"[You have received a voice]";
            break;
        case MessageTypeVIDEO: 
            notificationView.lbContent.text =@"[You have received a video]";
            break;
        case MessageTypeBOOKING: 
            notificationView.lbContent.text =[message.content componentsSeparatedByString:@"!*#"].firstObject;
            break;
            
            
        default:
            
            notificationView.lbContent.text =message.content;
            break;
    }
    
    
    [notificationView show];
    return;
    
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    // 设置触发通知的时间
//    notification.fireDate = [NSDate date];
//    // 时区
//    notification.timeZone = [NSTimeZone defaultTimeZone];
//    // 设置重复的间隔
//    notification.repeatInterval = 0;//0表示不重复
//    // 通知内容
//    notification.alertBody =  message.content;
//  //  notification.applicationIconBadgeNumber = 1;
//    // 通知被触发时播放的声音
//    notification.soundName = UILocalNotificationDefaultSoundName;
//    // 通知参数
//
//    notification.userInfo = [message convertToDictionary];
//    
//    // ios8后，需要添加这个注册，才能得到授权
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
//                                                                                 categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//        // 通知重复提示的单位，可以是天、周、月
//        //        notification.repeatInterval = NSCalendarUnitDay;
//    } 
//    
//    // 执行通知注册
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}




@end
