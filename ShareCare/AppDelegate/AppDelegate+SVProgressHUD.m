//
//  AppDelegate+SVProgressHUD.m
//  ShareCare
//
//  Created by 朱明 on 2018/4/19.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "AppDelegate+SVProgressHUD.h"

@implementation AppDelegate (SVProgressHUD)

- (void)configSVProgressHUD{
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
    [SVProgressHUD setForegroundColor:[UIColor blackColor]]; //字体颜色
    [SVProgressHUD setBackgroundColor:TX_COLOR_FROM_RGB(0xececec)];//背景颜色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
   // [SVProgressHUD setMaxSupportedWindowLevel:UIWindowLevelAlert];

    [SVProgressHUD resetOffsetFromCenter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:SVProgressHUDDidReceiveTouchEventNotification
                                               object:nil];
}
- (void)handleNotification:(NSNotification *)notification { 
    
    if([notification.name isEqualToString:SVProgressHUDDidReceiveTouchEventNotification]){
//        [SVProgressHUD dismiss];
//        [ShareCareHttp cancelAllRequest];
    }
}
@end
