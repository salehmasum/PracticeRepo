//
//  UILabel+Font.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/4.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "UILabel+Font.h" 
#import <objc/runtime.h>

@implementation UILabel (Font)



+ (void)load
{
    {
        Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
        Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
        method_exchangeImplementations(imp, myImp);
    }
    
   
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
    CGFloat fontSize = self.font.pointSize;
    NSString *fontName =  self.font.fontName;
    self.font = [UIFont fontWithName:fontName size:fontSize*TX_SCREEN_OFFSET];//TX_FONT(fontSize);
    
}

@end
