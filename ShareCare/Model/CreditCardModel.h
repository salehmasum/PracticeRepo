//
//  CreditCardModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"

@interface CreditCardModel : BaseModel

@property (nonatomic, copy) NSString  *addressLine1;
@property (nonatomic, copy) NSString  *addressLine2;
@property (nonatomic, copy) NSString  *bankBranch;
@property (nonatomic, copy) NSString  *bankName;
@property (nonatomic, copy) NSString  *bsb;
@property (nonatomic, copy) NSString  *cardNumber;

//int 类型 0 银行卡 1信用卡  3 paypal  4 其它 ......
@property (nonatomic, copy) NSString  *cardType;

@property (nonatomic, copy) NSString  *city;
@property (nonatomic, copy) NSString  *email;
@property (nonatomic, copy) NSString  *expirationDate;
@property (nonatomic, copy) NSString  *firstName;
@property (nonatomic, copy) NSString  *lastName;
@property (nonatomic, copy) NSString  *payee;
@property (nonatomic, copy) NSString  *securityCode;
@property (nonatomic, copy) NSString  *state;
@property (nonatomic, copy) NSString  *zipCode;

@end
