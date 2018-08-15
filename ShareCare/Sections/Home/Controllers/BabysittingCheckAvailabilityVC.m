//
//  BabysittingCheckAvailabilityVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BabysittingCheckAvailabilityVC.h"
#import "WeekdayCell.h"
#import "ZPicker.h"
#import "BabysittingWhosComingVC.h"
#import "BabysittingChooseTimeVC.h"

@interface BabysittingCheckAvailabilityVC ()<ZPickerDidValueChengedDelegate,BabysittingChooseDateTimeDelegate>{
    
    NSDate *_startDate;
    NSDate *_endDate;
    
    BOOL _isSetUpStart;
    NSDictionary *_availableTime;
    NSString *_selectedTimes;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbUpdate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lbMon;
@property (weak, nonatomic) IBOutlet UILabel *lbTues;
@property (weak, nonatomic) IBOutlet UILabel *lbWed;
@property (weak, nonatomic) IBOutlet UILabel *lbThurs;
@property (weak, nonatomic) IBOutlet UILabel *lbFri;
@property (weak, nonatomic) IBOutlet UILabel *lbSat;
@property (weak, nonatomic) IBOutlet UILabel *lbSun;
@property (weak, nonatomic) IBOutlet UILabel *lbStart;
@property (weak, nonatomic) IBOutlet UILabel *lbEnd;

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbLocation;
@property (weak, nonatomic) IBOutlet UILabel *lbWhos;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnEnd;
@property (strong, nonatomic) BabysittingChooseTimeVC *chooseTimeVC;


@end

@implementation BabysittingCheckAvailabilityVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE]; 
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"line"]];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]]; 
    
}  
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     
    self.automaticallyAdjustsScrollViewInsets = NO;  
    _lbMon.text = _item.availableTimeModel.mon;
    _lbTues.text = _item.availableTimeModel.tues;
    _lbWed.text = _item.availableTimeModel.wed;
    _lbThurs.text = _item.availableTimeModel.thur;
    _lbFri.text = _item.availableTimeModel.fri;
    _lbSat.text = _item.availableTimeModel.sat;
    _lbSun.text = _item.availableTimeModel.sun;
    
    _availableTime = [_item.availableTimeModel convertToDictionary];
    _startDate = [NSDate date];
    _lbName.text = _item.userName;
    if (_item.update.length) {
        _lbUpdate.text = [NSString stringWithFormat:@"Updated:%@",_item.update];
    }else{
        _lbUpdate.text = @"Updated";
        
    }
    
    _lbPrice.text = [NSString stringWithFormat:@"%@/hr",_item.chargePerHour];
    _lbLocation.text = _item.headLine;
    _lbWhos.text = [NSString stringWithFormat:@"Hosted by %@",_item.userName];
    
    _scrollView.contentSize = CGSizeMake(TX_SCREEN_WIDTH, 522*TX_SCREEN_OFFSET);
    
//    CGPoint center = self.headerImageView.center;
//    self.headerImageView.frame = CGRectMake(0, 0, 76*TX_SCREEN_OFFSET, 76*TX_SCREEN_OFFSET);
//    self.headerImageView.center = center;
   
    
    [_headerImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(_item.userIcon)] placeholderImage:kDEFAULT_HEAD_IMAGE];
    
    _booking = [[BookingModel alloc] init];
    _booking.unitPrice = _item.chargePerHour;
    _booking.unitPriceStr = [NSString stringWithFormat:@"$%@/hr",_item.chargePerHour];
    _booking.firstPic = _item.thumbnail;
    _booking.userIcon = _item.userIcon;
    _booking.userName = _item.userName;
    _booking.careId = _item.idValue;
    _booking.accountId = _item.accountId;
