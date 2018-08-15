//
//  ReviewBookingVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/28.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookingModel.h"
#import "UIViewController+Braintree.h"

@interface ReviewBookingVC : UIViewController
@property (strong, nonatomic) id item;
@property (strong, nonatomic) BookingModel *booking; 
@property (strong, nonatomic) NSArray *paymentMethods;

@property (weak, nonatomic) IBOutlet UIButton *btRequestBook;
@property (strong, nonatomic) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *lbHosted;
@property (weak, nonatomic) IBOutlet UIButton *btEditPayment;
@property (weak, nonatomic) IBOutlet UILabel *lbCalculateInfo;
@property (weak, nonatomic) IBOutlet UILabel *lbInfoPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbPaymentMethod;
@property (strong, nonatomic) UIView *headerImageView;
@property (strong, nonatomic) UIImageView *imgHeader;
@property (strong, nonatomic) UIImageView *imgHosted;


@property (strong, nonatomic) NSString *dateTitle;
@property (strong, nonatomic) NSString *timeTitle;

@property (nonatomic, strong) NSString *paymentEmailOrCardNumber;
@property (nonatomic, strong) BTPaymentMethodNonce *selectedNonce;
@property (nonatomic, assign) BTUIKPaymentOptionType paymentOptionType;
@property (weak, nonatomic) IBOutlet BTUIKPaymentOptionCardView *paymentMethodTypeIcon;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodTypeLabel;
@end
