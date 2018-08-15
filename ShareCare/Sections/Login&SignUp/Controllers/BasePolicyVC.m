//
//  BasePolicyVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/31.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BasePolicyVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialObject.h"
#import "UIViewController+Alert.h"

@interface BasePolicyVC ()

@end

@implementation BasePolicyVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share-icon"] style:UIBarButtonItemStyleDone target:self action:@selector(shareContent:)];
     
    [self.textView setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:self.textView]; 
    [self resetTextViewContent:_content];
}

- (void)shareContent:(id)sender{
        
    
//    ShareVC *shareVC = [[ShareVC alloc] init];
//    [self.navigationController pushViewController:shareVC animated:YES];
    
    [self showSystemInputAlertTitle:@"Send Policy" 
                            content:@"To send this policy to yourself, please submit your email address." 
                        placeHolder:@"Email Address"
                        confirmText:@"Send Email" 
                         cancelText:@"Cancel" 
                            confirm:^(NSString *text) {
                                if ([Util validateEmail:text]) {
                                    [self sharePlatform:UMSocialPlatformType_Email toRecipient:text];
                                }else{
                                    [SVProgressHUD showErrorWithStatus:@"Incorrect Email,Please try again."];
                                }
                             
                            }]; 
    //
    
}
- (void)sharePlatform:(UMSocialPlatformType)platform toRecipient:(NSString *)recipient{
    
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    NSDictionary *parameter = @{@"email":recipient,
                                @"policyType":[NSString stringWithFormat:@"%ld",self.policyType]};
    [ShareCareHttp POST:[NSString stringWithFormat:@"/v1/user/send/terms/%@/%ld",recipient,self.policyType] 
          withParaments:parameter withSuccessBlock:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"successed"];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
    
    
    
    return;
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = _content;
    messageObject.title = self.subject;
    
    UMShareEmailObject *emailObject = [[UMShareEmailObject alloc] init];
    emailObject.subject = self.subject;
    emailObject.emailContent = _content;
    emailObject.toRecipients = @[recipient];
    messageObject.shareObject = emailObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            // [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            [SVProgressHUD dismiss];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                [SVProgressHUD showSuccessWithStatus:@"successed"];
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, TX_SCREEN_WIDTH-20, TX_SCREEN_HEIGHT)];
        _textView.editable = NO;
    }
    return _textView;
}
- (void)resetTextViewContent:(NSString *)content{ 
    
    CGFloat size = 30;
    NSString *privacy = CustomLocalizedString(@"Privacy Policy", @"start");
    NSString *terms = CustomLocalizedString(@"Terms and Conditions", @"start");
    NSString *nondiscrimination = CustomLocalizedString(@"Nondiscrimination Policy", @"start");
    
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:content attributes:@{NSFontAttributeName:TX_FONT(14)}];
    
    NSRange rangeT = [content rangeOfString:terms];
    [textStr addAttribute:NSFontAttributeName value:TX_BOLD_FONT(size) range:rangeT];
    
    NSRange rangeP = [content rangeOfString:privacy];
    [textStr addAttribute:NSFontAttributeName value:TX_BOLD_FONT(size) range:rangeP];
    
    NSRange rangeN = [content rangeOfString:nondiscrimination];
    [textStr addAttribute:NSFontAttributeName value:TX_BOLD_FONT(size) range:rangeN];
    
    NSRange rangeTime = [content rangeOfString:@"——————————\nLast Updated: May 15, 2017"];
    [textStr addAttribute:NSFontAttributeName value:TX_BOLD_FONT(11) range:rangeTime];
    [textStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:rangeTime];
    self.textView.attributedText = textStr;
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
