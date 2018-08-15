//
//  CreditCardModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "CreditCardModel.h"

@implementation CreditCardModel
- (instancetype)init{
    if (self = [super init]) { 
        _addressLine1 = @""; 
        _addressLine2 = @"";
        _bankBranch = @"";
        _bankName = @"";
        _bsb = @"";
        _cardNumber = @""; 
        _cardType = @"";
        _city = @"";
        _email = @"";
        _expirationDate = @"";
        _firstName = @"";
        _lastName = @"";
        _payee = @"";
        _securityCode = @"";
        _state = @"";
        _zipCode = @"";
        
        
        return self;
    }
    return nil;
} 

- (NSString *)cardType{
    return [NSString stringWithFormat:@"%@",_cardType];
}

@end

