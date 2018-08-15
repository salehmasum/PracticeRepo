//
//  BaseProfileSettingVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/17.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+XHPhoto.h"
#import "UIViewController+KeyboardState.h"
#import "ProfileModel.h"

@interface BaseProfileSettingVC : UIViewController<UITextFieldDelegate>


@property (strong, nonatomic) NSMutableArray *childrens;
@property (strong, nonatomic) ProfileModel *profileModel;
@property (assign, nonatomic) UserRoleType roleType;
- (void)updateUserIcon:(UIImage *)photo;
- (void)showPhotoActionSheet;

- (void)updateUI;
- (void)getProfile;

@end
