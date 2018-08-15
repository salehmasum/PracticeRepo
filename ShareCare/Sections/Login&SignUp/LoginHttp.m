//
//  LoginHttp.m
//  ShareCare
//
//  Created by 朱明 on 2018/2/2.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "LoginHttp.h"

@implementation LoginHttp

+ (void)loginForState:(LoginState)state loginBlock:(LoginBlock)loginBlock{
    
    NSString *deviceToken = kAPNS_DEVICE_TOKEN;
    if (!deviceToken) return;
    
   // __weak typeof(self) weakself = self;
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
        
        USERDEFAULT_SET(@"SHARECATE_fullName", response[@"userName"]);
        USERDEFAULT_SET(@"BABYSITTING_fullName", response[@"userName"]);
        USERDEFAULT_SET(@"EVENT_fullName", response[@"userName"]); 
        
        id userInfoDto = response[@"userInfoDto"];  
        if ([userInfoDto isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)userInfoDto;
            for (NSDictionary *obj in array) {
                NSString *key_fullName = [NSString stringWithFormat:@"%@_fullName",obj[@"shareType"]];
                NSString *key_userIcon = [NSString stringWithFormat:@"%@_userIcon",obj[@"shareType"]];
                
                USERDEFAULT_SET(key_fullName, obj[@"fullName"]);
                USERDEFAULT_SET(key_userIcon, obj[@"userIcon"]);
            }
        }
        USERDEFAULT_SET_LOGIN(state);  
        
        if (loginBlock) {
            loginBlock(YES);
        }
        
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error]; 
        USERDEFAULT_SET_LOGIN(LoginStateNO);
        if (loginBlock) {
            loginBlock(NO);
        }
    }];
}
@end
