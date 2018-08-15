//
//  ChatViewController.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKFPreViewNavController.h"

@interface ChatViewController : UIViewController<UITextFieldDelegate>

@property (strong,nonatomic) NSString *toUser;//用户id
@property (strong,nonatomic) NSString *toUserName;
@property (strong,nonatomic) NSString *toUserIcon;

@end
