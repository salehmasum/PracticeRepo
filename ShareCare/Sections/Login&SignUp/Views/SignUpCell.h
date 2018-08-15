//
//  SignUpCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"


typedef void(^SignupCellInputTextBlock)(NSString *text);

@interface SignUpCell : BaseCell 

@property(strong, nonatomic) UILabel *label;
@property(strong, nonatomic) UITextField *textField;

@property (strong, nonatomic) SignupCellInputTextBlock inputTextBlock;
 
@end
