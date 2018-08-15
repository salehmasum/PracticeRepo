//
//  AddBankTransferVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditCardModel.h"

@interface AddBankTransferVC : UIViewController

@property (strong, nonatomic) CreditCardModel *card;
@property (assign, nonatomic) BOOL isEdit;
@end
