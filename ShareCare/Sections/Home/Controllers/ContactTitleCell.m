//
//  ContactTitleCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ContactTitleCell.h"

@implementation ContactTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _lbTitle.textColor = COLOR_BLUE;
    _starView.scorePercent = 0.6;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)contact:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(contactShareCarer)]) {
        [_delegate contactShareCarer];
    }
}

@end
