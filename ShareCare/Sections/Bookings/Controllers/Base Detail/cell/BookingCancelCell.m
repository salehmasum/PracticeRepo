//
//  BookingCancelCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BookingCancelCell.h"

@implementation BookingCancelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)cancel:(id)sender {
    if (_cancelBlock) {
        _cancelBlock();
    }
}

@end
