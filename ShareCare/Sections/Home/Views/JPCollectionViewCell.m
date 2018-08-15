//
//  JPCollectionViewCell.m
//  JPAnimation
//
//  Hello! I am NewPan from Guangzhou of China, Glad you could use my framework, If you have any question or wanna to contact me, please open https://github.com/Chris-Pan or http://www.jianshu.com/users/e2f2d779c022/latest_articles
//

#import "JPCollectionViewCell.h"
#import "JPAnimationTool.h"

@interface JPCollectionViewCell()

@end


@implementation JPCollectionViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    // 给显示封面的这个 imageView 加一个 tag.
    self.coverImageView.tag = JPCoverImageViewTag;
    //self.coverImageView.backgroundColor = TX_RGB(250, 250, 250);
}

-(void)setDataString:(NSString *)dataString{
    _dataString = dataString;
     
}
- (IBAction)favorite:(id)sender {
    if (_delegate) {
        [_delegate collectionViewDidFavoriteItemIndexPath:[NSIndexPath indexPathForRow:_row inSection:0] forCell:self];
    }
}

- (void)configPrice:(NSString *)priceStr location:(NSString *)location{ 
    NSString *str = [NSString stringWithFormat:@"%@ %@",priceStr,location];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = [str rangeOfString:priceStr];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(15)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:range];
    
    range = [str rangeOfString:@"$"];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_BOLD_FONT(13)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:range];
    
    range = [str rangeOfString:location];
    [attrStr addAttribute:NSFontAttributeName
                    value:TX_FONT(11)
                    range:range];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:TX_RGB(136, 136, 136)
                    range:range];
    
    self.lbPrice.attributedText = attrStr;
    
}

@end
