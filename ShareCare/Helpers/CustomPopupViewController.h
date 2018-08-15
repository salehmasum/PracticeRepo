//
//  CustomPopupViewController.h
//  ShareCare
//
//  Created by 朱明 on 2018/3/16.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXBlurView_Clinkle/FXBlurView.h>
typedef void(^CreateListingPopupBlock)(void);
@interface CustomPopupViewController : UIViewController

@property (strong,nonatomic) CreateListingPopupBlock popupBlock;

@property (strong,nonatomic) NSString *alertTitle;
@property (strong,nonatomic) NSString *alertContent;
@property (strong,nonatomic) NSString *alertLeftBtnTitle;
@property (strong,nonatomic) NSString *alertRightBtnTitle;

@end