//    _booking.timePeriod = []
    
  //  [self.view setNeedsLayout];
    
    
    self.chooseTimeVC.view.frame = self.view.bounds; 
    [self.view addSubview:self.chooseTimeVC.view];
    
}
- (BabysittingChooseTimeVC *)chooseTimeVC{
    if (_chooseTimeVC == nil) {
        _chooseTimeVC = [[BabysittingChooseTimeVC alloc] init];
        _chooseTimeVC.delegate = self;
        [self addChildViewController:_chooseTimeVC];
    }
    return _chooseTimeVC;
}
- (void)chooseDateAndTimeDidSelected:(NSString *)bookingTime labelText:(NSString *)text date:(NSDate *)date{
    if (_isSetUpStart) {
        self.lbStart.text = text;
        self.lbEnd.text = @"";
        self.booking.startDate = bookingTime; 
        _startDate = date; 
        NSLog(@"object=%@,startDate=%@,endDate=%@",text, self.booking.startDate, self.booking.endDate);
        [self checkAvailability];
        self.btnEnd.enabled = YES;
    }else{
        self.lbEnd.text = text; 
        self.booking.endDate = bookingTime; 
        _endDate = date; 
        NSLog(@"object=%@,startDate=%@,endDate=%@",text, self.booking.startDate, self.booking.endDate);
        [self checkAvailability];
        self.btnEnd.enabled = YES;
    }
}
- (void)viewDidLayoutSubviews{
    self.headerImageView.layer.masksToBounds = YES; 
    CGFloat width = CGRectGetWidth(self.headerImageView.frame); 
    self.headerImageView.layer.cornerRadius = width/2.0;
}

- (IBAction)modifyStart:(id)sender {
    
    _isSetUpStart = YES;
    
    NSDateFormatter *formatter = [Util dateFormatter];
    formatter.dateFormat = @"yyyy-MM-dd";
    _selectedTimes = @"";
    NSInteger days =1;
    NSDate *date1 = [NSDate date];
    while (_selectedTimes.length == 0) {
        date1 = [NSDate dateWithTimeInterval:3600*24*days sinceDate:[NSDate date]]; 
        NSString *week = [Util weekdayStringFromDate:date1];
        _selectedTimes = _availableTime[[week lowercaseString]];
        days++;
    }
    
    NSString *tomorrow = [formatter stringFromDate:date1];  
    
    if (_selectedTimes.length) {
        NSString *time1 = [_selectedTimes componentsSeparatedByString:@" - "].firstObject; 
        NSString *time2 = [_selectedTimes componentsSeparatedByString:@" - "].lastObject; 
        
        formatter.dateFormat = @"yyyy-MM-dd hh:mm a";
        
        time1 = [time1 stringByReplacingOccurrencesOfString:@"pm" withString:@" PM"];            
        time1 = [time1 stringByReplacingOccurrencesOfString:@"am" withString:@" AM"]; 
        
        time2 = [time2 stringByReplacingOccurrencesOfString:@"pm" withString:@" PM"];            
        time2 = [time2 stringByReplacingOccurrencesOfString:@"am" withString:@" AM"]; 
        
        NSString *start = [NSString stringWithFormat:@"%@ %@",tomorrow,time1];
        NSString *end = [NSString stringWithFormat:@"%@ %@",tomorrow,time2];
        NSLog(@"start = %@",start);
        NSLog(@"end = %@",end);
        
        _startDate = [formatter dateFromString:start];
        self.chooseTimeVC.dayPicker.minimumDate = _startDate;
        self.chooseTimeVC.timePicker.minimumDate = _startDate;
        
        self.chooseTimeVC.timePicker.maximumDate = [formatter dateFromString:end];
        self.chooseTimeVC.dayPicker.date = _startDate;
        self.chooseTimeVC.timePicker.date = _startDate;
        self.chooseTimeVC.doneBtn.enabled = YES;
    }
    
    self.chooseTimeVC.dayPicker.userInteractionEnabled = YES;
    [self.chooseTimeVC showToView:self.view];return;
    
    //    startStr = [NSString stringWithFormat:@"%@ 23:59:59",startStr];
    //    
    //    NSDate *date = [formatter dateFromString:startStr]; 
    
    
   
    
  //  _startDate = [NSDate dateWithTimeInterval:3600*24 sinceDate:[NSDate date]]; 
 
    __weak typeof(self) weakSelf = self;
    [ZPicker showDateAndTimePickerTitle:@"Choose Date & Time" 
                                minDate:_startDate 
                                maxDate:nil
                                   done:^(id object, NSDate *one, NSDate *two) {
                                       weakSelf.lbStart.text = object;
                                       weakSelf.lbEnd.text = @"";
                                       weakSelf.booking.startDate = [Util yyyyMMddHHmmss:one]; 
                                       _startDate = one; 
                                       NSLog(@"object=%@,startDate=%@,endDate=%@",object, weakSelf.booking.startDate, weakSelf.booking.endDate);
                                       [weakSelf checkAvailability];
                                       weakSelf.btnEnd.enabled = YES;
                                       
                                   }];
    
//    __weak typeof(self) weakSelf = self;     
//    [ZPicker showDatePickerTitle:@"Choose Date" done:^(id object, NSDate *one, NSDate *two) {
//        
//        
//        
//        weakSelf.lbStart.text = object;   
//        weakSelf.booking.startDate = [Util yyyyMMddHHmmss:[Util stringFormatDate:one time:_startDate]];
//        weakSelf.booking.endDate = [Util yyyyMMddHHmmss:[Util stringFormatDate:one time:_endDate]];
//        _startDate = one; 
//        _endDate = one;
//         
//        NSLog(@"object=%@,startDate=%@,endDate=%@",object, weakSelf.booking.startDate, weakSelf.booking.endDate);
//        
//        [weakSelf checkAvailability];
//    }];
}

