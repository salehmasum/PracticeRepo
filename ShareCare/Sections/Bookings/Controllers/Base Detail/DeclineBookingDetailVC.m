//
//  DeclineBookingDetailVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "DeclineBookingDetailVC.h"
#define MAX_LIMIT_NUMS 500

@interface DeclineBookingDetailVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *lbFeedbackCount;
@end

@implementation DeclineBookingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}



- (IBAction)submit:(id)sender {
    [self showAlert];
}
- (void)showAlert{
    
    
    __block typeof(self) weakeSelf = self;
    
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:@"Are you sure you want to decline this request?"
                                          message:nil 
                                          preferredStyle:UIAlertControllerStyleAlert]; 
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Go Back", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { 
        [weakeSelf confirmDecline];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)confirmDecline{
    
    NSString *content = _textView.text;
    //    experience = [experience substringFromIndex:arc4random()%experience.length];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    NSDictionary *dic = @{@"bookingId"   : _booking.bookingId,
                          @"rejectReason": content};
    [ShareCareHttp POST:API_BOOKING_REJECT withParaments:dic withSuccessBlock:^(id response) {
        // if(count==9)
        
        
        if (_delegate) {
            [_delegate declineBooking:self.booking];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range  
 replacementText:(NSString *)text  
{  
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];  
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;  
    
    if (caninputlen >= 0)  
    {  
        return YES;  
    }  
    else  
    {  
        NSInteger len = text.length + caninputlen;  
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错  
        NSRange rg = {0,MAX(len,0)};  
        
        if (rg.length > 0)  
        {  
            NSString *s = [text substringWithRange:rg];  
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];  
            
            
            _btnSubmit.enabled = textView.text.length;
            self.lbFeedbackCount.text = [NSString stringWithFormat:@"%ld words left",MAX(0,MAX_LIMIT_NUMS - textView.text.length)]; 
            
        }  
        return NO;  
    }  
    
}  

- (void)textViewDidChange:(UITextView *)textView  
{  
    NSString  *nsTextContent = textView.text;  
    NSInteger existTextNum = nsTextContent.length;  
    
    if (existTextNum > MAX_LIMIT_NUMS)  
    {  
        //截取到最大位置的字符  
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];  
        
        [textView setText:s];  
    }  
    
    _btnSubmit.enabled = textView.text.length;
    self.lbFeedbackCount.text = [NSString stringWithFormat:@"%ld words left",MAX(0,MAX_LIMIT_NUMS - existTextNum)]; 
    
}  
@end
