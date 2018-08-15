//
//  ChildrensSelectedCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/17.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ChildrensSelectedCell.h"

@implementation ChildrensSelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code 
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = CGRectGetWidth(self.icon.frame)/2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
