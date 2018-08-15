//
//  NotificationsSettingCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "NotificationsSettingCell.h"

@implementation NotificationsSettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _switchView.onTintColor = TX_RGB(62, 172, 255);
    // 控件大小，不能设置frame，只能用缩放比例
    _switchView.transform = CGAffineTransformMakeScale(0.75, 0.75);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)switchDidValueChanged:(UISwitch *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(resetNotificationStatus:forKey:withSwitch:)]) {
        [_delegate resetNotificationStatus:sender.on forKey:self.key withSwitch:sender];
    }
}

@end
