//
//  SignUpCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "SignUpCell.h"

@implementation SignUpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"cell");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        _label = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, TX_SCREEN_WIDTH-40, 30*TX_SCREEN_OFFSET)];
        _label.font = TX_FONT(18);
        _label.textColor = COLOR_WHITE; 
        [self.contentView addSubview:_label];
        
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(20, 32, TX_SCREEN_WIDTH-40, 46*TX_SCREEN_OFFSET);
        _textField.tintColor = COLOR_WHITE;
//        _textField.backgroundColor = TX_RGBA(255, 255, 255, 0.2);
        _textField.layer.masksToBounds = YES;
//        _textField.layer.borderColor = COLOR_WHITE.CGColor;
//        _textField.layer.borderWidth = 1.0;
        _textField.font = TX_FONT(20);
        _textField.delegate = self;
        _textField.textColor = COLOR_WHITE;
        _textField.layer.cornerRadius = CGRectGetHeight(_textField.frame)/2.0;
        [_textField setAutocorrectionType:UITextAutocorrectionTypeNo]; 
        [_textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_textField addTarget:self action:@selector(textFieldDidValueChenged:) forControlEvents:UIControlEventEditingChanged];
        
        
        UIImageView *textFieldImageView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 32, 330*TX_SCREEN_OFFSET, 47*TX_SCREEN_OFFSET)];
        textFieldImageView.image = [UIImage imageNamed:@"text-field"];
     //   textFieldImageView.frame = _textField.frame;
        textFieldImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:textFieldImageView];
        

        [self addSubview:_textField];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _textField.leftView = view;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        
        
    } 
    return self;
}
  
- (void)textFieldDidValueChenged:(UITextField *)textField{
    //_inputTextBlock(textField.text);
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _inputTextBlock(textField.text);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
