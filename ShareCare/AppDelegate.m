//
//  AppDelegate.m
//  ShareCare
//
//  Created by 朱明 on 17/8/4.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "AppDelegate.h" 
#import "AFNetworking.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <Firebase/Firebase.h>
#import <UMSocialCore/UMSocialCore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "BraintreeCore.h"
#import "MyBookingsDetailVC.h"
#import "ChatViewController.h"
#import "AppDelegate+SVProgressHUD.h" 
#define kBRAINTREE_BUNDLEID [NSString stringWithFormat:@"%@.payments",[[NSBundle mainBundle] bundleIdentifier]]


@import GooglePlaces;
NSString *const kGCMMessageIDKey = @"gcm.message_id";
@interface AppDelegate ()<UNUserNotificationCenterDelegate,FIRMessagingDelegate> {
}


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch. 
    
#ifdef DEBUG
    USERDEFAULT_SET(@"serviceIP", SERVICE_SANDBOX);
#else  
    USERDEFAULT_SET(@"serviceIP", SERVICE_PRODUCT);
#endif
     
    
    [application setMinimumBackgroundFetchInterval:60];
    [self configSVProgressHUD]; 
    
     //   [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]]; 
        [[UINavigationBar appearance] setBarTintColor:[UIColor clearColor]]; 
        [[UINavigationBar appearance] lt_setBackgroundColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setShadowImage:[UIImage new]];
   // [[UINavigationBar appearance] setPrefersLargeTitles:YES];
        NSDictionary *attributes = @{NSForegroundColorAttributeName:COLOR_GRAY,
                                     NSFontAttributeName:[UIFont fontWithName:APP_FONT_NAME size:18]
                                     };
        [[UINavigationBar appearance] setTitleTextAttributes: attributes]; 
     
        //将返回按钮的文字position设置不在屏幕上显示   
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0)
                                                             forBarMetrics:UIBarMetricsDefault]; 
        
        
        
        [self configVendersForApplication:application withOptions:launchOptions];
        
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        [[NSUserDefaults standardUserDefaults] setBool:kUSER_LOGIN_STATE!=LoginStateNO forKey:@"openNotificationDetail"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self receiveNotification:remoteNotification];
    }
   
 
    SET_AUTOM_REFRESH_POPULAR(NO); 
    SET_AUTOM_REFRESH_HOME(0, NO);
    SET_AUTOM_REFRESH_HOME(1, NO);
    SET_AUTOM_REFRESH_HOME(2, NO);
    
    
#ifdef NSFoundationVersionNumber_iOS_8_x_Max
  //  [self set3DTouch:application];
#endif
    
    return YES;
}
#ifdef NSFoundationVersionNumber_iOS_8_x_Max
-(void)set3DTouch:(UIApplication *)application{
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:@"newType" localizedTitle:@"新增功能" localizedSubtitle:nil icon:icon1 userInfo:nil];
    application.shortcutItems = @[item1];
}
#endif
 

- (void)configVendersForApplication:(UIApplication *)application withOptions:(NSDictionary *)launchOptions{
//    //facebook 初始化
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    //goole place 地图服务
    [GMSPlacesClient provideAPIKey:GOOGLE_PLACE_KEY];
    
    //支付
    [BTAppSwitch setReturnURLScheme:kBRAINTREE_BUNDLEID];
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES]; 
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_APPKEY]; 
    [self configUSharePlatforms]; 
    [self confitUShareSettings];
    
    
    [self setNotification];
}

- (void)configUSharePlatforms{
    
}
- (void)confitUShareSettings{
    
    
    /* 设置Facebook的appKey和UrlString */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook 
                                          appKey:FACEBOOK_KEY 
                                       appSecret:FACEBOOK_APP_SECRET 
                                     redirectURL:nil];
    //    
//     /* 设置Twitter的appKey和appSecret */
//     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter 
//                                           appKey:TWITTER_KEY  
//                                        appSecret:TWITTER_APP_SECRET 
//                                      redirectURL:nil];
//     /* 设置Instagram 的appKey和appSecret */
//     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Instagram 
//                                           appKey:INSTAGRAM_KEY  
//                                        appSecret:INSTAGRAM_APP_SECRET 
//                                      redirectURL:nil];
    
}


- (void)setNotification{
    
#if TARGET_IPHONE_SIMULATOR  
    NSLog(@"run on simulator");  
    USERDEFAULT_SET_APNS_DEVICE_TOKEN(@"60e10e79424bf9f8b5f2c2512adeec6df8ae5039bae17fb42aac319ad7197a9e");
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
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
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
- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"FCM registration token: %@", fcmToken);
    
    
    // TODO: If necessary send token to application server.
}
// [START ios_10_data_message]
// Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
// To enable direct data messages, you can set [Messaging messaging].shouldEstablishDirectChannel to YES.
- (void)messaging:(FIRMessaging *)messaging didReceiveMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"Received data message: %@", remoteMessage.appData);
}
// [END ios_10_data_message]
// [START receive_message]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    NSLog(@"iOS6及以下系统，收到通知:%@", userInfo);

    [self receiveNotification:userInfo];
    // Print full message. 
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    NSLog(@"iOS7及以上系统，收到通知");
  
    
    // Print full message.
    NSLog(@"%d  %s",__LINE__,__FUNCTION__);
    [self receiveNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}
