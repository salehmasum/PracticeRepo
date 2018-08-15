//
//  BookingCancelCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BookingsCacenlBlock)(void);
@interface BookingCancelCell : UITableViewCell
@property (strong,nonatomic)BookingsCacenlBlock cancelBlock;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@end
