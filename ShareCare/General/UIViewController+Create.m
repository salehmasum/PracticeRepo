//
//  UIViewController+Create.m
//  ShareCare
//
//  Created by 朱明 on 2018/1/9.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "UIViewController+Create.h"
#import "objc/runtime.h"
#import "CreateShareCareVC.h"
#import "CreateBabySittingVC.h"
#import "ProfileModel.h"
#import "CustomPopupViewController.h"
#import "SCProfileSettingVC.h"
#import "BProfileSettingVC.h"
#import "SProfileSettingVC.h"
#import "CreateEventsVC.h"
#import "ShareCarePaymentTableVC.h"
#import "NewChildrenTableVC.h"
#import "EditChildrenVC.h"
static  char blockKey;
@interface UIViewController()

@property (nonatomic,copy)CreateItemVerifyLicenseBlock verifyBlock;

@end
@implementation UIViewController (Create)


-(void)setVerifyBlock:(CreateItemVerifyLicenseBlock)verifyBlock
{
    objc_setAssociatedObject(self, &blockKey, verifyBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(CreateItemVerifyLicenseBlock)verifyBlock{
    return objc_getAssociatedObject(self, &blockKey);
}


- (void)verifyChildrenLicenseForType:(NSInteger)type pass:(CreateItemVerifyLicenseBlock)verifyBlock{
    
//#ifdef DEBUG 
//    if (type==0) {
//        [self createShareCare];
//    }else  if (type==1){
//        [self createBabySitting];
//    }else{
//        [self createEventListing];
//    }
//    return;
//#else 
//#endif

    [SVProgressHUD showWithStatus:TEXT_LOADING];
    NSArray *array = @[SHARE_TYPE_FOR(type)]; 
    [ShareCareHttp GET:API_GET_USERINFO withParaments:array withSuccessBlock:^(id response) { 
        [SVProgressHUD dismiss];
        
        self.verifyBlock = verifyBlock;
        
        BOOL isPass = NO;
        ProfileModel *profileModel = [[ProfileModel alloc] init];
        @try{ 
            
//            NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:response];
//         [result setObject:@"ture" forKey:@"bindingCard"];
//            [result setObject:@"1" forKey:@"shareCarePoliceCheck"];
//            [result setObject:@"1" forKey:@"shareCareChildCheck"];
//            
            profileModel = [ProfileModel modelWithDictionary:response];
            isPass = (type==0?profileModel.sharecareAudit:profileModel.babysittingAudit);
        }@catch(NSException *e){
            
        }@finally{  
        }
        /*
         点击Yeah Sure 按钮之后的判断逻辑是先判断用户基本信息有没有完成，如果没有就跳转用户信息编辑页面，然后判断用户有没有添加小孩（发布babysitting时不用判断这个），如果没有添加直接跳转添加小孩界面。之后再判断有没有认证通过police check.
         */
        //跳转到个人信息编辑界面
        //  [self showWarningAlert];
        if (profileModel.fullName.length ==0||
            profileModel.userIcon.length ==0||
            profileModel.address.length ==0||
            profileModel.contactNumber.length ==0) {
            //1、判断姓名 电话 地址 头像是否完善
            
            CustomPopupViewController *alertVC = [[CustomPopupViewController alloc] init]; 
            [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:alertVC];
            alertVC.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
            alertVC.popupBlock = ^{
                [self editPersonal:profileModel];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:alertVC.view];
            
            
        }else if (type==0) {
            //EleCare时先判断是否有小孩
            if (profileModel.children.count==0) {
                CustomPopupViewController *alertVC = [[CustomPopupViewController alloc] init]; 
                alertVC.alertContent = @"         You need to be a parent to be a career. \n  Please add a child to your profile.";
                alertVC.alertRightBtnTitle = @"OK"; 
                [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:alertVC];
                alertVC.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
                alertVC.popupBlock = ^{
                   // [self editPersonal:profileModel];
                    [self addChild];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:alertVC.view];
            }else if(profileModel.shareCareChildCheck !=1 || profileModel.shareCarePoliceCheck!=1){
                CustomPopupViewController *alertVC = [[CustomPopupViewController alloc] init]; 
                [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:alertVC];
                alertVC.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
                alertVC.popupBlock = ^{
                    [self editEleCare:profileModel];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:alertVC.view];
            }else if(profileModel.bindingCard == false){
                [self addPaymentReceive];
            }else{
                [self createShareCare];
            }
        }else if (type==1){
            if(profileModel.babysittingChildCheck !=1 || profileModel.babysittingPoliceCheck !=1){
                CustomPopupViewController *alertVC = [[CustomPopupViewController alloc] init]; 
                [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:alertVC];
                alertVC.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
                alertVC.popupBlock = ^{
                    [self editBabysitting:profileModel]; 
                };
                [[UIApplication sharedApplication].keyWindow addSubview:alertVC.view];
                
            }else if(profileModel.bindingCard == false){
                [self addPaymentReceive];
            }else{
                [self createBabySitting];
            }
        }else if (type==2){
            if (profileModel.children.count==0) {
                CustomPopupViewController *alertVC = [[CustomPopupViewController alloc] init]; 
              
                alertVC.alertContent = @"         You need to be a parent to Organise an event. \n   Please add a child to your profile.";
                alertVC.alertRightBtnTitle = @"OK"; 
                [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:alertVC];
                alertVC.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
                alertVC.popupBlock = ^{
                   // [self editPersonal:profileModel];
                    [self addChild];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:alertVC.view];
            }else{
                [self createEventListing];
            }
        }
        
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error]; 
    }];
     
}

- (void)addChild{
//    NewChildrenTableVC *childrenVC = [[NewChildrenTableVC alloc] initWithStyle:UITableViewStyleGrouped];
//    childrenVC.hidesBottomBarWhenPushed = YES;
//    childrenVC.childrens = [NSMutableArray array]; 
//    [self.navigationController pushViewController:childrenVC animated:YES];
    
    EditChildrenVC *editChildrenVC = [[EditChildrenVC alloc] init]; 
    editChildrenVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editChildrenVC animated:YES];
    
}

