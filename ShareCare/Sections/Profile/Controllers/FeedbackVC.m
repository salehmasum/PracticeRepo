//
//  FeedbackVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "FeedbackVC.h"
#import "UMSocialObject.h"

@interface FeedbackVC ()

@end

@implementation FeedbackVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)email:(id)sender {
    
    [[UIApplication sharedApplication]openURL:[NSURL   URLWithString:@"mailto:hello@elecare.net.au"]];
    
   // [self sharePlatform:UMSocialPlatformType_Email];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)sharePlatform:(UMSocialPlatformType)platform{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject]; 
    UMShareEmailObject *emailObject = [[UMShareEmailObject alloc] init];
    emailObject.toRecipients = @[@"hello@elecare.net.au"];
    emailObject.subject = @"How are we doing?";
    messageObject.shareObject = emailObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
             [SVProgressHUD showErrorWithStatus:@"faild"];
          //  [SVProgressHUD dismiss];
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
