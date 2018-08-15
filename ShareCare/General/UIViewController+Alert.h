//
//  UIViewController+Alert.h
//  ShareCare
//
//  Created by 朱明 on 2018/3/16.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

typedef void(^AlertCancelBlock)(void);
typedef void(^AlertConfirmBlock)(NSString *text);


- (void)showSystemAlertTitle:(NSString *)title
                     content:(NSString *)content
                 confirmText:(NSString *)confirmText
                  cancelText:(NSString *)cancelText
                     confirm:(AlertConfirmBlock)confirmBlock;

- (void)showSystemInputAlertTitle:(NSString *)title
                          content:(NSString *)content
                      placeHolder:(NSString *)placeholder
                      confirmText:(NSString *)confirmText
                       cancelText:(NSString *)cancelText
                          confirm:(AlertConfirmBlock)confirmBlock;
@end
