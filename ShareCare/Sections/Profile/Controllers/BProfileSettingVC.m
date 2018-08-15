//
//  BProfileSettingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/17.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BProfileSettingVC.h"
#import "SKFPreViewNavController.h"
#import "UIViewController+GooglePlace.h"

@interface BProfileSettingVC ()

@end 
@implementation BProfileSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.contentSize = CGSizeMake(TX_SCREEN_WIDTH, 800*TX_SCREEN_OFFSET-80+iSiPhoneX*150);
    [self setKeyboardNotificationWith:self.scrollView];
      
    [self setupTextFieldBorderColor:TX_RGB(136, 136, 136)];
    
    _tfFullName.text = kUSER_USERNAME;
    NSString *userIcon = kUSER_USERICON;
    [self.imgUser setImageWithURL:[NSURL URLWithString:URLStringForPath(userIcon)] 
                 placeholderImage:kDEFAULT_IMAGE];
 //   [self updateUI];
}
- (void)setupTextFieldBorderColor:(UIColor *)color{
    for (UITextField *textField in _textFields) { 
        textField.layer.borderColor= color.CGColor; 
        textField.layer.borderWidth = 1; 
        textField.textColor = color;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 0)];
        textField.leftView = view;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
}

- (UserRoleType)roleType{
    return UserRoleTypeBabySitting;
}
- (void)updateUI{
    
    self.profileModel.certificateInfo = self.profileModel.babysittingCertificateInfo;
    _tfFullName.text = [self.profileModel.fullName length]==0?kUSER_USERNAME:self.profileModel.fullName;
    _lbAboutMe.text = self.profileModel.babysittingAboutMe;
    _lbAddress.text = self.profileModel.address;
    NSString *userIcon = kUSER_USERICON;
    [self.imgUser setImageWithURL:[NSURL URLWithString:URLStringForPath(userIcon)] 
                 placeholderImage:kDEFAULT_IMAGE];
    
    
    _tfChildrenCheckNum.text = self.profileModel.certificateInfo.childCheckReferenceNumber;
    _tfChildrenCheckExpiryDate.text = self.profileModel.certificateInfo.childCheckExpiryDate;
    [_btChildrenCheck setTitle:[self.profileModel.certificateInfo.childrenCheckCertificatePath lastPathComponent] 
                      forState:UIControlStateNormal];
    
    _tfPoliceCheckNum.text = self.profileModel.certificateInfo.policeCheckCardNo;
    _tfPoliceCheckExpiryDate.text = self.profileModel.certificateInfo.policeCheckExpiryDate;
    [_btPoliceCheck setTitle:[self.profileModel.certificateInfo.policeCheckCertificatePath lastPathComponent]
                    forState:UIControlStateNormal];
    
    
    [_btLicenseCheck setTitle:self.profileModel.certificateInfo.licenedChildcarerCertificatePath 
                     forState:UIControlStateNormal]; 
    
    
    self.btnDelChildren.hidden = !(self.profileModel.certificateInfo.childrenCheckCertificatePath.length);;
    self.btnDelPolice.hidden = !(self.profileModel.certificateInfo.policeCheckCertificatePath.length);;
    self.btnDelLicese.hidden = !(self.profileModel.certificateInfo.licenedChildcarerCertificatePath.length);
    
    {
        UIColor *color = COLOR_GRAY;
        switch (self.profileModel.babysittingChildCheck) {
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
        _tfChildrenCheckExpiryDate.layer.borderColor= color.CGColor;  
        _tfChildrenCheckExpiryDate.textColor = color; 
        _tfChildrenCheckNum.layer.borderColor= color.CGColor;  
        _tfChildrenCheckNum.textColor = color; 
        [_btChildrenCheck setTitleColor:color forState:UIControlStateNormal];
        
    }
    
    {
        UIColor *color = COLOR_GRAY;
        switch (self.profileModel.babysittingPoliceCheck) {
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
        
        _tfPoliceCheckExpiryDate.layer.borderColor= color.CGColor;  
        _tfPoliceCheckExpiryDate.textColor = color; 
        _tfPoliceCheckNum.layer.borderColor= color.CGColor;  
        _tfPoliceCheckNum.textColor = color; 
        [_btPoliceCheck setTitleColor:color forState:UIControlStateNormal];
    }
    
}

- (IBAction)editAddress:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [self GMSAutocompleteAddress:^(NSString *address, CLLocationCoordinate2D coordinate) {
        weakSelf.lbAddress.text = address;
        
        weakSelf.profileModel.address = address;
        weakSelf.profileModel.addressLon = coordinate.longitude;
        weakSelf.profileModel.addressLat = coordinate.latitude;
    }];
    
}

- (NSString *)policeCheck{
    return @"BabysittingPoliceCheck";
}
- (NSString *)license{
    return @"BabysittingLicense";
}
- (NSString *)childCheck{
    return @"BabysittingChildCheck";
}

- (IBAction)previewPhoto:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [self previewImagePath:self.profileModel.userIcon];
    
}
- (IBAction)takeOrChoosePhoto:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    __weak typeof(self) weakSelf = self;
    [self showPhotoSourceType:SourceTypeCameraOrPhotoLibrary 
                   alerttitle:@"Upload Profile Photo" 
                        photo:^(UIImage *photo) {
        weakSelf.imgUser.image = photo;
        weakSelf.userImage = photo;
        [weakSelf updateUserIcon:photo];
    }];
}
- (IBAction)editAboutMe:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    InputInfoVC *vc = [[InputInfoVC alloc] init]; 
    
    switch (self.roleType) {
        case UserRoleTypeShareCare:
            vc.careType = AboutContentTypeProfileShareCare;
            break;
        case UserRoleTypeBabySitting:
            vc.careType = AboutContentTypeProfileBabysitting;
            break;
        case UserRoleTypeEvent:
            vc.careType = AboutContentTypeProfileEvent;
            break;
            
        default:
            break;
    }
    
    vc.contentTitle = @"About Me";
    vc.content = _lbAboutMe.text;
    vc.inputBlock = ^(NSString *text) {
        NSLog(@"text:%@",text);  
        _lbAboutMe.text = text;
    };
    [self.navigationController pushViewController:vc animated:NO];
}

