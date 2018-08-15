//
//  CheckAvailabilityVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "CheckAvailabilityVC.h"

#import <EventKit/EventKit.h>

#import "FSCalendar.h"

#define CHECK_TABLEVIEW_FOOT_HEIGHT 60*TX_SCREEN_OFFSET
#define CHECK_TABLEVIEW_CELL_HEIGHT 30


NS_ASSUME_NONNULL_BEGIN
@interface CheckAvailabilityVC ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>{
    NSDate *_startDate ;
    NSDate *_endDate ;
     
}

@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *requesttoBookView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic)IBOutlet  FSCalendar *calendar;
  

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter; 
@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;  


@property (strong, nonatomic) NSDictionary *borderDefaultColors;
@property (strong, nonatomic) NSDictionary *borderSelectionColors;
@property (strong, nonatomic) NSMutableDictionary *childrensCheckDate;


@property (weak, nonatomic) IBOutlet UIButton *btDropOff;
@property (weak, nonatomic) IBOutlet UIButton *btPickUp;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;
@property (assign, nonatomic) NSInteger hasJoinChildrensNum;
@property (strong, nonatomic) NSArray *joinChildrens;

@end

NS_ASSUME_NONNULL_END

@implementation CheckAvailabilityVC

#pragma mark - Life cycle

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.title = @"When do you want to book?";
//    }
//    return self;
//}

//- (void)loadView
//{
////    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
////    view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
////    self.view = view;
//    
//   
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]]; 
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"When do you want to book?";
    _hasJoinChildrensNum = 0;
    _joinChildrens = @[];
    [self handleChildrens:self.item.joinChildrens];
    
    NSMutableDictionary *availableTimeDic = [NSMutableDictionary dictionary];
    NSArray *times = [_item.availableTime componentsSeparatedByString:@","];
    for (NSString *time in times) {
        [availableTimeDic setObject:COLOR_BLUE forKey:time]; 
    }
    self.borderSelectionColors = availableTimeDic;
    self.borderDefaultColors = availableTimeDic;
    
    
    self.calendar.backgroundColor = [UIColor whiteColor];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    self.calendar.pagingEnabled = NO; // important
    self.calendar.allowsMultipleSelection = YES;
    self.calendar.firstWeekday = 2; 
    self.calendar.placeholderType = FSCalendarPlaceholderTypeNone; 
    self.calendar.appearance.titleDefaultColor = COLOR_GRAY; 
    self.calendar.appearance.todayColor =TX_RGB(219, 219, 219);
    self.calendar.appearance.weekdayTextColor = COLOR_GRAY; 
    self.calendar.appearance.headerDateFormat = @"  MMMM";  
    self.calendar.appearance.headerTitleColor = COLOR_GRAY;  
    
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    self.dateFormatter = [Util dateFormatter];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    self.minimumDate = [self.dateFormatter dateFromString:[Util getCurrentTime]];
    self.maximumDate = [self.dateFormatter dateFromString:[Util GetAfterMonth:6]];
    
    self.calendar.accessibilityIdentifier = @"calendar";
    
    _dataSource = [NSMutableArray array];
    
    UINib *checkNib = [UINib nibWithNibName:NSStringFromClass([CheckAvailabilityCell class]) bundle:nil];
    [self.tableView registerNib:checkNib forCellReuseIdentifier:@"check"];
    self.tableView.tableFooterView = self.requesttoBookView;
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT+CGRectGetHeight(self.tableView.frame));
    self.confirmView.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT+CGRectGetHeight(self.confirmView.frame));
    
    _startDate = [NSDate date];
    _endDate = [NSDate date];
    
   
    _booking = [[BookingModel alloc] init];
    _booking.unitPrice = _item.moneyPerDay;
    _booking.unitPriceStr = [NSString stringWithFormat:@"$%@/day",_item.moneyPerDay];
    _booking.firstPic = _item.thumbnail;
    _booking.userIcon = _item.userIcon;
    _booking.userName = _item.userName;
    _booking.careId = _item.idValue;
    _booking.careType = @"0";
    _booking.accountId = _item.accountId;
    
  //  [self queryJoinChild];
}
- (void)queryJoinChild{
    
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_BOOKING_APPOINTED_CHILD 
         withParaments:@[@"0",self.item.idValue] 
      withSuccessBlock:^(id response) {
          
          if ([response isKindOfClass:[NSArray class]]) {
              [weakSelf handleChildrens:response];
          } 
          [SVProgressHUD dismiss];
      } withFailureBlock:^(NSString *error) {
          [SVProgressHUD showErrorWithStatus:error];
      }];
}