- (void)chooseDayPickerDidValueChanged:(NSString *)day{
    
    NSDateFormatter *formatter = [Util dateFormatter];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    
    NSString *week = [Util weekdayStringFromDate:[formatter dateFromString:day]];
    _selectedTimes = _availableTime[[week lowercaseString]];;
    
    
    NSString *tomorrow = [formatter stringFromDate:[formatter dateFromString:day]];  
    
    if (_selectedTimes.length) {
        NSString *time1 = [_selectedTimes componentsSeparatedByString:@" - "].firstObject; 
        NSString *time2 = [_selectedTimes componentsSeparatedByString:@" - "].lastObject; 
        
        formatter.dateFormat = @"yyyy-MM-dd hh:mm a";
        
        time1 = [time1 stringByReplacingOccurrencesOfString:@"pm" withString:@" PM"];            
        time1 = [time1 stringByReplacingOccurrencesOfString:@"am" withString:@" AM"]; 
        
        time2 = [time2 stringByReplacingOccurrencesOfString:@"pm" withString:@" PM"];            
        time2 = [time2 stringByReplacingOccurrencesOfString:@"am" withString:@" AM"]; 
        
        NSString *start = [NSString stringWithFormat:@"%@ %@",tomorrow,time1];
        NSString *end = [NSString stringWithFormat:@"%@ %@",tomorrow,time2];
        NSLog(@"start = %@",start);
        NSLog(@"end = %@",end);
        
        _startDate = [formatter dateFromString:start];
//        self.chooseTimeVC.dayPicker.minimumDate = _startDate;
//        self.chooseTimeVC.dayPicker.maximumDate = _startDate;
        self.chooseTimeVC.timePicker.minimumDate = _startDate;
        self.chooseTimeVC.timePicker.maximumDate = [formatter dateFromString:end];
        self.chooseTimeVC.timePicker.date = _startDate;
        self.chooseTimeVC.dayPicker.date = _startDate;
        self.chooseTimeVC.doneBtn.enabled = YES;
    }else{
        self.chooseTimeVC.doneBtn.enabled = NO;
    }
}
- (IBAction)modifyEnd:(id)sender { 
    
    _isSetUpStart = NO;
    if (_selectedTimes.length) {
        
        NSDateFormatter *formatter = [Util dateFormatter]; 
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString *tomorrow = [formatter stringFromDate:_startDate];  
        NSString *time1 = [_selectedTimes componentsSeparatedByString:@" - "].firstObject; 
        NSString *time2 = [_selectedTimes componentsSeparatedByString:@" - "].lastObject; 
        
        formatter.dateFormat = @"yyyy-MM-dd hh:mm a";
        
        time1 = [time1 stringByReplacingOccurrencesOfString:@"pm" withString:@" PM"];            
        time1 = [time1 stringByReplacingOccurrencesOfString:@"am" withString:@" AM"]; 
        
        time2 = [time2 stringByReplacingOccurrencesOfString:@"pm" withString:@" PM"];            
        time2 = [time2 stringByReplacingOccurrencesOfString:@"am" withString:@" AM"]; 
        
        NSString *start = [NSString stringWithFormat:@"%@ %@",tomorrow,time1];
        NSString *end = [NSString stringWithFormat:@"%@ %@",tomorrow,time2];
        NSLog(@"start = %@",start);
        NSLog(@"end = %@",end);
        
      //  _startDate = [formatter dateFromString:start];
        self.chooseTimeVC.dayPicker.minimumDate = _startDate;
        self.chooseTimeVC.timePicker.minimumDate = _startDate;
        self.chooseTimeVC.timePicker.maximumDate = [formatter dateFromString:end];
        self.chooseTimeVC.timePicker.date = [formatter dateFromString:end];
    }
    self.chooseTimeVC.dayPicker.userInteractionEnabled = NO;
    [self.chooseTimeVC showToView:self.view];return;
    
    NSDateFormatter *formatter = [Util dateFormatter];
    formatter.dateFormat = @"yyyy-MM-dd"; 
     NSDate *maxDate = nil; 
     
    NSString *week = [Util weekdayStringFromDate:_startDate];
    NSString *time = _availableTime[[week lowercaseString]]; 
      
    
    if (time.length) { 
        maxDate = _startDate;
        NSString *tomorrow = [formatter stringFromDate:maxDate];
        NSString *time2 = [time componentsSeparatedByString:@" - "].lastObject;
        
        formatter.dateFormat = @"yyyy-MM-dd hh:mm a"; 
        
        time2 = [time2 stringByReplacingOccurrencesOfString:@"pm" withString:@" PM"];            
        time2 = [time2 stringByReplacingOccurrencesOfString:@"am" withString:@" AM"];  
        
        NSString *temp2 = [NSString stringWithFormat:@"%@ %@",tomorrow,time2];
        NSLog(@"temp2 = %@",temp2);
        maxDate = [formatter dateFromString:temp2];
        
    }
    
    
    
    __weak typeof(self) weakSelf = self;
    [ZPicker showDateAndTimePickerTitle:@"Choose Date & Time" 
                                minDate:_startDate 
                                maxDate:maxDate 
                                 target:self
                                   done:^(id object, NSDate *one, NSDate *two) {
                                       weakSelf.lbEnd.text = object;
                                       weakSelf.booking.endDate = [Util yyyyMMddHHmmss:one];
                                       
                                       _endDate = one; 
                                       NSLog(@"object=%@,startDate=%@,endDate=%@",object, weakSelf.booking.startDate, weakSelf.booking.endDate);
                                       [weakSelf checkAvailability];
                                       
                                   }]; 
    
    
    
//    __weak typeof(self) weakSelf = self;    
//
//    [ZPicker showStartEndDatePickerTitle:@"Choose Time" done:^(id object) {
//        weakSelf.lbEnd.text = [NSString stringWithFormat:@"%@ - %@",object[@"start"],object[@"end"]];    
//        
//        
//        weakSelf.booking.startDate = [Util yyyyMMddHHmmss:[Util stringFormatDate:_startDate time:object[@"startDate"]]];
//        weakSelf.booking.endDate = [Util yyyyMMddHHmmss:[Util stringFormatDate:_endDate time:object[@"endDate"]]];
//        
//        _startDate = object[@"startDate"]; 
//        _endDate = object[@"endDate"]; 
//        
//        
//        NSLog(@"object=%@,startDate=%@,endDate=%@",object, weakSelf.booking.startDate, weakSelf.booking.endDate);
//        
//        [weakSelf checkAvailability];
//    }];
}