/*------添加证书------------*/
- (IBAction)addChildsCheckPhoto:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    __block typeof(self) weakeSelf = self;
    [self showPhotoSourceType:SourceTypeCameraOrPhotoLibrary photo:^(UIImage *photo) {
        [weakeSelf.btChildrenCheck setTitle:[Util fileName] forState:UIControlStateNormal];
        weakeSelf.imageChildrenCheck = photo;
        weakeSelf.btnDelChildren.hidden = NO;
        [weakeSelf updateCertificate:photo 
                            fileType:weakeSelf.childCheck 
                     cretificateType:self.roleType==UserRoleTypeBabySitting?CretificateTypeBabySittingChild:CretificateTypeShareCareChild];
    }];
}

- (IBAction)applyChildrenCheck:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURL_CHILDREN_CHECK]];
}
- (IBAction)applyPoliceCheck:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kURL_POLICE_CHECK]];
}

- (IBAction)addPoliceCheckPhoto:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    __block typeof(self) weakeSelf = self;
    [self showPhotoSourceType:SourceTypeCameraOrPhotoLibrary photo:^(UIImage *photo) {
        [weakeSelf.btPoliceCheck setTitle:[Util fileName] forState:UIControlStateNormal];
        weakeSelf.imagePoliceCheck = photo;
        weakeSelf.btnDelPolice.hidden = NO;
        [weakeSelf updateCertificate:photo 
                            fileType:weakeSelf.policeCheck 
                     cretificateType:self.roleType==UserRoleTypeBabySitting?CretificateTypeBabySittingPolice:CretificateTypeShareCarePolice];
    }];
}


- (IBAction)addLicensePhoto:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    __block typeof(self) weakeSelf = self;
    [self showPhotoSourceType:SourceTypeCameraOrPhotoLibrary photo:^(UIImage *photo) {
        [weakeSelf.btLicenseCheck setTitle:[Util fileName] forState:UIControlStateNormal];
        weakeSelf.imageLicenCheck = photo;
        weakeSelf.btnDelLicese.hidden = NO;
        [weakeSelf updateCertificate:photo 
                            fileType:weakeSelf.license 
                     cretificateType:self.roleType==UserRoleTypeBabySitting?CretificateTypeBabySittingLicense:CretificateTypeShareCareLicense];
    }];
}
 