- (void)handleChildrens:(NSArray *)childrens{
    _childrensCheckDate = [NSMutableDictionary dictionary];
    for (NSDictionary *child in childrens) { 
        NSString *timePeriod = child[@"timePeriod"];
        NSArray *times = [timePeriod componentsSeparatedByString:@"|"];
        for (NSString *time in times) {
            NSString *dateStr = [time componentsSeparatedByString:@"T"].firstObject;
            NSMutableArray *array = [NSMutableArray array];
            if ([_childrensCheckDate.allKeys containsObject:dateStr]) {
                array = [NSMutableArray arrayWithArray:_childrensCheckDate[dateStr]]; 
            }
            ChildrenModel *childModel = [ChildrenModel modelWithDictionary:child];
          //  childModel.state = ChildStateConfirmed;
            [array addObject:childModel];
            
            [_childrensCheckDate setObject:array forKey:dateStr];
        }
    }
}
#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return self.minimumDate;
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return self.maximumDate;
}


#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSLog(@"did select %@，%@",[self.dateFormatter stringFromDate:date],date);
    
    if (_isConfirmViewShow) {
        [calendar deselectDate:_selectedDate];
    }
    [self showConfirmView];
    _selectedDate = date;
}
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(nonnull NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
     
    NSLog(@"did deselect %@",[self.dateFormatter stringFromDate:date]);
    [self removeDate:date];
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    
    NSString *key = [self.dateFormatter stringFromDate:date];
    NSString *todayKey = [self.dateFormatter stringFromDate:[NSDate date]];
    
    if ([todayKey compare:key]==NSOrderedDescending ||[todayKey compare:key]==NSOrderedSame ||_dataSource.count) {
        return NO;
    }
    
    if ([_borderDefaultColors.allKeys containsObject:key] && (monthPosition == FSCalendarMonthPositionCurrent)) {
        NSArray *array = _childrensCheckDate[key];
        if (array.count >= [self.item.childrenNums integerValue]) {
            return NO;
        }
        return YES;
    }
    
    return NO;
}
#pragma mark - FSCalendarDelegate Appearance


- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
{ 
    NSString *key = [self.dateFormatter stringFromDate:date];
    NSString *todayKey = [self.dateFormatter stringFromDate:[NSDate date]];
    
    
    if ([_borderDefaultColors.allKeys containsObject:key]) {
        NSArray *array = _childrensCheckDate[key];
        if (array.count >= [self.item.childrenNums integerValue] ||[todayKey compare:key]==NSOrderedDescending||[todayKey compare:key]==NSOrderedSame) {
            return TX_RGB(219, 219, 219);
        } 
        
        return _borderDefaultColors[key];
    }
    return appearance.borderDefaultColor;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date
{
    NSString *key = [self.dateFormatter stringFromDate:date];
    if ([_borderSelectionColors.allKeys containsObject:key]) {
        return _borderSelectionColors[key];
    }
    return appearance.borderSelectionColor;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date{
    NSString *key = [self.dateFormatter stringFromDate:date];
    NSString *todayKey = [self.dateFormatter stringFromDate:[NSDate date]];
    if ([key isEqualToString:todayKey]) {
        return [UIColor whiteColor];
    }
    return COLOR_GRAY;
} 

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CHECK_TABLEVIEW_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CheckAvailabilityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"check" 
                                                                  forIndexPath:indexPath];
    __weak typeof(self) weakeSelf = self; 
    cell.deletedBlock = ^{
        [weakeSelf removeObjectAtIndex:indexPath.row];
    };
    cell.lbDesc.text = _dataSource[indexPath.row][@"desc"];
    
    return cell;
    
}

- (void)removeObjectAtIndex:(NSInteger)index{ 
    [self.calendar deselectDate:_dataSource[index][@"date"]];
    [_dataSource removeObjectAtIndex:index];
    [self.tableView reloadData];
    
    [self showRequesttoBookView];
    [self resetSubViewFrame];
}
- (void)removeDate:(NSDate *)date{
    for (NSDictionary *dic in _dataSource) {
        NSString *dateStr = dic[@"dateStr"];
        if ([dateStr isEqualToString:[self.dateFormatter stringFromDate:date]]) {
            [_dataSource removeObject:dic];
            break;
        }
        
    } 
    [self.tableView reloadData]; 
    
    if ([[self.dateFormatter stringFromDate:date] isEqualToString:[self.dateFormatter stringFromDate:_selectedDate]]) {
         [self showRequesttoBookView];
    }
     
   
    [self resetSubViewFrame];
}

