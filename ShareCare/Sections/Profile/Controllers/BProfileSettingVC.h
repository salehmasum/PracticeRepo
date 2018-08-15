//
//  BProfileSettingVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/17.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseProfileSettingVC.h"
#import "InputInfoVC.h"

typedef enum : NSUInteger {
    CretificateTypeBabySittingChild,
    CretificateTypeBabySittingPolice,
    CretificateTypeBabySittingLicense,
    CretificateTypeShareCareChild,
    CretificateTypeShareCarePolice,
    CretificateTypeShareCareLicense
} CretificateType;

@interface BProfileSettingVC : BaseProfileSettingVC


@property (strong, nonatomic) NSString *childCheck;
@property (strong, nonatomic) NSString *policeCheck;
@property (strong, nonatomic) NSString *license;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView; 
@property (weak, nonatomic) IBOutlet UIImageView *imgUser;
@property (strong, nonatomic) UIImage *userImage;
@property (weak, nonatomic) IBOutlet UITextField *tfChildrenCheckNum;
@property (weak, nonatomic) IBOutlet UITextField *tfChildrenCheckExpiryDate;
@property (weak, nonatomic) IBOutlet UITextField *tfPoliceCheckNum;
@property (weak, nonatomic) IBOutlet UITextField *tfPoliceCheckExpiryDate;
@property (weak, nonatomic) IBOutlet UILabel *lbAboutMe;
@property (weak, nonatomic) IBOutlet UITextField *tfFullName;

@property (weak, nonatomic) IBOutlet UIButton *btChildrenCheck;
@property (weak, nonatomic) IBOutlet UIButton *btPoliceCheck;
@property (weak, nonatomic) IBOutlet UIButton *btLicenseCheck;

@property (nonatomic, strong) UIImage *imageUser;
@property (nonatomic, strong) UIImage *imageChildrenCheck;
@property (nonatomic, strong) UIImage *imagePoliceCheck;
@property (nonatomic, strong) UIImage *imageLicenCheck;

@property (weak, nonatomic) IBOutlet UIButton *btnDelChildren;
@property (weak, nonatomic) IBOutlet UIButton *btnDelPolice;
@property (weak, nonatomic) IBOutlet UIButton *btnDelLicese;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;


@property (weak, nonatomic) IBOutlet UIView *viewAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;

- (void)setupTextFieldBorderColor:(UIColor *)color;
- (void)updateCertificate:(UIImage *)photo 
                 fileType:(NSString *)type 
          cretificateType:(CretificateType)cretificateType;
@end
