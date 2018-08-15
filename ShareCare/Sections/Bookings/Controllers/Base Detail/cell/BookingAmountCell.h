//
//  BookingAmountCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingAmountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbAmount;

@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbBookingCode;
@property (weak, nonatomic) IBOutlet UILabel *lbBookingCodeTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgBottomLine;
@end