/*------预览证书------------*/
- (IBAction)previewChildsCheckPhoto:(id)sender { 
    if (self.roleType == UserRoleTypeBabySitting) {
        [self previewImagePath:self.profileModel.certificateInfo.childrenCheckCertificatePath];
    }else{
        [self previewImagePath:self.profileModel.certificateInfo.childrenCheckCertificatePath];
    }
}


- (IBAction)previewPoliceCheckPhoto:(id)sender { 
    if (self.roleType == UserRoleTypeBabySitting) {
        [self previewImagePath:self.profileModel.certificateInfo.policeCheckCertificatePath];
    }else{
        [self previewImagePath:self.profileModel.certificateInfo.policeCheckCertificatePath];
    }
}


- (IBAction)previewLicensePhoto:(id)sender { 
    if (self.roleType == UserRoleTypeBabySitting) {
        [self previewImagePath:self.profileModel.certificateInfo.licenedChildcarerCertificatePath];
    }else{
        [self previewImagePath:self.profileModel.certificateInfo.licenedChildcarerCertificatePath];
    }
}

/*------删除证书------------*/
- (IBAction)delChildsCheckPhoto:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self.btChildrenCheck setTitle:@"Take or Choose photo..." forState:UIControlStateNormal];
    self.imageChildrenCheck = nil;
    self.btnDelChildren.hidden = YES;
    if (self.roleType == UserRoleTypeBabySitting) {
        self.profileModel.certificateInfo.childrenCheckCertificatePath = @"";
    }else{
        self.profileModel.certificateInfo.childrenCheckCertificatePath = @"";
    }
}
- (IBAction)delPoliceCheckPhoto:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self.btPoliceCheck setTitle:@"Take or Choose photo..." forState:UIControlStateNormal];
    self.imagePoliceCheck = nil;
    self.btnDelPolice.hidden = YES;
    if (self.roleType == UserRoleTypeBabySitting) {
        self.profileModel.certificateInfo.policeCheckCertificatePath = @"";
    }else{
        self.profileModel.certificateInfo.policeCheckCertificatePath = @"";
    } 
} 
- (IBAction)delLicensedPhoto:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES]; 
    [self.btLicenseCheck setTitle:@"Take or Choose photo..." forState:UIControlStateNormal];
    self.imageLicenCheck = nil;
    self.btnDelLicese.hidden = YES;
    if (self.roleType == UserRoleTypeBabySitting) {
        self.profileModel.certificateInfo.licenedChildcarerCertificatePath = @"";
    }else{
        self.profileModel.certificateInfo.licenedChildcarerCertificatePath = @"";
    } 
}

