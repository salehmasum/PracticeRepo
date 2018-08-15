//
//  FavoriteCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "FavoriteCell.h"

@implementation FavoriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setPrice:(NSString *)price{ 
    _price = price;
    NSString *str = price;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = [str rangeOfString:price];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(18)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:range];
    
    range = [str rangeOfString:@"$"];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(15)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:range];
    
    self.lbPrice.attributedText = attrStr;
    
}
@end
