//
//  UIViewController+login.m
//  ShareCare
//
//  Created by 朱明 on 2018/1/2.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "UIViewController+login.h"
#import "MainTabBarController.h"
#import "LoginHttp.h"

@implementation UIViewController (login)
- (void)loginForState:(LoginState)state{
    
    __weak typeof(self) weakself = self;
//    [LoginHttp loginForState:state loginBlock:^(BOOL result) {
//        if (result) {
//            [XMPPService connectXMPP];
//            [weakself loginRequestSuccess];  
//        } 
//    }];
//    
//    return;
    NSString *deviceToken = kAPNS_DEVICE_TOKEN;
    if (!deviceToken) return;
    
//    __weak typeof(self) weakself = self;
    [SVProgressHUD showWithStatus:TEXT_LOADING]; 
    NSDictionary *parameter;
    if (state == LoginStateFacebook) {
        parameter =@{@"userName":kFACEBOOK_USERNAME,
                     @"userId":kFACEBOOK_USERID,
                     @"password":FACEBOOK_DEFAULT_LOGIN_PASSWORD,
                     @"loginType":@"1",
                     @"userIcon":kFACEBOOK_USERICON,
                     @"deviceToken":deviceToken
                     };
    }else if (state == LoginStateEmail){
        parameter =@{@"userName":kUSER_EMAIL,
                     @"userId":@"",
                     @"password":kUSER_PASSWORD,
                     @"loginType":@"0",
                     @"userIcon":@"",
                     @"deviceToken":deviceToken
                     };
    }
    [ShareCareHttp POST:API_LOGIN withParaments:parameter withSuccessBlock:^(id response) {
        
        USERDEFAULT_SET(@"token", response[@"token"]);   
        USERDEFAULT_SET(@"userId", response[@"id"]);   
        USERDEFAULT_SET(@"userName", response[@"userName"]);  
        USERDEFAULT_SET(@"userIcon", response[@"userIcon"]);
        
        USERDEFAULT_SET(@"SHARECATE_fullName", response[@"userName"]);
        USERDEFAULT_SET(@"BABYSITTING_fullName", response[@"userName"]);
        USERDEFAULT_SET(@"EVENT_fullName", response[@"userName"]); 
        
        id userInfoDto = response[@"userInfoDto"]; 
        if ([userInfoDto isKindOfClass:[NSDictionary class]]) {
             
            NSString * fullName =  userInfoDto[@"fullName"];
            NSString * userIcon =  userInfoDto[@"userIcon"]; 
            
            [Util saveUserName:fullName userIcon:userIcon];
        }
        USERDEFAULT_SET_LOGIN(state); 
        
        [XMPPService connectXMPP];
        [SVProgressHUD dismiss];
        [weakself loginRequestSuccess];  
    } withFailureBlock:^(NSString *error) {
        [weakself handleError:error];
        USERDEFAULT_SET_LOGIN(LoginStateNO);
    }];
}
- (void)loginRequestSuccess{
    UIStoryboard *board = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    MainTabBarController *tabbarController = (MainTabBarController *)[board instantiateViewControllerWithIdentifier: @"MainTabBarController"]; 
    [UIApplication sharedApplication].keyWindow.rootViewController = tabbarController;
}

- (void)handleError:(NSString *)error{
    
    [SVProgressHUD showErrorWithStatus:error]; 
    
}


@end
