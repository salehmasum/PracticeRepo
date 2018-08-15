//
//  HeadImage.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeadImage : NSObject
+ (UIImage*)imageWithFrame:(CGRect)frame BackGroundColor:(UIColor*)backGroundColor Text:(NSString*)text TextColor:(UIColor*)textColor TextFontOfSize:(CGFloat)size;

@end
@interface HeadImageView : UIView
- (id)initWithFrame:(CGRect)frame BackGroundColor:(UIColor*)backGroundColor Text:(NSString*)text TextColor:(UIColor*)textColor TextFontOfSize:(CGFloat)size;

@end
