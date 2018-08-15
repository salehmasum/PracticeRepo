//
//  ReviewBookingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/28.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ReviewBookingVC.h"
#import "BookingRequestCell.h"
#import "ShareCareModel.h"
#import "EventPaymentAndBillingVC.h"
#import "EventPaymentGuidVC.h"
#import "ChildrenModel.h"

@interface ReviewBookingVC ()<UITableViewDataSource,UITableViewDelegate>{
    
    id _bookingId;
    NSString *_clientToken;
}

@property (strong, nonatomic) CreditCardModel *paymentCard;
@property (strong, nonatomic) ShareCareModel *shareCare;
@end

@implementation ReviewBookingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.paymentCard = [[CreditCardModel alloc] init];
    
    UINib *checkNib = [UINib nibWithNibName:NSStringFromClass([BookingRequestCell class]) bundle:nil];
    [self.tableView registerNib:checkNib forCellReuseIdentifier:@"BookingRequestCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.tableFooterView = _footerView;
    
    self.headerImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 124, 153)];
    self.headerImageView.center = CGPointMake((TX_SCREEN_WIDTH-84), 80);
    [self.tableView addSubview:self.headerImageView];
    
    
    _imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 124, 124)];
    _imgHeader.contentMode = UIViewContentModeScaleAspectFill;
    _imgHeader.clipsToBounds = YES;
    [self.headerImageView addSubview:_imgHeader];
    _imgHosted = [[UIImageView alloc] initWithFrame:CGRectMake((124-58), 124-29, 58, 58)];
    _imgHosted.contentMode = UIViewContentModeScaleAspectFill;
    _imgHosted.clipsToBounds = YES;
    _imgHosted.layer.masksToBounds = YES;
    _imgHosted.layer.cornerRadius = (58)/2.0;
    _imgHosted.layer.borderColor = COLOR_WHITE.CGColor;
    _imgHosted.layer.borderWidth = 2;
    [self.headerImageView addSubview:_imgHosted];
    
    [self.btEditPayment addTarget:self action:@selector(editpaymentMethod:) forControlEvents:UIControlEventTouchUpInside];
    _paymentMethods = @[];
    
    [self initData];
    
    
  //  self.paymentMethodTypeIcon = [BTUIKPaymentOptionCardView new];
  //  self.paymentMethodTypeIcon.translatesAutoresizingMaskIntoConstraints = NO;
   // [self.view addSubview:self.paymentMethodTypeIcon];
    self.paymentMethodTypeIcon.hidden = YES;
    
    self.lbPaymentMethod.hidden = NO;
    
    _clientToken = nil;//[self testToken];
    
//    [SVProgressHUD showWithStatus:TEXT_LOADING];
//    __weak typeof(self) weakSelf = self;
//    [ShareCareHttp GET:API_PAYMENT_TOKEN withParaments:@[[Util uuid],@"2"] withSuccessBlock:^(id response) {
//     //   [weakSelf showDropIn:response]; 
//        if (response) {
//            _clientToken = response;
//            [weakSelf fetchExistingPaymentMethod:response];
//        }else{
//            [SVProgressHUD dismiss];
//        }
//    } withFailureBlock:^(NSString *error) {
//        [SVProgressHUD showErrorWithStatus:error];
//    }];
    
   
}