- (void)zpickerDidSelectedStart:(UIDatePicker *)startPicker end:(UIDatePicker *)endPicker{
    NSLog(@"---------%@",startPicker.date);
//    if (_isSetUpStart) {
//        startPicker.minimumDate = date1;
//    }else{
//        startPicker.maximumDate = date2;
//    }
    
}

- (void)checkAvailability{
    
    if (_lbStart.text.length && _lbEnd.text.length) { 
        _btnNext.enabled = YES;
         
        NSInteger seconds = [_endDate timeIntervalSince1970]-[_startDate timeIntervalSince1970];
        NSInteger hours = ceil((CGFloat)seconds/3600.0f);
        
        NSLog(@"=====%ld",hours);
        
        BOOL result = [[_lbStart.text componentsSeparatedByString:@" • "].firstObject isEqualToString:[_lbEnd.text componentsSeparatedByString:@" • "].firstObject];
        if (hours<=0 || !result) {
            _btnNext.enabled = NO;
            _lbEnd.text = _lbStart.text;
        }
        _booking.stayDays = [NSString stringWithFormat:@"%ld",hours];
        
    }else{
        _btnNext.enabled = NO;
    } 
    
}
/*
 NSDate *date1 = [NSDate dateWithTimeInterval:3600*24 sinceDate:[NSDate date]]; 
 NSString *week = [Util weekdayStringFromDate:date1];
 NSString *time = _availableTime[[week lowercaseString]]; 
 
 NSString *tomorrow = [formatter stringFromDate:date1]; 
 NSDate *date2 = nil;
 
 if (time.length) {
 NSString *time1 = [time componentsSeparatedByString:@" - "].firstObject;
 NSString *time2 = [time componentsSeparatedByString:@" - "].lastObject;
 
 formatter.dateFormat = @"yyyy-MM-dd hh:mm a";
 
 time1 = [time1 stringByReplacingOccurrencesOfString:@"pm" withString:@" PM"];            
 time1 = [time1 stringByReplacingOccurrencesOfString:@"am" withString:@" AM"]; 
 
 NSString *temp = [NSString stringWithFormat:@"%@ %@",tomorrow,time1];
 NSLog(@"temp = %@",temp);
 date1 = [formatter dateFromString:temp];
 
 time2 = [time2 stringByReplacingOccurrencesOfString:@"pm" withString:@" PM"];            
 time2 = [time2 stringByReplacingOccurrencesOfString:@"am" withString:@" AM"]; 
 
 
 NSString *temp2 = [NSString stringWithFormat:@"%@ %@",tomorrow,time2];
 NSLog(@"temp2 = %@",temp2);
 date2 = [formatter dateFromString:temp2];
 
 }
 */

