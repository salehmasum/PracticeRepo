//
//  ForgotPasswordVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "UIViewController+Alert.h"
@interface ForgotPasswordVC ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation ForgotPasswordVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)confirmAction:(id)sender {
     
    
    NSString *account = self.emailTextField.text;
    if (![Util validateEmail:account]) {       
        [SVProgressHUD showErrorWithStatus:CustomLocalizedString(@"Invalid email address", @"login")];       
        return;    
        
    }
    [self.emailTextField resignFirstResponder];
    
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:CustomLocalizedString(@"Check Your Email", @"password") 
                                          message:[NSString stringWithFormat:@"We sent an email to %@.",self.emailTextField.text] 
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Cancel", @"password") 
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"OK", @"password") 
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
 
                                                           [self sendEmailAddress];
    }];

 //   [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sendEmailAddress{  
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    
    [ShareCareHttp GET:API_FORGOT_PASSWORD 
         withParaments:@[[NSString stringWithFormat:@"email=%@",self.emailTextField.text]] 
      withSuccessBlock:^(id response) {
         [SVProgressHUD showSuccessWithStatus:@"send successed"]; 
        [self.navigationController popViewControllerAnimated:YES];
    } withFailureBlock:^(NSString *error) {
        [self handleError:error]; 
    }];
    
     
}

- (void)handleError:(NSString *)error{
    
    [SVProgressHUD dismiss]; 
    
    if ([error isEqualToString:@"Email not exist!"]) {
        [self showSystemAlertTitle:@"User does not exist" 
                           content:@"The email address you have submitted does not exist. Please re-enter email." 
                       confirmText:@"Re-Submit" 
                        cancelText:@"OK" 
                           confirm:^(NSString *text) {
                               [self sendEmailAddress];
                           }];
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