// [END receive_message]

- (void)receiveNotification:(NSDictionary *)notificationMsg{
    
    _notification = [NSDictionary dictionaryWithDictionary:notificationMsg];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if( [UIApplication sharedApplication].applicationState == UIApplicationStateActive)  { 
        NSLog(@"当APP在前台运行时，不做处理,收到通知：%@",notificationMsg);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidReceiveStateActiveNotification" object:nil];
        
        
    }else if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive){   
        NSLog(@"当APP在后台运行时，当有通知栏消息时，点击它，就会执行下面的方法跳转到相应的页面,收到通知：%@",notificationMsg);
        
        [[NSUserDefaults standardUserDefaults] setBool:kUSER_LOGIN_STATE!=LoginStateNO forKey:@"openNotificationDetail"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}  

//App处于前台接收通知时
// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    
    NSLog(@"%d  %s",__LINE__,__FUNCTION__);
    [self receiveNotification:userInfo];
    // Change this to your preferred presentation option
    completionHandler(UNNotificationPresentationOptionNone);
}


// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    NSLog(@"%d  %s",__LINE__,__FUNCTION__);
    [self receiveNotification:userInfo];
    completionHandler();
}
#endif
// [END ios_10_message_handling]



- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs device token can be paired to
// the FCM registration token.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"APNs device token retrieved: %@", deviceToken);
    
    // With swizzling disabled you must set the APNs device token here.
 //   [FIRMessaging messaging].APNSToken = deviceToken;
    NSString* newToken = [[[NSString stringWithFormat:@"%@",deviceToken]
                           stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"nsdata:%@\n 字符串token: %@",deviceToken, newToken);
    NSLog(@"newDeviceToken:%@",newToken);// get device token
    
    USERDEFAULT_SET_APNS_DEVICE_TOKEN(newToken);
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application 
            openURL:(NSURL *)url 
  sourceApplication:(NSString *)sourceApplication 
         annotation:(id)annotation
{
    NSLog(@"%s,%@",__func__,url.absoluteString); 
    if ([url.scheme localizedCaseInsensitiveCompare:kBRAINTREE_BUNDLEID] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url sourceApplication:sourceApplication];
    }
    
    return [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"%s,%@",__func__,url.absoluteString);
    if ([url.scheme localizedCaseInsensitiveCompare:kBRAINTREE_BUNDLEID] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url options:options];
    }
    
    return [[UMSocialManager defaultManager] handleOpenURL:url options:options];
}
//
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        if (error==nil && placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            
            if (place != nil) USERDEFAULT_COORDINATE_SET(place.coordinate);
        }
    }];
    if (kUSER_LOGIN_STATE) [XMPPService connectXMPP];
    
    [[SQLHelper sharedInstance] openSqlite];
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    [XMPPService disConnection];
    [[SQLHelper sharedInstance] closeSqlite];
} 

- (void)setOpenLog:(BOOL)openLog{
    _openLog = openLog;
    if (openLog) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.textView];
    }else{
        [self.textView removeFromSuperview];
    }
}

- (void)print:(id)obj{ 
     
    NSString *userName =kUSER_EMAIL;
    NSString *facebookId =kFACEBOOK_USERID;
    
    if (([userName isEqualToString:@"zhuming@126.com"]||
         [userName isEqualToString:@"koko@gmail.com"]||
         [userName isEqualToString:@"aa@gmail.com"]||
         [userName isEqualToString:@"yy@gmail.com"]||
         [userName isEqualToString:@"lx_java@foxmail.com"]||
         [facebookId isEqualToString:@"928387593981774"]) &&_openLog) {
         
        self.textView.text = [NSString stringWithFormat:@"%@\n----------------------------------------------\n%@",self.textView.text,obj];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
        NSLog(@"----[-----");
    }
}
//
- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 200, TX_SCREEN_WIDTH-20, 400)];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.alpha = 0.7;
        _textView.delegate = self;
        _textView.editable = YES;  
        _textView.textColor = [UIColor whiteColor];
        _textView.layoutManager.allowsNonContiguousLayout = NO;
      //  _textView.userInteractionEnabled = NO   ;
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(textViewLongPressed:)];
       [_textView addGestureRecognizer:longGesture];
    }
    return _textView;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}


CGPoint startPoint;
CGPoint originPoint;
- (void)textViewLongPressed:(UILongPressGestureRecognizer *)sender{
    UITextView *textView = (UITextView *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        startPoint = [sender locationInView:sender.view];
        originPoint = textView.center;
        [UIView animateWithDuration:0.2 animations:^{
            textView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            textView.alpha = 0.2;
        }];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        textView.center = CGPointMake(textView.center.x+deltaX,textView.center.y+deltaY);
        //NSLog(@"center = %@",NSStringFromCGPoint(btn.center));
        [UIView animateWithDuration:0.2 animations:^{
            
            CGPoint temp = CGPointZero; 
            temp = textView.center;
            textView.center = originPoint;
            textView.center = temp;
            originPoint = textView.center;
          //  contain = YES;
            
        }];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            textView.transform = CGAffineTransformIdentity;
            textView.alpha = 0.7;
            textView.center = originPoint;
        }];
    }
    
     
}

@end

