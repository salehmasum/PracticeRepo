//
//  BaseCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell<UITextFieldDelegate>
+ (instancetype)cellWithTableView:(UITableView *)tableView 
                       identifier:(NSString *)dentifierStr;
@end
