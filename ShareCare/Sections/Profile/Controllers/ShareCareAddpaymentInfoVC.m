//
//  ShareCareAddpaymentInfoVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ShareCareAddpaymentInfoVC.h"
#import "ShareCareAddpaymentInfo1VC.h"
#import "UIViewController+KeyboardState.h"
#import "UIViewController+KeyboardState.h"
#import "AddPaypalmethodVC.h"
#import "AddBankTransferVC.h"

@interface ShareCareAddpaymentInfoVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btNext;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *tfAddressLine1;
@property (weak, nonatomic) IBOutlet UITextField *tfAddressLine2;
@property (weak, nonatomic) IBOutlet UITextField *tfCity;
@property (weak, nonatomic) IBOutlet UITextField *tfState;
@property (weak, nonatomic) IBOutlet UITextField *tfZipCode;

@end

@implementation ShareCareAddpaymentInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setKeyboardNotificationWith:self.scrollView];
    
    
     _tfAddressLine1.text = _card.addressLine1;
     _tfAddressLine2.text = _card.addressLine2;
     _tfCity.text = _card.city;
     _tfState.text = _card.state;
     _tfZipCode.text = _card.zipCode;
    
    _btNext.enabled = self.isEdit;
    
}
- (IBAction)next:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    
    _card.addressLine1 = _tfAddressLine1.text;
    _card.addressLine2 = _tfAddressLine2.text;
    _card.city = _tfCity.text;
    _card.state = _tfState.text;
    _card.zipCode = _tfZipCode.text;
    
    [self setKeyboardNotificationWith:self.scrollView];
    
    
    
    if (self.isEdit) {
        if (_card.cardType.integerValue == 2) { 
            AddPaypalmethodVC *detail = [[AddPaypalmethodVC alloc] init];
            detail.card = _card;
            detail.isEdit = self.isEdit;
            [self.navigationController pushViewController:detail animated:YES];
        }else if (_card.cardType.integerValue == 1) { 
            AddBankTransferVC *detail = [[AddBankTransferVC alloc] init];
            detail.card = _card;
            detail.isEdit = self.isEdit;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
        _btNext.enabled = self.isEdit;
    }else{
        ShareCareAddpaymentInfo1VC *paymentVC  = [[ShareCareAddpaymentInfo1VC alloc] init]; 
        paymentVC.card = _card; 
        paymentVC.isEdit = self.isEdit;
        [self.navigationController pushViewController:paymentVC animated:YES];
    }
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
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
    
    if (_tfAddressLine1.text.length &&
        _tfAddressLine2.text.length &&
        _tfCity.text.length &&
        _tfState.text.length &&
        _tfZipCode.text.length) {
        _btNext.enabled = YES;
    }else{
        
        _btNext.enabled = NO;
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
