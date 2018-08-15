//
//  HIteminfoCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HIteminfoCell.h"

@implementation HIteminfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
     
    [self addSubview:self.infinitePageView];
    [self addSubview:self.imgPersonHeader];
    self.imgPersonHeader.center = CGPointMake(TX_SCREEN_WIDTH-60, CGRectGetMaxY(self.infinitePageView.frame));
    self.infinitePageView.placeholderImage = kDEFAULT_IMAGE;
    self.infinitePageView.delegate = self; 
    self.imgPersonHeader.contentMode = UIViewContentModeScaleAspectFill;
}

- (BHInfiniteScrollView *)infinitePageView{
    if (_infinitePageView == nil) {
        _infinitePageView = [[BHInfiniteScrollView alloc] initWithFrame:CGRectMake(0, -5-20*iSiPhoneX, TX_SCREEN_WIDTH, 255*TX_SCREEN_OFFSET)];
    }
    return _infinitePageView;
}

- (UIImageView *)imgPersonHeader{
    if (!_imgPersonHeader) {
        _imgPersonHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70*TX_SCREEN_OFFSET, 70*TX_SCREEN_OFFSET)];
        _imgPersonHeader.layer.masksToBounds = YES;
        _imgPersonHeader.layer.cornerRadius = CGRectGetWidth(self.imgPersonHeader.frame)/2.0;
        _imgPersonHeader.layer.borderColor = [UIColor whiteColor].CGColor;
        _imgPersonHeader.layer.borderWidth = 2;
    }
    return _imgPersonHeader;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index{
    _selectedIndexBlock(index);
}

@end
