//
//  UIViewController+login.h
//  ShareCare
//
//  Created by 朱明 on 2018/1/2.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPService.h"

@interface UIViewController (login)
- (void)loginForState:(LoginState)state;
- (void)loginRequestSuccess;
@end