- (void)initData{
    
    _dataSource = _booking.times;
    _booking.peopleNums = NSStringFromInt(_booking.whoIsComings.count);
   // 
    NSInteger stayDays = [self.booking.stayDays integerValue];
    self.booking.stayDays =NSStringFromInt(stayDays>0?stayDays:1);
    
    [_imgHeader setImageWithURL:[NSURL URLWithString:URLStringForPath(_booking.firstPic)] placeholderImage:kDEFAULT_IMAGE];
    [_imgHosted setImageWithURL:[NSURL URLWithString:URLStringForPath(_booking.userIcon)] placeholderImage:kDEFAULT_HEAD_IMAGE];
    
    {
        NSString *hostedStr =[NSString stringWithFormat:@"Hosted by %@",_booking.userName];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:hostedStr];
        NSRange range = [hostedStr rangeOfString:_booking.userName];
        [attributedString addAttribute:NSForegroundColorAttributeName value:COLOR_BLUE range:range];
        _lbHosted.attributedText = attributedString;
    }
    
    {
        if (self.booking.careType.integerValue == 2) {
            NSInteger hasSelf = 0;
            for (ChildrenModel *child in self.booking.whoIsComings) {
                hasSelf = [child.fullName isEqualToString:kUSER_NAME];
            }
            
            NSString *priceStr =nil;
            if ([self.booking.adultPrice floatValue]>0) {
                
                priceStr = [NSString stringWithFormat:@"$%@ x1 Adult",self.booking.adultPrice];
            }
            if ([self.booking.unitPrice floatValue]>0) {
                priceStr = [NSString stringWithFormat:@"%@%@$%@ x %ld Child",priceStr?priceStr:@"",priceStr?@" + ":@"",self.booking.unitPrice,self.booking.whoIsComings.count-hasSelf];
            }
            
        //    NSString *culateInfo = childStr;
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceStr];
            
            
                NSRange range = [priceStr rangeOfString:[NSString stringWithFormat:@"$%@",self.booking.unitPrice]];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
                range = [priceStr rangeOfString:@"Child"];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
            
                range = [priceStr rangeOfString:[NSString stringWithFormat:@"$%@",self.booking.adultPrice]];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
                range = [priceStr rangeOfString:@"Adult"];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
            
            CGFloat total = 0;
            total = total+self.booking.adultPrice.floatValue;
             total = total+self.booking.unitPrice.floatValue*(self.booking.whoIsComings.count-hasSelf);
            
            _booking.totalPrice = [NSString stringWithFormat:@"%.2f",total];
            _lbCalculateInfo.attributedText = attributedString;
            
        }else{
            _booking.totalPrice = [NSString stringWithFormat:@"%.2f",_booking.stayDays.integerValue*_booking.unitPrice.floatValue*_booking.whoIsComings.count];
            NSString *culateInfo = [NSString stringWithFormat:@"x %@ %@ x %ld Child",_booking.stayDays,_booking.unitPriceStr,_booking.whoIsComings.count];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:culateInfo];
            NSRange range = [culateInfo rangeOfString:_booking.unitPriceStr];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
            range = [culateInfo rangeOfString:@"Child"];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
            _lbCalculateInfo.attributedText = attributedString;
        }
    }
    
    
  //  _btRequestBook.enabled=YES;
    
    
    _lbInfoPrice.text = [NSString stringWithFormat:@"$%@",_booking.totalPrice];
    _lbTotal.text = [NSString stringWithFormat:@"$%@",_booking.totalPrice];
    
   // self.booking = [[BookingModel alloc] init];
    self.booking.careId = ((ShareCareModel *)self.item).idValue;
    
 
    
}
//选择支付方式
- (void)editpaymentMethod:(id)sender{
//    [self requestToken];return;
    __weak typeof(self) weakSelf = self;
    EventPaymentAndBillingVC *paymentVC  = [[EventPaymentAndBillingVC alloc] init];
    paymentVC.payBlock = ^(CreditCardModel *card) {
        
        if (card.cardType.integerValue == 2) {
            weakSelf.lbPaymentMethod.text = [NSString stringWithFormat:@"%@",card.email];
        }else if (card.cardType.integerValue == 0) {
            
            weakSelf.lbPaymentMethod.text = [NSString stringWithFormat:@"%@ %@",card.firstName,card.lastName];
        }
        weakSelf.paymentCard = card;
        weakSelf.btRequestBook.enabled = YES;
        [weakSelf.btEditPayment setTitle:@"Edit" forState:UIControlStateNormal];
        
    };
    [self.navigationController pushViewController:paymentVC animated:YES]; 
  //  [self requestToken];
}
//添加支付方式
- (void)addPaymentMethod:(id)sender{
    __weak typeof(self) weakSelf = self;
    EventPaymentAndBillingVC *paymentVC  = [[EventPaymentAndBillingVC alloc] init];
    paymentVC.payBlock = ^(CreditCardModel *card) {
        weakSelf.lbPaymentMethod.text = [NSString stringWithFormat:@"%@ %@",card.firstName,card.lastName];
    };
    [self.navigationController pushViewController:paymentVC animated:YES]; 
//    [self requestToken];
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count>2?_dataSource.count:2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row>=_dataSource.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        
        BookingRequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BookingRequestCell" 
                                                                   forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbDateTile.text = self.dateTitle;
        cell.lbTimeTitle.text = self.timeTitle;
        cell.lbDate.text = _dataSource[indexPath.row][@"day"];
        cell.lbTime.text = _dataSource[indexPath.row][@"time"];
        return cell;
    }
    
} 

