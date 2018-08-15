//
//  EventsRangeCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "EventsRangeCell.h"

@interface EventsRangeCell()

@property (weak, nonatomic) IBOutlet UIButton *btnRemaining;
@property (weak, nonatomic) IBOutlet UIButton *btnMaxAttendees;
@property (weak, nonatomic) IBOutlet UIButton *btnAgeRange;
@end

@implementation EventsRangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRemainingPlace:(NSString *)remainingPlace{
    _remainingPlace = remainingPlace;
    [_btnRemaining setTitle:remainingPlace forState:UIControlStateNormal];
}
- (void)setMaxAttendees:(NSString *)maxAttendees{
    _maxAttendees = maxAttendees;
    [_btnMaxAttendees setTitle:maxAttendees forState:UIControlStateNormal];
    
}
- (void)setAgeRange:(NSString *)ageRange{
    _ageRange = ageRange;
     [_btnAgeRange setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    if ([ageRange containsString:@" and under"]) {
        
        [_btnAgeRange setTitle:[ageRange stringByReplacingOccurrencesOfString:@" and under" withString:@""] forState:UIControlStateNormal];
        [_btnAgeRange setImage:[UIImage imageNamed:@"under-blue"] forState:UIControlStateNormal];
    }
    if ([ageRange containsString:@" and over"]) {
        [_btnAgeRange setTitle:[ageRange stringByReplacingOccurrencesOfString:@" and over" withString:@""] forState:UIControlStateNormal];
        [_btnAgeRange setImage:[UIImage imageNamed:@"over-blue"] forState:UIControlStateNormal];
    }
    CGFloat labelWidth = _btnAgeRange.titleLabel.intrinsicContentSize.width; //注意不能直接使用titleLabel.frame.size.width,原因为有时候获取到0值
    CGFloat imageWidth = _btnAgeRange.imageView.frame.size.width;
    CGFloat space = 5.f; //定义两个元素交换后的间距
    
    _btnAgeRange.titleEdgeInsets = UIEdgeInsetsMake(0, - imageWidth - space,0,imageWidth + space);
    _btnAgeRange.imageEdgeInsets = UIEdgeInsetsMake(8, labelWidth + space, 0,  -labelWidth - space);
    NSString *str = _btnAgeRange.titleLabel.text;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = [str rangeOfString:@"yrs"];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(14)
                    range:range]; 
    _btnAgeRange.titleLabel.attributedText = attrStr;
}
@end
