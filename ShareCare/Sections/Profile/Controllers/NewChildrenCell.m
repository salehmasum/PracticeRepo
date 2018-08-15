//
//  NewChildrenCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/24.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "NewChildrenCell.h"

@implementation NewChildrenCell

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

- (IBAction)editName:(id)sender {
    _editNameBlock();
}

- (IBAction)editAge:(id)sender {
    _editAgeBlock();
}

- (IBAction)editGender:(id)sender {
    _editGenderBlock();
}
- (IBAction)editEmergencyContact:(id)sender {
    _editPhoneBlock();
}
@end
