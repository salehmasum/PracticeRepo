//
//  ShareCarePaymentCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/14.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h> 
typedef void(^PaymentMethodEditBlock)(NSInteger index);

@interface ShareCarePaymentCell : UITableViewCell
@property (strong, nonatomic) PaymentMethodEditBlock editBlock;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *lbPayName;
@property (assign, nonatomic) NSInteger row;
@property (weak, nonatomic) IBOutlet UILabel *lbBankName;
@end
