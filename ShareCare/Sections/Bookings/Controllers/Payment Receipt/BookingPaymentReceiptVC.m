//
//  BookingPaymentReceiptVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BookingPaymentReceiptVC.h"
#import "TimeModel.h"
#import "WhosComingCell.h"

@interface BookingPaymentReceiptVC (){
    NSInteger _cellCount;
    NSArray *_childrens;
}
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;
@property (weak, nonatomic) IBOutlet UIImageView *lbUserIcon;
@property (weak, nonatomic) IBOutlet UILabel *lbConfirmCode;
@property (weak, nonatomic) IBOutlet UILabel *lbAppointTime;
@property (weak, nonatomic) IBOutlet UILabel *lbReseipt;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbReceivedTime;
@property (weak, nonatomic) IBOutlet UILabel *lbPaymentDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbAmount;
@property (weak, nonatomic) IBOutlet UILabel *lbTotal;
@property (weak, nonatomic) IBOutlet UILabel *lbPayment;
@property (weak, nonatomic) IBOutlet UILabel *lbPaymentMethod;
@property (weak, nonatomic) IBOutlet UILabel *lbBalance;
@property (weak, nonatomic) IBOutlet UILabel *lbTransactionFaild;
@property (weak, nonatomic) IBOutlet UILabel *lbFaildInfo;

@end

@implementation BookingPaymentReceiptVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.shadowImage = [UIImage new]; 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _cellCount = 0;
    _childrens = @[];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"bookingtime"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"booking"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WhosComingCell class]) bundle:nil]
         forCellReuseIdentifier:@"WhosComingCell"];
    
    [self requestPaymentReceipt];
}

