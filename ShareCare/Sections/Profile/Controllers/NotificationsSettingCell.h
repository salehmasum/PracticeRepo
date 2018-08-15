//
//  NotificationsSettingCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@protocol NotificationSettingDelegate <NSObject>

- (void)resetNotificationStatus:(BOOL)status forKey:(NSString *)key withSwitch:(UISwitch *)switchView;

@end
@interface NotificationsSettingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbDesc;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@property (strong, nonatomic) NSString *key;
@property (assign, nonatomic) id<NotificationSettingDelegate>delegate;
@end
