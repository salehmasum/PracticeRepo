//
//  DeclineReasonCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "DeclineReasonCell.h"

@implementation DeclineReasonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)layoutSubviews{
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.layer.cornerRadius = CGRectGetHeight(self.userIcon.frame)/2.0; 
    UIImage *image =_backgroundImageView.image;
    UIImage*newImage = [image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.5];
    _backgroundImageView.image = newImage;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
