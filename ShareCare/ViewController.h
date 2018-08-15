//
//  ViewController.h
//  ShareCare
//
//  Created by 朱明 on 17/8/4.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "XMPPManager.h"
#import "XMPPService.h"
#import "UIViewController+login.h"
#import "RigisterAlertViewController.h"

@interface ViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *instructTextView;

@end

