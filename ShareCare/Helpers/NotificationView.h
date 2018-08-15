//
//  NotificationView.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationView : UIView

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *lbName;
@property (strong, nonatomic) UILabel *lbContent;

- (void)show;

@end
