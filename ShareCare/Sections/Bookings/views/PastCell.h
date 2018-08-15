//
//  PastCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BookingPastSelectedBlock)(id object);

@interface PastCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbCaretype;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (strong, nonatomic) BookingPastSelectedBlock selectedBlock;

@property (assign, nonatomic) NSInteger row;

- (void)configStartDate:(NSString *)start endDate:(NSString *)end;

@end