- (void)addPaymentReceive{
    ShareCarePaymentTableVC *paymentVC  = [[ShareCarePaymentTableVC alloc] init];
    paymentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:paymentVC animated:YES];
}


- (void)editEleCare:(ProfileModel *)profileModel{
    SCProfileSettingVC *settingVC = [[SCProfileSettingVC alloc] init];
    settingVC.profileModel = profileModel;
    settingVC.title = @"EleCare - Edit profile";
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (void)editBabysitting:(ProfileModel *)profileModel{
    BProfileSettingVC *settingVC = [[BProfileSettingVC alloc] init];
    settingVC.title = @"Babysitting - Edit profile";
    settingVC.profileModel = profileModel;
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (void)editPersonal:(ProfileModel *)profileModel{
    SProfileSettingVC *settingVC = [[SProfileSettingVC alloc] init];
    settingVC.roleType = UserRoleTypeEvent;
    settingVC.profileModel = profileModel;
    settingVC.title = @"Edit Personal Profile";
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)createShareCare{
    CreateShareCareVC *create  = [[CreateShareCareVC alloc] init];
    create.title = @"EleCare Listing";
    create.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:create animated:YES];
    
}
- (void)createBabySitting{
    
    CreateBabySittingVC *create  = [[CreateBabySittingVC alloc] init];
    create.title = @"BabySitting Listing";
    create.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:create animated:YES];
}
- (void)createEventListing{
    CreateEventsVC *create  = [[CreateEventsVC alloc] init];
    create.title = @"Event Holder Listing";
    create.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:create animated:YES];
     
}
- (void)showWarningAlert{
    //   __block typeof(self) weakeSelf = self;
    [self showPopup];return;
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:nil 
                                          message:@"You can not create a listing until the police check and work with children have been verified." 
                                          preferredStyle:UIAlertControllerStyleAlert]; 
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"Go back", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]; 
    
    
    [alertController addAction:cancelAction]; 
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)showPopup{
    CustomPopupViewController *alertVC = [[CustomPopupViewController alloc] init]; 
    [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:alertVC];
    alertVC.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
    alertVC.popupBlock = ^{
        
    };
    [[UIApplication sharedApplication].keyWindow addSubview:alertVC.view];
}




@end
