//
//  ShareVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/31.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ShareVC.h"
#import "UMSocialObject.h"

@interface ShareVC (){
    UMSocialPlatformType _platformtype;
}

@property (weak, nonatomic) IBOutlet UIView *shareContentView;
@property (weak, nonatomic) IBOutlet UILabel *shareTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIImageView *platformIcon;
@property (weak, nonatomic) IBOutlet UILabel *patformName;
@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;
@property (weak, nonatomic) IBOutlet UILabel *alertLbTitle;
@property (weak, nonatomic) IBOutlet UILabel *alertContent;
@property (weak, nonatomic) IBOutlet UIView *alertView;

@end

@implementation ShareVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];  
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.shareContentView.layer.masksToBounds = YES;
    self.shareContentView.layer.cornerRadius = 6;
    
    self.alertImageView.layer.masksToBounds = YES;
    self.alertImageView.layer.cornerRadius = 6;
    
    _shareContent = [NSString stringWithFormat:@"%@:Download the app FREE!https://itunes.apple.com/au/app/elecare/id1277573857",_shareTitle];
    _alertContent.text = _shareContent;
    _alertLbTitle.text = _shareTitle;
    [self.imageView setImageWithURL:[NSURL URLWithString:URLStringForPath(_imagePath)] placeholderImage:kDEFAULT_IMAGE];
    [self.alertImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(_imagePath)] placeholderImage:kDEFAULT_IMAGE];
    _shareTitleLabel.text = _shareTitle;
     
}
- (IBAction)shareEmail:(id)sender {
    [self sharePlatform:UMSocialPlatformType_Email Text:@"test" target:self];
    _platformtype = UMSocialPlatformType_Email;
}
- (IBAction)shareSMS:(id)sender {
    [self sharePlatform:UMSocialPlatformType_Sms Text:@"test" target:self];
    _platformtype = UMSocialPlatformType_Sms;
}
- (IBAction)shareFacebook:(id)sender {
    _platformtype = UMSocialPlatformType_Facebook;
    _platformIcon.image= [UIImage imageNamed:@"event-facebook"];
    _patformName.text = @"Facebook";
    [self showAlertView];

}
- (IBAction)shareTwitter:(id)sender {
    _platformtype = UMSocialPlatformType_Twitter;
//    [self sharePlatform:UMSocialPlatformType_Twitter Text:@"test" target:self];
    _platformIcon.image= [UIImage imageNamed:@"event-twitter"];
    _patformName.text = @"Twitter";
    [self showAlertView];
}
- (IBAction)shareInstagram:(id)sender {
    _platformtype = UMSocialPlatformType_Instagram;
//    [self sharePlatform:UMSocialPlatformType_Instagram Text:@"test" target:self];
    
    _platformIcon.image= [UIImage imageNamed:@"event-instagram"];
    _patformName.text = @"Instagram";
    [self showAlertView];
    
}

- (void)showAlertView{
    _alertView.hidden = NO;return;
    [UIView animateWithDuration:0.3 animations:^{
        _alertView.alpha =1;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)post:(id)sender {
    [SVProgressHUD showWithStatus:TEXT_LOADING]; 
    _alertView.hidden = YES;
    if (_platformtype == UMSocialPlatformType_Facebook) {
        [self sharePlatform:_platformtype Text:@"test" target:self];
    }else{
        [SVProgressHUD dismiss];
    }
    
}
- (IBAction)cancel:(id)sender {
    _alertView.hidden = YES;return;
    [UIView animateWithDuration:0.1 animations:^{
        _alertView.alpha =0;
    }];
}


- (IBAction)popViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sharePlatform:(UMSocialPlatformType)platform Text:(NSString *)text target:(id)target{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = [NSString stringWithFormat:@"%@:Download the app FREE!https://itunes.apple.com/au/app/sharecare/id1143531918",_shareTitle];//; 
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
        // [self alertWithError:error];
    }];
}
 
@end