- (IBAction)next:(id)sender {
    
    
    NSDateFormatter *dateFormatter = [Util dateFormatter];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];            
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];            
    NSString *dayStr = [dateFormatter stringFromDate:_startDate];
    dayStr = [[dayStr componentsSeparatedByString:@", "] firstObject]; 
    NSString *weekDay = [Util weekdayStringFromDate:_startDate]; 
    _booking.startDateStr = [NSString stringWithFormat:@"%@ %@",weekDay,dayStr];
    
     
    //            
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *start = [dateFormatter stringFromDate:_startDate];
    
    //            
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *end = [dateFormatter stringFromDate:_endDate];
    
    
    start = [start stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
    start = [start stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    end = [end stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
    end = [end stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    _booking.endDateStr = [NSString stringWithFormat:@"%@ - %@",start,end];
    
    
//    _booking.startDateStr = _lbStart.text;
//    _booking.endDateStr = _lbEnd.text;
     
 
    
    NSString *timePeriod =[NSString stringWithFormat:@"%@ - %@",self.booking.startDate,self.booking.endDate];
    
    self.booking.times = @[@{@"day":_booking.startDateStr,
                             @"time":_booking.endDateStr,
                             @"timePeriod":timePeriod
                             }];
     
    
    BabysittingWhosComingVC *detail = [[BabysittingWhosComingVC alloc] initWithNibName:@"WhosComingVC" bundle:nil];
    detail.item = _item;
    detail.booking = _booking;
    [self.navigationController pushViewController:detail animated:YES];
}


@end

