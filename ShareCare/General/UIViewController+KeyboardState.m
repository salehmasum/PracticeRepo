//
//  UIViewController+KeyboardState.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/18.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "UIViewController+KeyboardState.h"
#import "objc/runtime.h"

 static  char viewKey;
static  char offsetKey;

@implementation UIViewController (KeyboardState)



- (void)setKeyboardNotificationWith:(UIScrollView *)scrollView{
    self.targetScrollView = scrollView;
    self.offset_x = @"100";
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)setOffset_x:(NSString *)offset_x{
    objc_setAssociatedObject(self, &offsetKey, offset_x,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)offset_x{
    return objc_getAssociatedObject(self, &offsetKey);
}
- (void)setTargetScrollView:(UIScrollView *)targetScrollView{
    objc_setAssociatedObject(self, &viewKey, targetScrollView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
 
- (UIScrollView *)targetScrollView{
    return objc_getAssociatedObject(self, &viewKey);
}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    self.targetScrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardRect.size.height+[self.offset_x floatValue], 0);
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度 
    
    self.targetScrollView.contentInset = UIEdgeInsetsZero;
} 
 
 
@end
