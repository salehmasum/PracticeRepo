//
//  RigisterAlertViewController.h
//  ShareCare
//
//  Created by 朱明 on 2018/1/10.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView_Clinkle/FXBlurView.h>

typedef void(^AlertViewControllerGoBackBlock)(void);
typedef void(^AlertViewControllerContinueBlock)(void);


@interface RigisterAlertViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *instructTextView;
@property (weak, nonatomic) IBOutlet UIView *blurView;

@property (strong, nonatomic) AlertViewControllerGoBackBlock goBackBlock;
@property (strong, nonatomic) AlertViewControllerContinueBlock continueBlock;


- (void)showAlertInview:(UIView *)target goBack:(AlertViewControllerGoBackBlock)goBackBlock
               continueClick:(AlertViewControllerContinueBlock)continueBlock;

@end
