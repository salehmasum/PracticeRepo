//
//  MessagesVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "MessagesVC.h" 
#import "MNotificationsVC.h"
#import "MMessagesVC.h"

@interface MessagesVC (){
}

@property(strong, nonatomic) MNotificationsVC *notificationVC;
@property(strong, nonatomic) MMessagesVC *messageVC;
@end

@implementation MessagesVC
 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.segScroll.scrollEnabled = NO;
}

- (MNotificationsVC *)notificationVC{
    if (!_notificationVC) {
        _notificationVC = [[MNotificationsVC alloc] init];
    }
    return _notificationVC;
}
- (MMessagesVC *)messageVC{
    if (!_messageVC) {
        _messageVC = [[MMessagesVC alloc] init];
    }
    return _messageVC;
}
- (void)animationEndIndex:(NSInteger)index{
    
}

- (void)didSelectedIndex:(NSInteger)index{
    if (index == 0) {
        [self.messageVC setMessageBlockNil];
        [self.notificationVC initData];
    }else{
        [self.messageVC initData];
        [self.notificationVC setMessageBlockNil];
    }
}
#pragma mark --------------------------------------------------
#pragma mark Setup

- (NSArray *)vcArr{   
    return @[self.notificationVC,self.messageVC];
}
- (NSString *)navTitle{
    return CustomLocalizedString(@"Inbox", @"home");
}
- (NSArray *)menuItems{
    return @[CustomLocalizedString(@"NOTIFICATIONS", @"Messages"),
             CustomLocalizedString(@"MESSAGES", @"Messages")
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
