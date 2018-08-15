//
//  UMSocialObject.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/25.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>
// U-Share核心SDK
#import <UMSocialCore/UMSocialCore.h>

// U-Share分享面板SDK，未添加分享面板SDK可将此行去掉
#import <UShareUI/UShareUI.h>

@interface UMSocialObject : NSObject



- (void)sharePlatform:(UMSocialPlatformType)platform Text:(NSString *)text target:(id)target;


@end
