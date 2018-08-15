//
//  AppDelegate.h
//  ShareCare
//
//  Created by 朱明 on 17/8/4.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITextViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) NSDictionary *notification;
- (void)setNotification;


@property (assign, nonatomic) BOOL openLog;
@property (assign, nonatomic) BOOL openLogResult;
- (void)print:(id)obj;
@end

