//
//  EventCancelCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "EventCancelCell.h"

@implementation EventCancelCell

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
