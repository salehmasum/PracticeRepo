//
//  SVProgressHUD+Error.m
//  ShareCare
//
//  Created by 朱明 on 2018/3/19.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "SVProgressHUD+Error.h"

@implementation SVProgressHUD (Error)
+ (void)showErrorWithStatus:(NSString*)status{
    [self dismiss];
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:@"" 
                                          message:status
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" 
                                                           style:UIAlertActionStyleCancel 
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                         }];
    [alertController addAction:cancelAction];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}
@end