- (void)requestPaymentReceipt{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:TEXT_LOADING];//
    [ShareCareHttp GET:API_PAYMENT_RECEIPT withParaments:@[_booking.bookingId,_booking.careType,_booking.typeId] withSuccessBlock:^(id response) {
        [weakSelf updateUIWithDic:response];
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) { 
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)updateUIWithDic:(NSDictionary *)result{
    self.view.backgroundColor = [UIColor whiteColor];
    _lbUserIcon.layer.masksToBounds = YES;
    _lbUserIcon.layer.cornerRadius = CGRectGetWidth(_lbUserIcon.frame)/2;
    
    if (_booking.whoIsComings.count) {
        NSString *timePeriod = _booking.whoIsComings.firstObject[@"timePeriod"];
        if ([timePeriod containsString:@"T"]) {
            _booking.times = [timePeriod componentsSeparatedByString:@"|"];
        }else{
            _booking.times = @[[NSString stringWithFormat:@"%@ - %@",_booking.startDate,_booking.endDate]];
        }
    }
    NSLog(@"%@",URLStringForPath(_booking.userIcon));
    _lbUserName.text = _booking.userName;
    [_lbUserIcon setImageWithURL:[NSURL URLWithString:URLStringForPath(_booking.userIcon)] 
                placeholderImage:kDEFAULT_HEAD_IMAGE];
    
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    CGRect headerRect = self.headerView.frame;
    
    
    
  //  NSArray *childs = result[@"childrenInfos"];
    NSInteger careType = self.booking.careType.integerValue;
    CGFloat unitPrice = [result[@"unitPrice"] floatValue];
    NSInteger days = [result[@"days"] integerValue];
    NSInteger childNums = [result[@"childNums"] integerValue];
    
    TimeModel *time = [[TimeModel alloc] init];
    time.timeString = result[@"bookingTime"];
    
    _lbConfirmCode.text   = [NSString stringWithFormat:@"Confirmation Code:%@",result[@"confirmationCode"]];
    _lbAppointTime.text   = [NSString stringWithFormat:@"%@,%@ %@,%@",time.week,time.shortMonth,time.day,time.year];
    _lbReseipt.text       = [NSString stringWithFormat:@"Receipt # %@",result[@"receiptCode"]];
    
    NSString *address = result[@"address"];
    _lbAddress.text       = [address stringByReplacingOccurrencesOfString:ADDRESS_SEPARATED_STRING withString:@","];
    
    time.timeString = result[@"paymentReceivedTime"];
    _lbReceivedTime.text  = [NSString stringWithFormat:@"%@,%@ %@,%@",time.week,time.shortMonth,time.day,time.year];
    
    _lbPaymentDetail.text = [NSString stringWithFormat:@"x%@ $%@/%@ x%lu child",result[@"days"],result[@"unitPrice"],careType==0?@"day":(careType==1?@"hr":@""),(unsigned long)childNums];
    _lbAmount.text        = [NSString stringWithFormat:@"$%.2f",unitPrice*days*childNums];
    _lbTotal.text         = [NSString stringWithFormat:@"$%.2f",unitPrice*days*childNums];
    _lbPayment.text       = [NSString stringWithFormat:@"$%.2f",unitPrice*days*childNums];
    _lbPaymentMethod.text = [NSString stringWithFormat:@"(%@)",result[@"masterCard"]];
    _lbBalance.text       = [NSString stringWithFormat:@"Balance $0 AUD"];
    NSString *timePeriod  = result[@"timePeriod"];
     if ([timePeriod containsString:@"T"]) {
         _booking.times = [timePeriod componentsSeparatedByString:@"|"];
     }else{
         _booking.times = @[[NSString stringWithFormat:@"%@ - %@",_booking.startDate,_booking.endDate]];
     }
    
    _cellCount = _booking.times.count;
    
    _childrens = result[@"childrenInfos"];
    [self.tableView reloadData];
    
 
    /*
     0. Your Booking is pending.
     1. Transaction Succeeds.
     2. Your booking is cancelled, refunded.
     3. Transaction Failed.
     */
    
    _lbFaildInfo.hidden = YES;
    NSInteger paymentStatus = [result[@"paymentStatus"] integerValue];
    
    switch (paymentStatus) {
        case 0:
        _lbTransactionFaild.text = @"Your Booking is pending.";
        _lbTransactionFaild.textColor = TX_RGB(255, 216, 0);
        break;
        
        case 1:
        _lbTransactionFaild.text = @"Transaction Succeeds.";
        _lbTransactionFaild.textColor = TX_RGB(102, 216, 137);
        break;
        
        case 2:
        _lbTransactionFaild.text = @"Your booking is cancelled, refunded.";
        _lbTransactionFaild.textColor = TX_RGB(255, 0, 0);
        _lbFaildInfo.hidden = NO;
        break;
        
        case 3:
        _lbTransactionFaild.text = @"Transaction Failed.";
        _lbTransactionFaild.textColor = TX_RGB(255, 0, 0);
        break; 
        
        default:
        break;
    }
    
//    if (paymentStatus) {
//        _lbTransactionFaild.hidden = YES;
//        _lbFaildInfo.hidden = YES;
//        headerRect.size.height = 128*TX_SCREEN_OFFSET;
//    } 
//    
//    self.headerView.frame = headerRect;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return _cellCount;
    }else if (section==1){
        return 1;
    }
    return _childrens.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        return 55;
    }
    return 84*TX_SCREEN_OFFSET;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"bookingtime" forIndexPath:indexPath];
        // Configure the cell...
        cell.textLabel.textColor = TX_RGB(90, 90, 90);
        cell.textLabel.font = TX_FONT(15);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //  cell.textLabel.text = @"20 May 2017 • 11:00am - 2:00pm";
        
        NSString *string = _booking.times[indexPath.row];
        string = [string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        cell.textLabel.text = [self configStartDate:[string componentsSeparatedByString:@" - "][0] endDate:[string componentsSeparatedByString:@" - "][1]];
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"booking" forIndexPath:indexPath];
        
        cell.textLabel.textColor = TX_RGB(90, 90, 90);
        cell.textLabel.font = TX_FONT(20);
        cell.textLabel.text = @"Attendee/s";
        cell.indentationLevel = 1.5;
        
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(23, 2, 319*TX_SCREEN_OFFSET, 1.5)];
        line.center = CGPointMake(TX_SCREEN_WIDTH/2, 1);
        line.image = [UIImage imageNamed:@"line"];
        [cell addSubview:line];
        
        
        return cell;
    }
    if (indexPath.section == 2) {
        WhosComingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WhosComingCell" 
                                                               forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ChildrenModel *children = [ChildrenModel modelWithDictionary:_childrens[indexPath.row]];
        //  children.state = ChildStateConfirmed; 
        children.myChild = YES;
        cell.child = children; 
        cell.lbStatus.hidden = YES;
        cell.minBtn.hidden = YES;
        return cell;
    }
    return nil;
}
- (NSString *)configStartDate:(NSString *)start endDate:(NSString *)end{
    
    
    NSDateFormatter *dateFormatter = [Util dateFormatter] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [dateFormatter dateFromString:start];
    NSDate *endDate = [dateFormatter dateFromString:end];
    
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *startTime = [dateFormatter stringFromDate:startDate];
    NSString *endTime = [dateFormatter stringFromDate:endDate];
    
    
    startTime = [startTime stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
    startTime = [startTime stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    endTime = [endTime stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
    endTime = [endTime stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    
    
    
    NSString *timeStr = [NSString stringWithFormat:@"%@ - %@",startTime,endTime];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *dateStr = [dateFormatter stringFromDate:startDate];
    
    return [NSString stringWithFormat:@"%@ • %@",dateStr,timeStr];
}            



@end
