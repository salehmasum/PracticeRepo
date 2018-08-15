//
//  MMessageCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMessageCell : UITableViewCell

//消息状态
@property (weak, nonatomic) IBOutlet UIImageView *notificationStatusImageView;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//名字
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
//服务类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
