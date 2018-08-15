//
//  UIViewController+KeyboardState.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/18.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (KeyboardState) 

@property (strong, nonatomic) UIScrollView *targetScrollView;
@property (strong, nonatomic) NSString *offset_x;

- (void)setKeyboardNotificationWith:(UIScrollView *)scrollView;

@end
