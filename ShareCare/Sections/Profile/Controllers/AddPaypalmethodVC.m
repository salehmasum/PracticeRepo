//
//  AddPaypalmethodVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "AddPaypalmethodVC.h"

@interface AddPaypalmethodVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btFinish;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;

@end

@implementation AddPaypalmethodVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    self.navigationController.navigationBar.shadowImage = [UIImage new]; 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tfEmail.text = _card.email;
    
    _btFinish.enabled = self.isEdit;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([Util validateEmail:textField.text]) {
        _btFinish.enabled = YES;
    }else{
        
        _btFinish.enabled = NO;
    }
}
- (IBAction)textFieldDidEditingChanged:(UITextField *)sender {
    
    _card.email = sender.text;
    if ([Util validateEmail:sender.text]) {
        _btFinish.enabled = YES;
        
    }else{
        
        _btFinish.enabled = NO;
    }
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)save:(id)sender {
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_card convertToDictionary]];
    NSString *api = API_PAYMENT_ADD_CARD;
    if (self.isEdit) {
        [dic setObject:_card.idValue forKey:@"creditId"];
        api = @"/v1/payment/updateBankCardOrPaypal";
    }
    NSLog(@"%@",dic);
    [ShareCareHttp POST:api 
          withParaments:dic 
       withSuccessBlock:^(id response) {
           [SVProgressHUD showSuccessWithStatus:@"Add Paypal Successed!"];
           [weakSelf popListVC];
       } withFailureBlock:^(NSString *error) {
           [SVProgressHUD showErrorWithStatus:error];
       }];
}

- (void)popListVC{
    UINavigationController *navigationVC = self.navigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    //    遍历导航控制器中的控制器
    for (UIViewController *vc in navigationVC.viewControllers) {
        [viewControllers addObject:vc];
        if ([vc isKindOfClass:NSClassFromString(@"ShareCarePaymentTableVC")] || [vc isKindOfClass:NSClassFromString(@"EventPaymentAndBillingVC")]) {
            break;
        }
    }
    //    把控制器重新添加到导航控制器
    [navigationVC setViewControllers:viewControllers animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)aboutPaypal:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/c2/webapps/mpp/home?locale.x=en_C2"]];
}

@end