- (void)previewImagePath:(NSString *)imagePath{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (imagePath.length) { 
        NSMutableArray *photos = [NSMutableArray arrayWithArray:@[URLStringForPath(imagePath)]];
        SKFPreViewNavController *imagePickerVc = [[SKFPreViewNavController alloc] initWithSelectedPhotoURLs:photos index:0];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - request
/*------request--------------------------------------------------------*/
- (void)updateCertificate:(UIImage *)photo 
                 fileType:(NSString *)type 
          cretificateType:(CretificateType)cretificateType{
    
    __block typeof(self) weakeSelf = self;
    [ShareCareHttp upload:[NSString stringWithFormat:@"%@?fileType=%@",API_UPDATE_CERTIFICATE,type] 
            withParaments:nil photos:@[photo] 
      uploadProgressBlock:^(float progress) {
          [SVProgressHUD showProgress:progress];
      } withSuccessBlock:^(id response) { 
          NSLog(@"%@",response);
          
          switch (cretificateType) {
              case CretificateTypeShareCareChild:
                  weakeSelf.profileModel.certificateInfo.childrenCheckCertificatePath = response;
                  break;
              case CretificateTypeShareCarePolice:
                  weakeSelf.profileModel.certificateInfo.policeCheckCertificatePath = response;
                  break;
              case CretificateTypeShareCareLicense:
                  weakeSelf.profileModel.certificateInfo.licenedChildcarerCertificatePath = response;
                  break;
              case CretificateTypeBabySittingChild:
                  weakeSelf.profileModel.certificateInfo.childrenCheckCertificatePath = response;
                  break;
              case CretificateTypeBabySittingPolice:
                  weakeSelf.profileModel.certificateInfo.policeCheckCertificatePath = response;
                  break;
              case CretificateTypeBabySittingLicense:
                  weakeSelf.profileModel.certificateInfo.licenedChildcarerCertificatePath = response;
                  break;
                  
              default:
                  break;
          } 
          [SVProgressHUD dismiss];
      } withFailureBlock:^(NSString *error) {
          [SVProgressHUD showErrorWithStatus:error];
      }];
}
#pragma mark - save 
- (BOOL)checkAvilible{
 
    
    if(_lbAboutMe.text.length == 0 ||
       self.profileModel.certificateInfo.childCheckReferenceNumber.length == 0 ||
       self.profileModel.certificateInfo.childCheckExpiryDate.length == 0 ||
       self.profileModel.certificateInfo.childrenCheckCertificatePath.length == 0 ||
       self.profileModel.certificateInfo.policeCheckCardNo.length == 0 ||
       self.profileModel.certificateInfo.policeCheckExpiryDate.length == 0 ||
       self.profileModel.certificateInfo.policeCheckCertificatePath.length == 0){
        [SVProgressHUD showErrorWithStatus:@"Please fill in all the fields before saving."];return NO;
    }
   
    return YES;
}

- (void)showSuccessAlert{
    UIAlertController *alertController = [UIAlertController 
                       alertControllerWithTitle:@"Thank you for your application." 
                       message:@"Your Police Check and Working with Children’s Check has been sent for review. You will receive an update soon."
                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Go Back" 
                                                           style:UIAlertActionStyleCancel 
                                                         handler:^(UIAlertAction * _Nonnull action) { 
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Continue" 
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) { 
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       }];
    [alertController addAction:saveAction];
    [self presentViewController:alertController animated:YES completion:^{ 
    }];
}

- (void)save:(id)sender{
//    [self showSuccessAlert];return;
    // [self updateUserIcon:self.userImage];
    __block typeof(self) weakeSelf = self;
    
    self.profileModel.fullName = _tfFullName.text;
    self.profileModel.aboutMe = _lbAboutMe.text;  
  //  self.profileModel.address = @"Xi'an, Shaanxi Province, China.";
    
    self.profileModel.certificateInfo.childCheckReferenceNumber = _tfChildrenCheckNum.text;
    self.profileModel.certificateInfo.childCheckExpiryDate = _tfChildrenCheckExpiryDate.text; 
    self.profileModel.certificateInfo.policeCheckCardNo = _tfPoliceCheckNum.text;
    self.profileModel.certificateInfo.policeCheckExpiryDate = _tfPoliceCheckExpiryDate.text;
    
    if (self.roleType == UserRoleTypeBabySitting) {
        self.profileModel.babysittingAboutMe = self.profileModel.aboutMe;
    }
    if (self.roleType == UserRoleTypeShareCare) {
        self.profileModel.sharecareAboutMe = self.profileModel.aboutMe;
    }
    self.profileModel.babysittingCertificateInfo = self.profileModel.certificateInfo;
    self.profileModel.sharecareCertificateInfo = self.profileModel.certificateInfo;
    self.profileModel.shareType = SHARE_TYPE_FOR(self.roleType);
    
    if([self checkAvilible] == NO) return;
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithDictionary:[self.profileModel convertToDictionary]];
    NSLog(@"%@",parameter);
    
    [SVProgressHUD showWithStatus:TEXT_LOADING]; 
    [ShareCareHttp POST:API_UPDATE_USERINFO withParaments:parameter 
       withSuccessBlock:^(id response) {
           
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
           [SVProgressHUD dismiss];
           [weakeSelf showSuccessAlert];
        //   [SVProgressHUD showSuccessWithStatus:@"Save success"];
           
       } withFailureBlock:^(NSString *error) {
           [SVProgressHUD showErrorWithStatus:error];
       }];
    
}

@end
