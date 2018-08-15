//
//  ProfileModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ProfileModel.h"

@implementation     ProfileModel
- (instancetype)init{
    if (self = [super init]) { 
//        _babysittingCertificateInfo = [[CertificateInfoModel alloc] init];
//        _shareCareCertificateInfo = [[CertificateInfoModel alloc] init];
        _certificateInfo = [[CertificateInfoModel alloc] init];
        _sharecareCertificateInfo = [[CertificateInfoModel alloc] init];
        _babysittingCertificateInfo = [[CertificateInfoModel alloc] init];
        _fullName = @""; 
        _aboutMe = @"";
        _contactNumber = @"";
        _emergencyContact = @""; 
        _userIcon = @"";
        _children = @[];
        _userId = @"";
        _name = @"";
        _shareType = @"";//SHARECATE,BABYSITTING,EVENT
        _address = @"";//@"Technology Road 37,High-tech District ,Xi'an";
        _addressLat = 0;
        _addressLon = 0;
        _isValidCertificate = NO;
        _isAudit = @"0"; 
        _babysittingAudit = 2;
        _sharecareAudit = 2;
        _bindingCard = false;
        
        return self;
    }
    return nil;
}

- (BOOL)isValidCertificate{ 
    if (_certificateInfo.childCheckExpiryDate.length &&
        _certificateInfo.childCheckReferenceNumber.length &&
        _certificateInfo.childrenCheckCertificatePath.length &&
        _certificateInfo.policeCheckCardNo.length &&
        _certificateInfo.policeCheckExpiryDate.length &&
        _certificateInfo.policeCheckCertificatePath.length) {
        return YES;
    }
    
    return NO;
}
 
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"key:%@,vale:%@",key,value); 
    if ([key isEqualToString:@"childrens"] ) {
        if ([value isKindOfClass:[NSNull class]] || ![value isKindOfClass:[NSArray class]]) { 
            _children = @[];
        } 
    }
    
//    if ([key isEqualToString:@"babysittingCertificateInfo"]) { 
//        if ( [value isKindOfClass:[NSNull class]]) {
//            _babysittingCertificateInfo = [[CertificateInfoModel alloc] init];
//        }else{
//            _babysittingCertificateInfo = [CertificateInfoModel modelWithDictionary:value];
//        } 
//        
//    }
//    if ([key isEqualToString:@"shareCareCertificateInfo"]) {
//        
//        if ( [value isKindOfClass:[NSNull class]]) {
//            _shareCareCertificateInfo = [[CertificateInfoModel alloc] init];
//        }else{
//            _shareCareCertificateInfo = [CertificateInfoModel modelWithDictionary:value];
//        } 
//    }
//    
    if ([key isEqualToString:@"certificateInfo"]) {
        
        if ( [value isKindOfClass:[NSNull class]]) {
            _certificateInfo = [[CertificateInfoModel alloc] init];
        }else{
            _certificateInfo = [CertificateInfoModel modelWithDictionary:value];
        } 
    }
}
- (void)setChildren:(NSArray *)children{ 
    if ([children isKindOfClass:[NSArray class]]) { 
        
        NSMutableArray *array = [NSMutableArray array];
        for (id object in children) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                ChildrenModel *child  = [ChildrenModel modelWithDictionary:object];
                [array addObject:child];
            }else if ([object isKindOfClass:[ChildrenModel class]]){
                
                [array addObject:object];
            }
        }
        
        _children = array;
        
    }
}
- (void)setSharecareCertificateInfo:(CertificateInfoModel *)sharecareCertificateInfo{
    if (!sharecareCertificateInfo) {
        _sharecareCertificateInfo = [[CertificateInfoModel alloc] init];
    }else if ([sharecareCertificateInfo isKindOfClass:[NSDictionary class]]) {
        _sharecareCertificateInfo = [CertificateInfoModel modelWithDictionary:(NSDictionary *)sharecareCertificateInfo];
    }else if ([sharecareCertificateInfo isKindOfClass:[CertificateInfoModel class]]) {
        _sharecareCertificateInfo = sharecareCertificateInfo;
    }
}
- (void)setBabysittingCertificateInfo:(CertificateInfoModel *)babysittingCertificateInfo{
    if (!babysittingCertificateInfo) {
        _babysittingCertificateInfo = [[CertificateInfoModel alloc] init];
    }else if ([babysittingCertificateInfo isKindOfClass:[NSDictionary class]]) {
        _babysittingCertificateInfo = [CertificateInfoModel modelWithDictionary:(NSDictionary *)babysittingCertificateInfo];
    }else if([babysittingCertificateInfo isKindOfClass:[CertificateInfoModel class]]) {
        _babysittingCertificateInfo = babysittingCertificateInfo;
    }
} 

- (void)setCertificateInfo:(CertificateInfoModel *)certificateInfo{
    if (!certificateInfo) {
        _certificateInfo = [[CertificateInfoModel alloc] init];
    }else if ([certificateInfo isKindOfClass:[NSDictionary class]]) {
        _certificateInfo = [CertificateInfoModel modelWithDictionary:(NSDictionary *)certificateInfo];
    }else if([certificateInfo isKindOfClass:[CertificateInfoModel class]]) {
        _certificateInfo = certificateInfo;
    }
}

- (NSString *)name{
    if (_fullName.length) {
        return _fullName;
    }
    return _name;
}

@end
@implementation CertificateInfoModel
- (instancetype)init{    
    if (self = [super init]) { 
        _childCheckExpiryDate = @"";
        _childCheckReferenceNumber = @"";
        _childrenCheckCertificatePath = @"";
        _licenedChildcarerCertificatePath = @"";
        _policeCheckCardNo = @"";
        _policeCheckCertificatePath = @"";
        _policeCheckExpiryDate = @"";
        return self;    
    }   
    return nil;
}
@end
