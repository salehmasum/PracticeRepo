//
//  BookingAddressCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BookingAddressCell.h"

@implementation BookingAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)getDirection:(id)sender {
    
    if (_getDirectionBlock) {
        _getDirectionBlock(_lon,_lat);
    }
}

@end
