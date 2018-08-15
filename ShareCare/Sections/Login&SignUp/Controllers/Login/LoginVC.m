//
//  LoginVC.m
//  ShareCare
//
//  Created by 朱明 on 17/8/4.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "LoginVC.h"
#import "MainTabBarController.h"  
#import "XMPPService.h"
#import "UIViewController+Alert.h"
#import "ForgotPasswordVC.h"
@interface LoginVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation LoginVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
 //   [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
} 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.accountTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.accountTextField setAutocorrectionType:UITextAutocorrectionTypeNo]; 
    [self.accountTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    self.passwordTextField.secureTextEntry = YES; 
    self.bgImageView.image = [UIImage imageNamed:MAIN_BACKGROUND_IMAGENAME];
    
    self.accountTextField.text = kUSER_EMAIL;
  //  self.passwordTextField.text = @"123456";

    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue]; 
    
    
    CGRect rect = self.view.frame;
    rect.origin.y = -60;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = rect;
        self.titleLabel.alpha = 0;
        //  self.forgotPasswordBtn.alpha = 0;
        self.topLine.center = CGPointMake(TX_SCREEN_WIDTH/2,SYSTEM_NAVIGATIONBAR_HEIGHT-rect.origin.y+24*iSiPhoneX);
        
        self.topLine.alpha = 1;
    } completion:^(BOOL finished) {
    }]; 
    
    
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = rect;
        self.titleLabel.alpha = 1;
        self.forgotPasswordBtn.alpha = 1;
        
        self.topLine.center = CGPointMake(TX_SCREEN_WIDTH/2,SYSTEM_NAVIGATIONBAR_HEIGHT-rect.origin.y);
        self.topLine.alpha = 0;
        //  self.nextBtn.alpha = 0;
    } completion:^(BOOL finished) { 
    }]; 
}

- (IBAction)nextAction:(id)sender { 
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    NSString *account = self.accountTextField.text;
    NSString *pw = self.passwordTextField.text;
    if (![Util validateEmail:account]) {
        [SVProgressHUD showErrorWithStatus:CustomLocalizedString(@"Invalid email address", @"login")];
        return;
    }
    if (pw.length == 0) {
        [SVProgressHUD showErrorWithStatus:CustomLocalizedString(@"Invalid password", @"login")];
        return;
    } 
    if (pw.length<MIN_CHARACTERS) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"The password  length is not less than %d characters",MIN_CHARACTERS]];
        return;
    } 
    
    USERDEFAULT_SET(@"email", self.accountTextField.text);
    USERDEFAULT_SET(@"password", self.passwordTextField.text);
    [self loginForState:LoginStateEmail];
    
 
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)forgotPassworAction:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)handleError:(NSString *)error{
    
    
    
    if ([error isEqualToString:@"User not exist"]) {
        [SVProgressHUD dismiss]; 
        [self showSystemAlertTitle:@"User does not exist" 
                           content:@"The email address you have submitted does not exist. Please re-enter email." 
                       confirmText:@"Re-Submit" 
                        cancelText:@"OK" 
                           confirm:^(NSString *text) {
                               [self loginForState:LoginStateEmail];
                           }];
    }else if ([error isEqualToString:@"Password wrong"]) {
        [SVProgressHUD dismiss]; 
        [self showSystemAlertTitle:@"Incorrect Email or Password" 
                           content:@"The email address or password you have submitted in incorrect. Please try again." 
                       confirmText:@"Forgot Password?" 
                        cancelText:@"OK" 
                           confirm:^(NSString *text) { 
                                
                               UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
                               ForgotPasswordVC *vc = (ForgotPasswordVC *)[board instantiateViewControllerWithIdentifier: @"ForgotPasswordVC"]; 
                               [self.navigationController pushViewController:vc animated:YES];
                           }];
    }else{
        [SVProgressHUD showErrorWithStatus:error];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
