//
//  UIViewController+Alert.m
//  ShareCare
//
//  Created by 朱明 on 2018/3/16.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)showSystemInputAlertTitle:(NSString *)title
                          content:(NSString *)content
                      placeHolder:(NSString *)placeholder
                      confirmText:(NSString *)confirmText
                       cancelText:(NSString *)cancelText
                          confirm:(AlertConfirmBlock)confirmBlock{
    
    UIAlertController *alertController = [self createAlertTitle:title content:content confirmText:confirmText cancelText:cancelText confirm:confirmBlock];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = placeholder;
        textField.keyboardType = UIKeyboardTypeEmailAddress;
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)showSystemAlertTitle:(NSString *)title
                     content:(NSString *)content
                 confirmText:(NSString *)confirmText
                  cancelText:(NSString *)cancelText
                     confirm:(AlertConfirmBlock)confirmBlock{
    UIAlertController *alertController = [self createAlertTitle:title content:content confirmText:confirmText cancelText:cancelText confirm:confirmBlock];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (UIAlertController *)createAlertTitle:(NSString *)title
                                content:(NSString *)content
                            confirmText:(NSString *)confirmText
                             cancelText:(NSString *)cancelText
                                confirm:(AlertConfirmBlock)confirmBlock{
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:title 
                                          message:content
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelText) { 
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelText 
                                                               style:UIAlertActionStyleCancel 
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                             }];
        [alertController addAction:cancelAction];
    }
    
    if (confirmText) { 
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:confirmText 
                                                           style:UIAlertActionStyleDefault 
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             UITextField *textField = alertController.textFields.firstObject;
                                                             if (confirmBlock) confirmBlock(textField?textField.text:nil);
                                                         }];
        
        [alertController addAction:okAction];
    }
    return alertController;
}


@end

