//
//  SCProfileSettingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/8.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "SCProfileSettingVC.h"

@interface SCProfileSettingVC ()

@end

@implementation SCProfileSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.scrollView.contentSize = CGSizeMake(TX_SCREEN_WIDTH, 800*TX_SCREEN_OFFSET-80+iSiPhoneX*150); 
    self.tfFullName.text = kUSER_USERNAME;
    NSString *userIcon = kUSER_USERICON;
    [self.imgUser setImageWithURL:[NSURL URLWithString:URLStringForPath(userIcon)] 
                 placeholderImage:kDEFAULT_IMAGE];
}

- (UserRoleType)roleType{
    return UserRoleTypeShareCare;
}
- (void)updateUI{
    self.profileModel.certificateInfo = self.profileModel.sharecareCertificateInfo;
    self.tfFullName.text = [self.profileModel.fullName length]==0?kUSER_USERNAME:self.profileModel.fullName;
    self.lbAboutMe.text = self.profileModel.sharecareAboutMe;
    self.lbAddress.text = self.profileModel.address;
    
    
    NSString *userIcon = kUSER_USERICON;
    [self.imgUser setImageWithURL:[NSURL URLWithString:URLStringForPath(userIcon)] 
                 placeholderImage:kDEFAULT_IMAGE];
    self.tfChildrenCheckNum.text = self.profileModel.certificateInfo.childCheckReferenceNumber;
    self.tfChildrenCheckExpiryDate.text = self.profileModel.certificateInfo.childCheckExpiryDate;
    [self.btChildrenCheck setTitle:[self.profileModel.certificateInfo.childrenCheckCertificatePath lastPathComponent] 
                          forState:UIControlStateNormal];
    
    self.tfPoliceCheckNum.text = self.profileModel.certificateInfo.policeCheckCardNo;
    self.tfPoliceCheckExpiryDate.text = self.profileModel.certificateInfo.policeCheckExpiryDate;
    [self.btPoliceCheck setTitle:[self.profileModel.certificateInfo.policeCheckCertificatePath lastPathComponent] 
                        forState:UIControlStateNormal];
    
    
    [self.btLicenseCheck setTitle:self.profileModel.certificateInfo.licenedChildcarerCertificatePath 
                         forState:UIControlStateNormal]; 
    
    self.btnDelChildren.hidden = !(self.profileModel.certificateInfo.childrenCheckCertificatePath.length);;
    self.btnDelPolice.hidden = !(self.profileModel.certificateInfo.policeCheckCertificatePath.length);;
    self.btnDelLicese.hidden = !(self.profileModel.certificateInfo.licenedChildcarerCertificatePath.length);
    
    {
        UIColor *color = COLOR_GRAY;
        switch (self.profileModel.shareCareChildCheck) {
            case 0:
                color = [UIColor redColor];
                break;
            case 1:
                color = COLOR_BLUE;
                break;
            case 2:
                color = COLOR_GRAY;
                break;
                
            default:
                break;
        }
        // [self setupTextFieldBorderColor:color]; 
        self.tfChildrenCheckExpiryDate.layer.borderColor= color.CGColor;  
        self.tfChildrenCheckExpiryDate.textColor = color; 
        self.tfChildrenCheckNum.layer.borderColor= color.CGColor;  
        self.tfChildrenCheckNum.textColor = color; 
        
        [self.btChildrenCheck setTitleColor:color forState:UIControlStateNormal];
        
    }
    
    {
        UIColor *color = COLOR_GRAY;
        switch (self.profileModel.shareCarePoliceCheck) {
            case 0:
                color = [UIColor redColor];
                break;
            case 1:
                color = COLOR_BLUE;
                break;
            case 2:
                color = COLOR_GRAY;
                break;
                
            default:
                break;
        }
        
       self.tfPoliceCheckExpiryDate.layer.borderColor= color.CGColor;  
        self.tfPoliceCheckExpiryDate.textColor = color; 
        self.tfPoliceCheckNum.layer.borderColor= color.CGColor;  
        self.tfPoliceCheckNum.textColor = color; 
        [self.btPoliceCheck setTitleColor:color forState:UIControlStateNormal];
    }
    
}
- (NSString *)policeCheck{
    return @"ShareCarePoliceCheck";
}
- (NSString *)license{
    return @"ShareCareLicense";
}
- (NSString *)childCheck{
    return @"ShareCareChildCheck";
}
- (IBAction)applyChildrenCheck:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURL_CHILDREN_CHECK]];
}
- (IBAction)applyPoliceCheck:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURL_POLICE_CHECK]];
}
@end
