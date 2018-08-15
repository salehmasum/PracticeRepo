//
//  BookingRequestCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/20.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDateTile;
@property (weak, nonatomic) IBOutlet UILabel *lbTimeTitle;

@end
