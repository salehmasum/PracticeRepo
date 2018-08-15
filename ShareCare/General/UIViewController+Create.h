//
//  UIViewController+Create.h
//  ShareCare
//
//  Created by 朱明 on 2018/1/9.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CreateItemVerifyLicenseBlock)(BOOL isPass);

@interface UIViewController (Create)

//type:0-sharecare/1-Babysitting/2-event
- (void)verifyChildrenLicenseForType:(NSInteger)type pass:(CreateItemVerifyLicenseBlock)verifyBlock;
- (void)createListing:(id)sender;
@end
