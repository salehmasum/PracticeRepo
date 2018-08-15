//
//  UIButton+Font.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/4.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "UIButton+Font.h"
#import <objc/runtime.h>

@implementation UIButton (Font)
+ (void)load
{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}
 
- (id)myInitWithCoder:(NSCoder*)aDecode
{
    [self myInitWithCoder:aDecode];
    if (self) {
        [self resetFont];
    }
    return self;
}



- (void)resetFont{
    CGFloat fontSize = self.titleLabel.font.pointSize; 
    NSString *fontName =  self.titleLabel.font.fontName;
    self.titleLabel.font = [UIFont fontWithName:fontName size:fontSize*TX_SCREEN_OFFSET];//TX_FONT(fontSize);
    
}

@end
