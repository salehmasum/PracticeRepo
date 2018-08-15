//
//  EventPaymentAndBillingVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCardModel.h"

typedef void(^ChoosePaymentmethodBlock)(CreditCardModel *creditCard);

@interface EventPaymentAndBillingVC : UIViewController

@property (strong,nonatomic)ChoosePaymentmethodBlock payBlock;
@end