- (NSString *)dateTitle{
    return @"Date:";
}
- (NSString *)timeTitle{
    return @"Time:";
}

- (IBAction)requestToBook:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    NSString *msg = [NSString stringWithFormat:@"%@No payment will be processed until the booking is confirmed. A 50%% cancellation fee will apply if you cancel 24 hours before otherwise you will receive a full refund. ",kUSER_LOGIN_STATE==LoginStateEmail?[NSString stringWithFormat:@"A confirmation email will be sent through to %@. ",kUSER_EMAIL]:@""];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Your Booking Request has been sent." 
                                                                             message:msg 
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"Go Back" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // [weakSelf.navigationController popToRootViewControllerAnimated:NO];
      //  [weakSelf sendRequest];
        
        [weakSelf confirmBookingRequest];
    }];
    [alertController addAction:CancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)requestToken{
    if (_clientToken == nil) {
        [SVProgressHUD showWithStatus:TEXT_LOADING];
        __weak typeof(self) weakSelf = self;
        [ShareCareHttp GET:API_PAYMENT_TOKEN withParaments:@[[Util uuid],@"2"] withSuccessBlock:^(id response) {
            
            if (response) {
                _clientToken = response;
                [weakSelf showDropIn:response];
                [SVProgressHUD dismiss];
            } else{
                [SVProgressHUD showErrorWithStatus:@"request faild"];
            }
        } withFailureBlock:^(NSString *error) {
            [SVProgressHUD showErrorWithStatus:error];
        }];
    }else{
        [self showDropIn:_clientToken];
    }
   
    
    
}

- (void)showDropIn:(NSString *)clientTokenOrTokenizationKey {
    
    _clientToken = clientTokenOrTokenizationKey;
    
    BTDropInRequest *request = [[BTDropInRequest alloc] init];
   // request.applePayDisabled = YES;
    request.threeDSecureVerification = YES;
    BTDropInController *dropIn = [[BTDropInController alloc] initWithAuthorization:clientTokenOrTokenizationKey request:request handler:^(BTDropInController * _Nonnull controller, BTDropInResult * _Nullable result, NSError * _Nullable error) {
        
        if (error != nil) {
            NSLog(@"ERROR");
            [SVProgressHUD showErrorWithStatus:error.description];
        } else if (result.cancelled) {
            NSLog(@"CANCELLED");
           // [SVProgressHUD showErrorWithStatus:@"Cancel"];
        } else {
            // Use the BTDropInResult properties to update your UI
            // result.paymentOptionType
            // result.paymentMethod
            // result.paymentIcon
            // result.paymentDescription
            
            
            NSLog(@"result.paymentOptionType=%ld,\nresult.paymentMethod=%@,\nresult.paymentIcon%@,\nresult.paymentDescription%@",result.paymentOptionType,result.paymentMethod.nonce,result.paymentIcon,result.paymentDescription);
            
            self.paymentEmailOrCardNumber = result.paymentDescription;
            self.paymentOptionType = result.paymentOptionType;
            self.selectedNonce = result.paymentMethod;
            [self updatePaymentMethod:self.selectedNonce];
        }
        
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:dropIn animated:YES completion:nil];
}
- (void)fetchExistingPaymentMethod:(NSString *)clientToken {
    [BTDropInResult fetchDropInResultForAuthorization:clientToken 
                                              handler:^(BTDropInResult * _Nullable result, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"ERROR");
        } else {
            self.paymentOptionType = result.paymentOptionType;
            self.selectedNonce = result.paymentMethod;
            self.paymentEmailOrCardNumber = result.paymentDescription;
            [self updatePaymentMethod:self.selectedNonce];
            
            
            
                  NSLog(@"result.paymentOptionType=%ld,\nresult.paymentMethod=%@,\nresult.paymentIcon%@,\nresult.paymentDescription:%@",result.paymentOptionType,result.paymentMethod.nonce,result.paymentIcon,result.paymentDescription);
        }
        
        [SVProgressHUD dismiss];
    }];
}


