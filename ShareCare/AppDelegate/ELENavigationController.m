//
//  ELENavigationController.m
//  ShareCare
//
//  Created by 朱明 on 2018/4/23.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "ELENavigationController.h"

@implementation ELENavigationController


- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    [SVProgressHUD dismiss];
    NSLog(@"-------------------popViewControllerAnimated");
    return [super popViewControllerAnimated:animated];
}

@end