- (IBAction)cancel:(id)sender {
    
    [self.calendar deselectDate:_selectedDate]; 
    [self showRequesttoBookView];
}
- (IBAction)confirmClick:(id)sender {
     
    NSString *desc = [NSString stringWithFormat:@"EleCare • %@ • %@ - %@",[self.dateFormatter stringFromDate:_selectedDate],_btDropOff.titleLabel.text,_btPickUp.titleLabel.text];
    
//    NSString *day = [NSDateFormatter localizedStringFromDate:_selectedDate 
//                                                       dateStyle:NSDateFormatterMediumStyle 
//                                                       timeStyle:NSDateFormatterNoStyle];
    
    NSDateFormatter *dateFormatter = [Util dateFormatter];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSString *day = [dateFormatter stringFromDate:_selectedDate];
    
    NSString *timePeriod =[NSString stringWithFormat:@"%@ - %@",[Util yyyyMMddHHmmss:[Util stringFormatDate:_selectedDate time:_startDate]],[Util yyyyMMddHHmmss:[Util stringFormatDate:_selectedDate time:_endDate]]];
    
    NSString *time = [NSString stringWithFormat:@"%@ - %@",_btDropOff.titleLabel.text,_btPickUp.titleLabel.text];
    NSDictionary *requestStr = @{@"day":day,
                                 @"time":time,
                                 @"timePeriod":timePeriod
                                 };
    
    [_dataSource addObject:@{@"date":_selectedDate,
                             @"desc":desc,
                             @"dateStr":[self.dateFormatter stringFromDate:_selectedDate],
                             @"requestStr":requestStr,
                             @"startDate":_startDate,
                             @"endDate":_endDate
                             }];
    
    
   
    [self.tableView reloadData]; 
    [self showRequesttoBookView];
    [self resetSubViewFrame];
}


- (IBAction)requestToBookClick:(id)sender {
    
    _joinChildrens = @[];
    NSMutableArray *tempArr = [NSMutableArray array];
    
    NSDate *minDate = [_dataSource firstObject][@"startDate"];
    NSDate *maxDate = [_dataSource lastObject][@"endDate"];
    
    for (NSDictionary *dic in _dataSource) {
        [tempArr addObject:dic[@"requestStr"]];
        
        minDate = [minDate earlierDate:dic[@"startDate"]];
        maxDate = [maxDate laterDate:dic[@"endDate"]];
        
        NSString *dateStr = dic[@"dateStr"];
        
        if ([[_childrensCheckDate allKeys] containsObject:dateStr]) {
            NSArray *array = _childrensCheckDate[dateStr];
            if (array.count>_joinChildrens.count) {
                _joinChildrens = array;
            }
        }
        
    }
    _booking.times = tempArr;
    _booking.stayDays= NSStringFromInt(_booking.times.count);
    
    _booking.startDate = [Util yyyyMMddHHmmss:minDate];
    _booking.endDate = [Util yyyyMMddHHmmss:maxDate];
    
    WhosComingVC *comingVC = [[WhosComingVC alloc] init];
    comingVC.item = _item;
    comingVC.booking = _booking;
    comingVC.hasJoinChildrensNum = _hasJoinChildrensNum;
    comingVC.dataSource = [NSMutableArray arrayWithArray:_joinChildrens];
    [self.navigationController pushViewController:comingVC animated:YES];
}



