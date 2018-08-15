//
//  BaseCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell
+ (instancetype)cellWithTableView:(UITableView *)tableView 
                       identifier:(NSString *)dentifierStr{
    // 1.缓存中取
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:dentifierStr];
    // 2.创建
    if (cell == nil) {
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dentifierStr]; 
    }
    return cell;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];   
    return YES;
}

@end
