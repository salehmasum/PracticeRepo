//
//  HelpAndSupportVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HelpAndSupportVC.h"

#import "UIViewController+KeyboardState.h"
@interface HelpAndSupportVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfFullName;
@property (weak, nonatomic) IBOutlet UITextField *tfSubject;
@property (weak, nonatomic) IBOutlet UITextView *tvMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;

@end

@implementation HelpAndSupportVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _scrollView.contentSize = CGSizeMake(TX_SCREEN_WIDTH, 800*TX_SCREEN_OFFSET+iSiPhoneX*100);
    [self setKeyboardNotificationWith:self.scrollView];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)checkValida{
    if (![Util validateEmail:_tfEmail.text]) {
        [SVProgressHUD showErrorWithStatus:@"Invalid email address"]; return NO;
    }
    if (_tfFullName.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Invalid Full Name"]; return NO;
    }
    
    if (_tfSubject.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Invalid Subject"]; return NO;
    }
    
    if (_tvMessage.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Invalid message"]; return NO;
    }
    return YES;
}

- (IBAction)submit:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    if ([self checkValida]) { 
        [SVProgressHUD showWithStatus:TEXT_LOADING];
        NSDictionary *parameter = @{@"email":_tfEmail.text,
                                    @"fullName":_tfFullName.text,
                                    @"subject":_tfSubject.text,
                                    @"message":_tvMessage.text, 
                                    };
        [ShareCareHttp POST:API_FEEDBACK withParaments:parameter withSuccessBlock:^(id response) {
            [SVProgressHUD showSuccessWithStatus:@"successed"];
            [self performSelector:@selector(popViewController) withObject:nil afterDelay:1];
        } withFailureBlock:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
        
    } 
}

- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
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
