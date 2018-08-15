//
//  ProfileModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"
#import "ChildrenModel.h"

@class CertificateInfoModel;
@interface ProfileModel : BaseModel
@property (copy, nonatomic) NSString *shareType;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *address;
@property (assign, nonatomic) double addressLat;
@property (assign, nonatomic) double addressLon;
@property (copy, nonatomic) NSString *userIcon;
@property (copy, nonatomic) NSString *aboutMe;
@property (copy, nonatomic) NSString *fullName;
@property (copy, nonatomic) NSString *contactNumber;
@property (copy, nonatomic) NSString *emergencyContact; 
@property (strong, nonatomic) CertificateInfoModel *certificateInfo;
@property (strong, nonatomic) CertificateInfoModel *babysittingCertificateInfo;
@property (strong, nonatomic) CertificateInfoModel *sharecareCertificateInfo;
@property (strong, nonatomic) NSArray *children;
@property (strong, nonatomic) NSString *isAudit;
@property (assign, nonatomic) BOOL isValidCertificate;
@property (assign, nonatomic) NSInteger babysittingAudit;
@property (assign, nonatomic) NSInteger sharecareAudit;
@property (assign, nonatomic) NSInteger babysittingChildCheck;
@property (assign, nonatomic) NSInteger babysittingLicense;
@property (assign, nonatomic) NSInteger babysittingPoliceCheck;
@property (assign, nonatomic) NSInteger shareCareChildCheck;
@property (assign, nonatomic) NSInteger shareCarePoliceCheck;
@property (copy, nonatomic) NSString *babysittingAboutMe ;
@property (copy, nonatomic) NSString *sharecareAboutMe;
@property (assign, nonatomic) BOOL bindingCard;

@end 
@interface CertificateInfoModel : BaseModel
@property (copy, nonatomic) NSString *childCheckExpiryDate;
@property (copy, nonatomic) NSString *childCheckReferenceNumber;
@property (copy, nonatomic) NSString *childrenCheckCertificatePath;
@property (copy, nonatomic) NSString *licenedChildcarerCertificatePath;
@property (copy, nonatomic) NSString *policeCheckCardNo;
@property (copy, nonatomic) NSString *policeCheckCertificatePath;
@property (copy, nonatomic) NSString *policeCheckExpiryDate;
@end
 
