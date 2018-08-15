//
//  CheckAvailabilityCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "CheckAvailabilityCell.h"

@implementation CheckAvailabilityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deletedClick:(id)sender {
    _deletedBlock();
    
}
@end
