//
//  MMessageCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "MMessageCell.h"

@implementation MMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = CGRectGetHeight(self.headImageView.frame)/2.0; 
    self.headImageView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
