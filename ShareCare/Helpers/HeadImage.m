//
//  HeadImage.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HeadImage.h"

@implementation HeadImage
+ (UIImage *)imageWithFrame:(CGRect)frame BackGroundColor:(UIColor *)backGroundColor Text:(NSString *)text TextColor:(UIColor *)textColor TextFontOfSize:(CGFloat)size{
    //初始化并绘制UI
    HeadImageView *view = [[HeadImageView alloc] initWithFrame:frame BackGroundColor:backGroundColor Text:text TextColor:textColor TextFontOfSize:size];
    
    //转化成image
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}
@end
@implementation HeadImageView

- (id)initWithFrame:(CGRect)frame BackGroundColor:(UIColor *)backGroundColor Text:(NSString *)text TextColor:(UIColor *)textColor TextFontOfSize:(CGFloat)size{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backView = [[UIView alloc] initWithFrame:frame];
        backView.backgroundColor = backGroundColor;
        [self addSubview:backView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = text;
        label.textColor = textColor;
        label.backgroundColor = backGroundColor;
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:size];
        [backView addSubview:label];
    }
    return self;
}


@end
