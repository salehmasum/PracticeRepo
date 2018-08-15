//
//  CheckAvailabilityView.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "CheckAvailabilityView.h"

@interface CheckAvailabilityView()

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;


@end

@implementation CheckAvailabilityView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)check:(id)sender {
    _checkAvailablityBlock();
}

- (void)configPrice:(NSString *)priceStr location:(NSString *)location careType:(NSInteger)type{
    if (type == 2) {
//        priceStr = location;
//        location = @"";
     //   priceStr = [NSString stringWithFormat:@"%@",priceStr.floatValue==0?@"FREE for kids":[NSString stringWithFormat:@"$%@",priceStr]];
    }
    NSString *str = [NSString stringWithFormat:@"%@ %@",priceStr,location];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = [str rangeOfString:priceStr];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(16)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:range];
    
    range = [str rangeOfString:@"$"];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(14)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:range];
    
    range = [str rangeOfString:location];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(13)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:TX_RGB(136, 136, 136)
                    range:range];
    
    self.lbPrice.attributedText = attrStr;
    
}
@end
