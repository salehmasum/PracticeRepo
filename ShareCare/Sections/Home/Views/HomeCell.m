//
//  HomeCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

- (void)drawRect:(CGRect)rect{
   }

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) { 
       
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.starView setScorePercent:0.8];
    self.headPortraitView.layer.masksToBounds = YES;
    self.headPortraitView.layer.cornerRadius = CGRectGetHeight(self.headPortraitView.frame)/2.0;
    self.headPortraitView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headPortraitView.layer.borderWidth = 2;
    self.starView.userInteractionEnabled = NO;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configPrice:(NSString *)priceStr location:(NSString *)location careType:(NSInteger)type{ 
    
    _roleType = type;
//    if (type == 2) {
//        
//        priceStr = [NSString stringWithFormat:@"%@",priceStr.floatValue==0?@"FREE for kids":[NSString stringWithFormat:@"$%@",priceStr]];
//    }
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",priceStr,location];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = [str rangeOfString:priceStr];
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
    
    range = [str rangeOfString:location];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(14)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:TX_RGB(136, 136, 136)
                    range:range];
    
    self.lbHeadline.attributedText = attrStr;
    
}
- (IBAction)favoriteAction:(id)sender {
    if (_delegate) {
        [_delegate tableViewCell:self didFavoriteAtIndexPath:_indexPath];
    }
}

@end
