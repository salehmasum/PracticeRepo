//
//  AddBankTransferVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "AddBankTransferVC.h"

@interface AddBankTransferVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btFinish;
@property (weak, nonatomic) IBOutlet UITextField *tfBankName;
@property (weak, nonatomic) IBOutlet UITextField *tfBankBranch;
@property (weak, nonatomic) IBOutlet UITextField *tfPayee;
@property (weak, nonatomic) IBOutlet UITextField *tfCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfBSB;

@end

@implementation AddBankTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tfBankName.text     = _card.bankName;    
    _tfBankBranch.text   = _card.bankBranch;  
    _tfPayee.text        = _card.payee;       
    _tfCardNumber.text   = _card.cardNumber;  
    _tfBSB.text          = _card.bsb;    
    _btFinish.enabled = self.isEdit;     
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{ 
    CGRect rect = self.view.bounds;
    rect.origin.y = -50;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.frame = rect;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.frame = self.view.bounds;
    }];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)textFieldDidEditingChanged:(UITextField *)sender {
    
    if (_tfBankName.text.length &&
        _tfBankBranch.text.length &&
        _tfPayee.text.length &&
        _tfCardNumber.text.length &&
        _tfBSB.text.length) {
        _btFinish.enabled = YES;
    }else{
        
        _btFinish.enabled = NO;
    }
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)save:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    _card.bankName   = _tfBankName.text;
    _card.bankBranch = _tfBankBranch.text;
    _card.payee      = _tfPayee.text;
    _card.cardNumber = _tfCardNumber.text;
    _card.bsb        = _tfBSB.text;
    
    
    
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
           [SVProgressHUD showSuccessWithStatus:@"Add Card Successed!"];
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
        if ([vc isKindOfClass:NSClassFromString(@"ShareCarePaymentTableVC")]) {
            break;
        }
    }
    //    把控制器重新添加到导航控制器
    [navigationVC setViewControllers:viewControllers animated:YES];
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
