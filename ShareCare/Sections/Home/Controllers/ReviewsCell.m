//
//  ReviewsCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ReviewsCell.h"

@implementation ReviewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgPersonHeader.layer.masksToBounds = YES;
    self.imgPersonHeader.layer.cornerRadius = CGRectGetWidth(self.imgPersonHeader.frame)/2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)reportActio:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(reviewCellDidReport:)]) {
        [_delegate reviewCellDidReport:self.reviewId];
    }
}

- (void)configIcon:(NSString *)path userName:(NSString *)name time:(NSString *)time content:(NSString *)content{
    [_imgPersonHeader setImageWithURL:[NSURL URLWithString:URLStringForPath(path)] placeholderImage:kDEFAULT_HEAD_IMAGE];
    _lbName.text = name;
    _lbReview.text = content;
    
    
    NSDateFormatter *dateFormatter = [Util dateFormatter] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:time];
    
//    time = [NSDateFormatter localizedStringFromDate:date 
//                                           dateStyle:NSDateFormatterLongStyle 
//                                           timeStyle:NSDateFormatterNoStyle]; 
    
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  
    time = [dateFormatter stringFromDate:date];
    _lbTime.text = time;
}

@end
