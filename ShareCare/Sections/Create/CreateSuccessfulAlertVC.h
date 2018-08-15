//
//  CreateSuccessfulAlertVC.h
//  ShareCare
//
//  Created by 朱明 on 2018/3/20.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h> 

typedef void(^CreateSuccessfulAlertBlock)(void);

@interface CreateSuccessfulAlertVC : UIViewController
- (void)showAlertInview:(UIView *)target confirm:(CreateSuccessfulAlertBlock)confirmBlock;

@end
