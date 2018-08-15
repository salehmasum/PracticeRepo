//
//  UMSocialObject.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/25.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "UMSocialObject.h"

@implementation UMSocialObject 
- (void)sharePlatform:(UMSocialPlatformType)platform Text:(NSString *)text target:(id)target{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = text;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:target completion:^(id data, NSError *error) {
 
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
       // [self alertWithError:error];
    }];
}




@end
