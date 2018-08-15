//
//  ShareCarePaymentCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ShareCarePaymentCell.h"

@implementation ShareCarePaymentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)edit:(id)sender {
    if (_editBlock) {
        _editBlock(self.row);
    }
}
@end
