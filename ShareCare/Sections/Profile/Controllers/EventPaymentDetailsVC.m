//
//  EventPaymentDetailsVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "EventPaymentDetailsVC.h"
#import "UIViewController+KeyboardState.h"
#import "UIKeyboardScrollView.h"
#import "ZPicker.h"

@interface EventPaymentDetailsVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIKeyboardScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *tfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *tfLastName;
@property (weak, nonatomic) IBOutlet UITextField *tfCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *tfExpirationDate;
@property (weak, nonatomic) IBOutlet UITextField *tfSecurityCode;

@end

@implementation EventPaymentDetailsVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setKeyboardNotificationWith:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(TX_SCREEN_WIDTH, 650);
    self.automaticallyAdjustsScrollViewInsets = NO; 
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    saveButton.tintColor = COLOR_GRAY;
    self.navigationItem.rightBarButtonItem = saveButton;
}
- (void)save:(id)sender{
    
    if (![self checkAvilable]) return;
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_card convertToDictionary]];
    NSString *api = API_PAYMENT_ADD_CARD;
//    if (self.isEdit) {
//        [dic setObject:_card.idValue forKey:@"creditId"];
//        api = @"/v1/payment/updateBankCardOrPaypal";
//    }
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
        if ([vc isKindOfClass:NSClassFromString(@"EventPaymentAndBillingVC")]) {
            break;
        }
    }
    //    把控制器重新添加到导航控制器
    [navigationVC setViewControllers:viewControllers animated:YES];
}

    
    
- (void)test{
    if (![self checkAvilable]) return;
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    NSDictionary *dic = @{@"cardNumber": [_tfCardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          @"expirationDate": _tfExpirationDate.text,
                          @"firstName": _tfFirstName.text,
                          @"lastName": _tfLastName.text,
                          @"securityCode": _tfSecurityCode.text
                          };
    NSLog(@"%@",dic);
    [ShareCareHttp POST:API_PAYMENT_CREDITCARD_ADD 
          withParaments:dic 
       withSuccessBlock:^(id response) {
           [SVProgressHUD showSuccessWithStatus:@"Add Card Successed!"];
           [weakSelf popListVC];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
 

- (BOOL)checkAvilable{
    if (_tfFirstName.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Error First Name"];return NO;
    }
    if (_tfLastName.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Error Last Name"];return NO;
    }
    if (_tfCardNumber.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Error Card Number"];return NO;
    }
    if (_tfExpirationDate.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Error Expiration Date"];return NO;
    }
    if (_tfSecurityCode.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Error Security Code"];return NO;
    }
    
    
    _card.cardType = @"0";
    _card.firstName = _tfFirstName.text;
    _card.lastName = _tfLastName.text;
    _card.cardNumber = [_tfCardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    _card.expirationDate = _tfExpirationDate.text;
    _card.securityCode = _tfSecurityCode.text;
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == _tfCardNumber){  
        
        BOOL returnValue = YES;
        NSMutableString* newText = [NSMutableString stringWithCapacity:0];
        [newText appendString:textField.text];// 拿到原有text,根据下面判断可能给它添加" "(空格);
        
        NSString * noBlankStr = [textField.text stringByReplacingOccurrencesOfString:@" "withString:@""];
        NSInteger textLength = [noBlankStr length];
        if (string.length) {//输入
            if (textLength < 25) {//这个25是控制实际字符串长度,比如银行卡号长度
                if (textLength > 0 && textLength %4 == 0) {
                    newText = [NSMutableString stringWithString:[newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [newText appendString:@" "];
                    [newText appendString:string];
                    textField.text = newText;
                    returnValue = NO;//为什么return NO?因为textField.text = newText;text已经被我们替换好了,那么就不需要系统帮我们添加了,如果你ruturnYES的话,你会发现会多出一个字符串
                }else {
                    [newText appendString:string];
                }
            }else { // 比25长的话 return NO这样输入就无效了
                returnValue =NO;
            }
        }else { // 删除
            
            
            [newText replaceCharactersInRange:range withString:string];
            
            if (newText.length>4) {
                if ([[newText substringFromIndex:newText.length-1] isEqualToString:@" "]) {
                    textField.text = [newText substringToIndex:newText.length-1];
                    returnValue = NO;
                }
            }
            
        }
        
        return returnValue; 
    }
    
    if (textField == _tfExpirationDate) {
        BOOL returnValue = YES;
        NSMutableString* newText = [NSMutableString stringWithCapacity:0];
        [newText appendString:textField.text];// 拿到原有text,根据下面判断可能给它添加" "(空格);
        
        NSString * noBlankStr = [textField.text stringByReplacingOccurrencesOfString:@"/"withString:@""];
        NSInteger textLength = [noBlankStr length];
        if (string.length) {
            if (textLength < 6) {//这个25是控制实际字符串长度,比如银行卡号长度
                if (textLength > 0 && textLength %2 == 0 && ![newText containsString:@"/"]) {
                    newText = [NSMutableString stringWithString:[newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    [newText appendString:@"/"];
                    [newText appendString:string];
                    textField.text = newText;
                    returnValue = NO;//为什么return NO?因为textField.text = newText;text已经被我们替换好了,那么就不需要系统帮我们添加了,如果你ruturnYES的话,你会发现会多出一个字符串
                }else {
                    [newText appendString:string];
                }
            }else { // 比25长的话 return NO这样输入就无效了
                returnValue =NO;
            }
        }else { // 如果输入为空,该怎么地怎么地
            [newText replaceCharactersInRange:range withString:string];
            
            if (newText.length>2) {
                if ([[newText substringFromIndex:newText.length-1] isEqualToString:@"/"]) {
                    textField.text = [newText substringToIndex:newText.length-1];
                    returnValue = NO;
                }
            }
        }
        
        return returnValue; 
    }
    
    return YES;
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
