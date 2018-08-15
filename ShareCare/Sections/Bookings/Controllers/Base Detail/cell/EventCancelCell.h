//
//  EventCancelCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BookingsEventCacenlBlock)(void);
@interface EventCancelCell : UITableViewCell
@property (strong,nonatomic)BookingsEventCacenlBlock cancelBlock;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;

@end