//创建订单
- (void)confirmBookingRequest{
    __weak typeof(self) weakSelf = self;
    
   // self.booking.timePeriod = self.booking.whoIsComings.firstObject[@"timePeriod"];
    
    NSMutableDictionary *dic= [NSMutableDictionary dictionaryWithDictionary:[self.booking convertToDictionary]];
    
    
    NSString *startDate = dic[@"startDate"];
    NSString *endDate = dic[@"endDate"];
    [dic setObject:[startDate stringByReplacingOccurrencesOfString:@"T" withString:@" "] forKey:@"startDate"];
    [dic setObject:[endDate stringByReplacingOccurrencesOfString:@"T" withString:@" "] forKey:@"endDate"];
    [dic setObject:_paymentCard.idValue forKey:@"creditCardId"];
    NSLog(@"%@",dic);//return;
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    [ShareCareHttp POST:API_BOOKING_APPOINT withParaments:dic withSuccessBlock:^(id response) { 
        NSLog(@"%@",response);
//        [SVProgressHUD showSuccessWithStatus:@"Success"];
//        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        [weakSelf payWithNoce:self.selectedNonce.nonce paymentType:self.paymentOptionType bookingId:(id)response];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error]; 
    }];
}
- (void)payWithNoce:(NSString *)noce 
        paymentType:(BTUIKPaymentOptionType)paymentType 
          bookingId:(id)bookingId{
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"amount"     : self.booking.totalPrice,
                          @"careType"   :self.booking.careType,
                          @"childNums"  : NSStringFromInt(self.booking.whoIsComings.count),
                          @"days"       : self.booking.stayDays,
                          @"paymentMethodNonce": @"",
                          @"paymentType": @"",
                          @"shareId"    : self.booking.careId,
                          @"unitPrice"  : self.booking.unitPrice,
                          @"paymentEmailOrCardNumber":_paymentCard.cardType.integerValue==2?_paymentCard.email:_paymentCard.cardNumber,
                          @"bookingId"  :bookingId,
                          @"toUserName" :self.booking.accountId,
                          @"pubAccountId":self.booking.accountId
                          };
    
    [ShareCareHttp POST:API_PAYMENT_TRANSACTION withParaments:dic withSuccessBlock:^(id response) {
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
    
}

- (void) updatePaymentMethod:(BTPaymentMethodNonce*)paymentMethodNonce {
    self.paymentMethodTypeLabel.hidden = paymentMethodNonce == nil;
    self.paymentMethodTypeIcon.hidden = paymentMethodNonce == nil;
    self.lbPaymentMethod.hidden = paymentMethodNonce != nil;
    if (paymentMethodNonce != nil) {
        BTUIKPaymentOptionType paymentMethodType = [BTUIKViewUtil paymentOptionTypeForPaymentInfoType:paymentMethodNonce.type];
        self.paymentMethodTypeIcon.paymentOptionType = paymentMethodType;
        [self.paymentMethodTypeLabel setText:paymentMethodNonce.localizedDescription];
        
        self.btRequestBook.enabled = YES;
        _lbPaymentMethod.text = _paymentMethods.firstObject;
        [self.btEditPayment setTitle:@"Edit" forState:UIControlStateNormal];
    }else{
        self.btRequestBook.enabled = NO;
        _lbPaymentMethod.text = @"Payment and Billing";
        [self.btEditPayment setTitle:@"Add" forState:UIControlStateNormal];
    }
    
    
  
} 
@end
