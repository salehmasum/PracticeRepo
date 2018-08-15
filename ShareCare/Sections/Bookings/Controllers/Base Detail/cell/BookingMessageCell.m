//
//  BookingMessageCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BookingMessageCell.h"

@implementation BookingMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _imgheader.layer.masksToBounds = YES;
    _imgheader.layer.cornerRadius = CGRectGetWidth(_imgheader.frame)/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)toMessage:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(contactShareCarer)]) {
        [_delegate contactShareCarer];
    }
}


- (void)setUserName:(NSString *)userName{
    _userName = userName;
    
    _lbTitle.text = [NSString stringWithFormat:@"%@ is your EleCarer",userName];
    _lbDesc.text = [NSString stringWithFormat:@"Contact %@ if you have any questions.",userName];
     
}

@end