- (void)resetSubViewFrame{
    CGFloat height = CHECK_TABLEVIEW_FOOT_HEIGHT+CHECK_TABLEVIEW_CELL_HEIGHT*_dataSource.count+20;
    
    self.tableView.frame =CGRectMake(0, TX_SCREEN_HEIGHT-height, TX_SCREEN_WIDTH, height);
    self.requesttoBookView.frame = CGRectMake(0, 0, TX_SCREEN_WIDTH, CHECK_TABLEVIEW_FOOT_HEIGHT);
    self.calendar.frame = CGRectMake(0, SYSTEM_NAVIGATIONBAR_HEIGHT, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-SYSTEM_NAVIGATIONBAR_HEIGHT-height*(_dataSource.count>0));
    
    
}
- (IBAction)chooseDropOffTime:(UIButton *)sender {
    __weak typeof(self) weakeSelf = self;
//    [ZPicker showTimePickerTitle:@"Drop-off Time" done:^(id object) {
//        [sender setTitle:object forState:UIControlStateNormal]; 
//        startDate = object;
//        [weakeSelf resetConfirmBtnState];
//    }];
    
    
    [ZPicker showStartEndDatePickerTitle:@"Drop-off/Pick-up Time" done:^(id object) {
        
        [weakeSelf.btDropOff setTitle:object[@"start"] forState:UIControlStateNormal];
        [weakeSelf.btPickUp setTitle:object[@"end"] forState:UIControlStateNormal];  
            _startDate = [Util stringFormatDate:_selectedDate time:object[@"startDate"]];
            _endDate = [Util stringFormatDate:_selectedDate time:object[@"endDate"]];
        weakeSelf.btnConfirm.enabled = YES;
    }];
}

- (IBAction)choosePickUpTime:(UIButton *)sender {
    __weak typeof(self) weakeSelf = self;
    [ZPicker showStartEndDatePickerTitle:@"Drop-off/Pick-up Time" done:^(id object) {
        
        [weakeSelf.btDropOff setTitle:object[@"start"] forState:UIControlStateNormal];
        [weakeSelf.btPickUp setTitle:object[@"end"] forState:UIControlStateNormal]; 
        _startDate = [Util stringFormatDate:_selectedDate time:object[@"startDate"]];
        _endDate = [Util stringFormatDate:_selectedDate time:object[@"endDate"]];
        
        weakeSelf.btnConfirm.enabled = YES;
    }];
}

- (void)resetConfirmBtnState{
   
    
//    NSString *startTime = _startDate;
//    NSString *endTime = _endDate;
//    
//    return;
//    
//    NSLog(@"%@-%@",startTime,endTime);
//    
//    _btnConfirm.enabled = NO;
//    if (startTime.length && endTime.length) {
//        
//        if (([startTime containsString:@"AM"] && [endTime containsString:@"AM"]) ||
//            ([startTime containsString:@"PM"] && [endTime containsString:@"PM"])
//            ) {
//            
//            startTime = [startTime stringByReplacingOccurrencesOfString:@" AM" withString:@""];
//            startTime = [startTime stringByReplacingOccurrencesOfString:@" PM" withString:@""];
//            endTime = [endTime stringByReplacingOccurrencesOfString:@" AM" withString:@""];
//            endTime = [endTime stringByReplacingOccurrencesOfString:@" PM" withString:@""];
//            
//            NSString *sHour = [startTime componentsSeparatedByString:@":"][0];
//            NSString *sMin = [startTime componentsSeparatedByString:@":"][1];
//            
//            NSString *eHour = [endTime componentsSeparatedByString:@":"][0];
//            NSString *eMin = [endTime componentsSeparatedByString:@":"][1];
//            
//            if (sHour.integerValue<eHour.integerValue) {
//                _btnConfirm.enabled = YES;
//            }
//            
//            if (sHour.integerValue==eHour.integerValue && sMin.integerValue<eMin.integerValue) {
//                _btnConfirm.enabled = YES;
//            }
//            
//        }
//        
//        if ([startTime containsString:@"AM"] && [endTime containsString:@"PM"]) {
//            _btnConfirm.enabled = YES;
//        }
//        
//    }
//    
//    
}

- (void)showConfirmView{
    self.tableView.hidden = YES;
    _isConfirmViewShow = YES;
  //  _calendar.userInteractionEnabled = NO;
    
    [self.btDropOff setTitle:@"" forState:UIControlStateNormal];
    [self.btPickUp setTitle:@"" forState:UIControlStateNormal];
    self.btnConfirm.enabled = NO;
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{
        self.confirmView.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT-CGRectGetHeight(self.confirmView.frame)/2);
    }];
}
- (void)showRequesttoBookView{
    
    _calendar.userInteractionEnabled = YES;
    _isConfirmViewShow = NO;
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{
        self.confirmView.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT+CGRectGetHeight(self.confirmView.frame)/2);
    }completion:^(BOOL finished) {
        self.tableView.hidden = !_dataSource.count;
    }];
}

@end

