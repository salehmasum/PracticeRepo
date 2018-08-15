//
//  ZPicker.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/24.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ZPicker.h"  

@interface ZPicker(){
    UILabel *_titleLabel; 
    UIView *_contentView;
    NSInteger _selectedRow;
    NSInteger _selectedComponent;
    
    CGFloat _width;
    
    UILabel *_lbStartTitle;
    UILabel *_lbEndTitle;
} 
@property (assign, nonatomic) id<ZPickerDidValueChengedDelegate>delegate;
@property(strong, nonatomic) UIPickerView *pickerView;

- (instancetype)initWithTitle:(NSString *)title dataSource:(NSArray *)dataSource pickerType:(ZPickerType)type done:(ZPickerDoneBlock)doneBlock;

- (instancetype)initTwoDatePickerTitle:(NSString *)title done:(ZPickerDoneBlock)doneBlock;
@end

@implementation ZPicker

static ZPicker *_piker = nil;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _piker = [[ZPicker alloc] init];
    });
    return _piker;
}
+ (void)showPickerTitle:(NSString *)title dataSource:(NSArray *)dataSource done:(ZPickerDoneBlock)doneBlock{
    [self showPickerTitle:title dataSource:dataSource pickerType:ZPickerTypeDefault done:doneBlock];
    
}
+ (void)showPickerTitle:(NSString *)title dataSource:(NSArray *)dataSource pickerType:(ZPickerType)type done:(ZPickerDoneBlock)doneBlock{
    if ([[self alloc] initWithTitle:title dataSource:dataSource pickerType:type done:doneBlock]) {
        NSLog(@"show picker");
    }
}
+ (void)showStartEndDatePickerTitle:(NSString *)title done:(ZPickerDoneBlock)doneBlock{
    if ([[self alloc] initTwoDatePickerTitle:title done:doneBlock]) {
        NSLog(@"show two datepicker");
    }
}
//+ (void)showStartEndDatePickerTitle:(NSString *)title 
//                             target:(id)target 
//                               done:(ZPickerDoneBlock)doneBlock{
//    if ([[self alloc] initTwoDatePickerTitle:title done:doneBlock]) {
//        NSLog(@"show two datepicker");
//    }
//}

+ (void)showDateAndTimePickerTitle:(NSString *)title done:(ZPickerDoneBlock)doneBlock{
    if ([[self alloc] initDateAndTimePickerTitle:title done:doneBlock]) {
        NSLog(@"show two datepicker");
    }
}

+ (void)showDateAndTimePickerTitle:(NSString *)title 
                           minDate:(NSDate*)minDate 
                           maxDate:(NSDate *)maxDate 
                            target:(id)target
                              done:(ZDatePickerDoneBlock)datePickerBlock{
    ZPicker *picker = [[self alloc] initDateAndTimePickerTitle:title minDate:minDate maxDate:maxDate done:datePickerBlock];
    if (picker) {
        picker.delegate = target;
        NSLog(@"show two datepicker");
    }
}
+ (void)showDateAndTimePickerTitle:(NSString *)title 
                           minDate:(NSDate*)minDate 
                           maxDate:(NSDate *)maxDate 
                              done:(ZDatePickerDoneBlock)datePickerBlock{
    if ([[self alloc] initDateAndTimePickerTitle:title minDate:minDate maxDate:maxDate done:datePickerBlock]) {
        NSLog(@"show two datepicker");
    }
}
+ (void)showTimePickerTitle:(NSString *)title 
                    minDate:(NSDate*)minDate 
                    maxDate:(NSDate *)maxDate 
                       done:(ZDatePickerDoneBlock)datePickerBlock{
    if ([[self alloc] initTimePickerTitle:title minDate:minDate maxDate:maxDate done:datePickerBlock]) {
        NSLog(@"show time datepicker");
    }
}

+ (void)showTimePickerTitle:(NSString *)title done:(ZPickerDoneBlock)doneBlock{
    if ([[self alloc] initTimePickerTitle:title done:doneBlock]) {
        NSLog(@"show time datepicker");
    }
}
+ (void)showDatePickerTitle:(NSString *)title done:(ZDatePickerDoneBlock)datePickerBlock{
    if ([[self alloc] initDatePickerTitle:title done:datePickerBlock]) {
        NSLog(@"show time datepicker");
    }
}

- (instancetype)initWithTitle:(NSString *)title dataSource:(NSArray *)dataSource pickerType:(ZPickerType)type done:(ZPickerDoneBlock)doneBlock{
    if (self = [self initWithType:type]) {
        _titleLabel.text = title;
        _dataSource = dataSource;
        _doneBlock = doneBlock;
        [self.pickerView reloadAllComponents]; 
        [_contentView addSubview:self.pickerView];
        
        if (type == ZPickerTypePrice) { 
            for (NSInteger index=0; index<_dataSource.count; index++) {
                id object = _dataSource[index];
                if ([object isKindOfClass:[NSArray class]]) {
                    NSArray *tempArr = (NSArray *)object;
                    [self.pickerView selectRow:tempArr.count-1 inComponent:index animated:NO];
                }
            }
        }else if (type == ZPickerTypeAgeRange){
            id object = _dataSource[0];
            if ([object isKindOfClass:[NSArray class]]) {
                NSArray *tempArr = (NSArray *)object;
                [self.pickerView selectRow:tempArr.count/2 inComponent:0 animated:NO];
            }
        }
        
        [self show];
    }
    return self;
}
- (void)setType:(ZPickerType)type{
    _type = type;
    if (_type == ZPickerTypePrice) {
        for (NSInteger index=0; index<_dataSource.count; index++) {
            NSArray *array = _dataSource[index];
            [_pickerView selectRow:array.count-1 inComponent:index animated:NO];
        }
    }
    if (_type == ZPickerTypeAgeRange) {
        NSArray *array = _dataSource[0];
        [_pickerView selectRow:array.count/2 inComponent:0 animated:NO];
    }
}


- (instancetype)initDateAndTimePickerTitle:(NSString *)title 
                                   minDate:(NSDate*)minDate 
                                   maxDate:(NSDate *)maxDate 
                                      done:(ZDatePickerDoneBlock)datePickerBlock{
    if (self = [self initWithType:ZPickerTypeDefault]) {
        _titleLabel.text = title; 
        _datePickerBlock = datePickerBlock;  
        CGRect rect = _contentView.bounds;
        rect.origin.y = 32*TX_SCREEN_OFFSET;
        self.startDatePicker.frame = rect;
         
        
        minDate?(self.startDatePicker.minimumDate =minDate):(self.startDatePicker.minimumDate =[NSDate date]);
        
        if(minDate){
            self.startDatePicker.minimumDate =minDate;
            self.startDatePicker.date = minDate;
        }else{
            self.startDatePicker.minimumDate =[NSDate date];
        }
        
        if (maxDate) {
            self.startDatePicker.maximumDate = maxDate;
        }
        
        
        self.startDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [_contentView addSubview:self.startDatePicker]; 
        
        _lbStartTitle.hidden = YES;
        [self show];
    }
    return self;
}



- (instancetype)initDateAndTimePickerTitle:(NSString *)title done:(ZPickerDoneBlock)doneBlock{
    if (self = [self initWithType:ZPickerTypeDefault]) {
        _titleLabel.text = title; 
        _doneBlock = doneBlock;  
        CGRect rect = _contentView.bounds;
        rect.origin.y = 32*TX_SCREEN_OFFSET;
        self.startDatePicker.minimumDate =[NSDate date];
        self.startDatePicker.frame = rect;
        self.startDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [_contentView addSubview:self.startDatePicker]; 
        
        _lbStartTitle.hidden = YES;
        [self show];
    }
    return self;
}

- (instancetype)initTimePickerTitle:(NSString *)title 
                            minDate:(NSDate*)minDate 
                            maxDate:(NSDate *)maxDate 
                               done:(ZDatePickerDoneBlock)datePickerBlockk{
    if (self = [self initWithType:ZPickerTypeDefault]) {
        _titleLabel.text = title; 
        _datePickerBlock = datePickerBlockk;  
        CGRect rect = _contentView.bounds;
        rect.origin.y = 32*TX_SCREEN_OFFSET;
        self.startDatePicker.minimumDate =minDate;
        self.startDatePicker.maximumDate =maxDate;
        self.startDatePicker.frame = rect;
        self.startDatePicker.datePickerMode = UIDatePickerModeTime;
        [_contentView addSubview:self.startDatePicker]; 
        _lbStartTitle.hidden = YES;
        [self show];
    }
    return self;
}

- (instancetype)initDatePickerTitle:(NSString *)title done:(ZDatePickerDoneBlock)datePickerBlockk{
    if (self = [self initWithType:ZPickerTypeDefault]) {
        _titleLabel.text = title; 
        _datePickerBlock = datePickerBlockk;  
        CGRect rect = _contentView.bounds;
        rect.origin.y = 32*TX_SCREEN_OFFSET;
        if ([title isEqualToString:@"Date of Birth"]) { 
            self.startDatePicker.maximumDate =[NSDate date];
        }else{ 
            self.startDatePicker.minimumDate =[NSDate date];
        }
        self.startDatePicker.frame = rect;
        self.startDatePicker.datePickerMode = UIDatePickerModeDate;
        [_contentView addSubview:self.startDatePicker]; 
        _lbStartTitle.hidden = YES;
        [self show];
    }
    return self;
}
- (instancetype)initTimePickerTitle:(NSString *)title done:(ZPickerDoneBlock)doneBlock{
    if (self = [self initWithType:ZPickerTypeDefault]) {
        _titleLabel.text = title; 
        _doneBlock = doneBlock;  
        CGRect rect = _contentView.bounds;
        rect.origin.y = 32*TX_SCREEN_OFFSET;
        self.startDatePicker.minimumDate =[NSDate date];
        self.startDatePicker.frame = rect;
        self.startDatePicker.datePickerMode = UIDatePickerModeTime;
        [_contentView addSubview:self.startDatePicker]; 
        _lbStartTitle.hidden = YES;
        [self show];
    }
    return self;
}
- (instancetype)initTwoDatePickerTitle:(NSString *)title done:(ZPickerDoneBlock)doneBlock{
    if (self = [self initWithType:ZPickerTypeDefault]) {
        _titleLabel.text = title; 
        _doneBlock = doneBlock;  
//        self.startDatePicker.minimumDate = [NSDate date];
//        self.endDatePicker.minimumDate = [NSDate date];
//      
        NSDateFormatter *dateFormatter= [Util dateFormatter];
        dateFormatter.dateFormat = @"HH:mm:ss";
        
        
        self.startDatePicker.date = [dateFormatter dateFromString:@"08:30:00"];
        self.endDatePicker.date = [dateFormatter dateFromString:@"18:00:00"];
        [_contentView addSubview:self.startDatePicker];
        [_contentView addSubview:self.endDatePicker];  
        [self show];
    }
    return self;
}

- (instancetype)initWithType:(ZPickerType)type{
    if (self = [super init]) { 
        CGRect rect = CGRectMake(8, TX_SCREEN_HEIGHT, (TX_SCREEN_WIDTH-16), 234*TX_SCREEN_OFFSET);
        
        self.frame = CGRectMake(0, 0, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT); 
        UILabel *lb = [[UILabel alloc] initWithFrame:self.bounds];
        //CGRectMake(0, 0, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-234*TX_SCREEN_OFFSET)
        lb.backgroundColor = [UIColor blackColor];
        lb.alpha = 0.4;
        [self addSubview:lb];  
        
        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        bgButton.frame = self.bounds; 
        [bgButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        
        
        _type = type;
        
        if (type == ZPickerTypePrice) {
            _width = 70;
        }else if(type == ZPickerTypeDefault){
            _width = 150;
        }else{
            _width = 100;
        }
        
        
        _contentView = [[UIView alloc] initWithFrame:rect]; 
        _contentView.backgroundColor = [UIColor whiteColor];//TX_RGB(216, 216, 216);  //前景颜色 
//        _contentView.dynamic = YES;
//        _contentView.blurRadius = 40;
        _contentView.tintColor = [UIColor whiteColor];
        [self addSubview:_contentView]; 
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(rect), 32*TX_SCREEN_OFFSET)];
        headerView.backgroundColor = [UIColor whiteColor];//TX_RGB(227, 227, 227);
     //   headerView.blurRadius = 30;
        [_contentView addSubview:headerView]; 
         
        _titleLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
        _titleLabel.font = TX_FONT(17); 
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:_titleLabel];
        
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(-10, 0, 80, 32*TX_SCREEN_OFFSET);
        [cancelBtn setTitle:@"cancel" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:COLOR_BLUE forState:UIControlStateNormal];
        [cancelBtn titleLabel].font = TX_FONT(16);
        [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:cancelBtn];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(CGRectGetWidth(rect)-70, 0, 80, 32*TX_SCREEN_OFFSET);
        [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        [doneBtn titleLabel].font = TX_FONT(16);
        [doneBtn setTitleColor:COLOR_BLUE forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:doneBtn];
        
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 10;
        
        _selectedRow = 0;
        return self;
    }
    
    return nil;
}

- (UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 32*TX_SCREEN_OFFSET, CGRectGetWidth(_contentView.frame), CGRectGetHeight(_contentView.frame)-32*TX_SCREEN_OFFSET)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (UIDatePicker *)startDatePicker{
    if (!_startDatePicker) {
        
        _lbStartTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 32*TX_SCREEN_OFFSET, CGRectGetWidth(_contentView.frame)/2-60, 20)];
     //   label.textAlignment = NSTextAlignmentCenter;
        _lbStartTitle.text = @"START TIME";
        _lbStartTitle.font = TX_FONT(11);
        [_contentView addSubview:_lbStartTitle];
        
        _startDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 32*TX_SCREEN_OFFSET, CGRectGetWidth(_contentView.frame)/2, CGRectGetHeight(_contentView.frame)-32*TX_SCREEN_OFFSET)];
        _startDatePicker.datePickerMode = UIDatePickerModeTime; 
        
        _startDatePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];//设置为英文
        
        [ _startDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _startDatePicker;
}

- (UIDatePicker *)endDatePicker{
    if (!_endDatePicker) {
        
        _lbEndTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(_contentView.frame)/2+20, 32*TX_SCREEN_OFFSET, CGRectGetWidth(_contentView.frame)/2-60, 20)];
    //    label.textAlignment = NSTextAlignmentCenter;
        _lbEndTitle.text = @"END TIME";
        _lbEndTitle.font = TX_FONT(11);
        [_contentView addSubview:_lbEndTitle];
        
        _endDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(CGRectGetWidth(_contentView.frame)/2, 32*TX_SCREEN_OFFSET, CGRectGetWidth(_contentView.frame)/2, CGRectGetHeight(_contentView.frame)-32*TX_SCREEN_OFFSET)];
        _endDatePicker.datePickerMode = UIDatePickerModeTime;
        _endDatePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];//设置为英文
        
       // _endDatePicker.minimumDate =[NSDate date];
        [ _endDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _endDatePicker;
}
- (void)dateChanged:(UIDatePicker *)datePicker
{  
    
    
    if (self.delegate) {
        [_delegate zpickerDidSelectedStart:_startDatePicker end:_endDatePicker];
    }else{
        if ([_startDatePicker.date compare:_endDatePicker.date]==NSOrderedDescending) {
            _endDatePicker.date = _startDatePicker.date;
        } 
        NSInteger seconds = [_endDatePicker.date timeIntervalSince1970]-[_startDatePicker.date timeIntervalSince1970];
        if (seconds<7200) {
            _endDatePicker.date= [NSDate dateWithTimeInterval:7200 sinceDate:_startDatePicker.date];//加一天
        }
    }
}

- (void)show{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{        
        _contentView.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT-10-CGRectGetHeight(_contentView.frame)/2-30*iSiPhoneX);     
        
    }];
}

- (void)cancel:(id)sender{
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{
        _contentView.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT+CGRectGetHeight(_contentView.frame)/2); 
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)done:(id)sender{
    __block typeof(self) weakeSelf = self;
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{
        _contentView.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT+CGRectGetHeight(_contentView.frame)/2); 
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (_dataSource) {
            NSMutableArray *resultArray = [NSMutableArray array];
            for (NSInteger index=0; index<_dataSource.count; index++) {
                NSArray *array = _dataSource[index];
                [resultArray addObject:array[[_pickerView selectedRowInComponent:index]]];
            }
//           
            if (_type == ZPickerTypeAgeRange) {
                weakeSelf.doneBlock([resultArray componentsJoinedByString:@" "]);
            }else{
                weakeSelf.doneBlock([resultArray componentsJoinedByString:@""]);
            }
            
        }else if(_startDatePicker && _endDatePicker){ 
            NSDateFormatter *dateFormatter = [Util dateFormatter];//返回一个日期格式对象
//            
            [dateFormatter setDateStyle:NSDateFormatterNoStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            NSString *start = [dateFormatter stringFromDate:_startDatePicker.date];
            
//            
            [dateFormatter setDateStyle:NSDateFormatterNoStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            NSString *end = [dateFormatter stringFromDate:_endDatePicker.date];
            
            
            start = [start stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
            start = [start stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
            end = [end stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
            end = [end stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
            
            NSDictionary *result =@{@"start":start, 
                                    @"end":end,
                                    @"startDate":_startDatePicker.date, 
                                    @"endDate":_endDatePicker.date
                                    };
            if (weakeSelf.doneBlock) {
                weakeSelf.doneBlock(result);
            }
        }else if (_startDatePicker.datePickerMode == UIDatePickerModeDateAndTime){
//            NSString *dayStr = [NSDateFormatter localizedStringFromDate:weakeSelf.startDatePicker.date 
//                                                               dateStyle:NSDateFormatterMediumStyle 
//                                                               timeStyle:NSDateFormatterNoStyle];
            
            NSDateFormatter *dateFormatter = [Util dateFormatter];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];            
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];            
            NSString *dayStr = [dateFormatter stringFromDate:weakeSelf.startDatePicker.date];
            
            
            
            dayStr = [[dayStr componentsSeparatedByString:@", "] firstObject];
            
//            NSString *timeStr = [NSDateFormatter localizedStringFromDate:weakeSelf.startDatePicker.date 
//                                                              dateStyle:NSDateFormatterNoStyle 
//                                                              timeStyle:NSDateFormatterShortStyle]; 
            
            [dateFormatter setDateStyle:NSDateFormatterNoStyle];            
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];            
            NSString *timeStr = [dateFormatter stringFromDate:weakeSelf.startDatePicker.date];
            
            
            
            timeStr = [timeStr stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];            
            timeStr = [timeStr stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
            
            NSString *weekDay = [Util weekdayStringFromDate:weakeSelf.startDatePicker.date];
            
            
            
            if (weakeSelf.doneBlock) {
                weakeSelf.doneBlock([NSString stringWithFormat:@"%@ %@ • %@",weekDay,dayStr,timeStr]);
            }
            if (weakeSelf.datePickerBlock) {
                weakeSelf.datePickerBlock([NSString stringWithFormat:@"%@ %@ • %@",weekDay,dayStr,timeStr],weakeSelf.startDatePicker.date,nil);
            }
            
        }else if (_startDatePicker.datePickerMode == UIDatePickerModeTime){
//            NSString *timeStr = [NSDateFormatter localizedStringFromDate:_startDatePicker.date 
//                                                               dateStyle:NSDateFormatterNoStyle 
//                                                               timeStyle:NSDateFormatterShortStyle]; 
//            
            NSDateFormatter *dateFormatter = [Util dateFormatter];
            [dateFormatter setDateStyle:NSDateFormatterNoStyle];            
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];            
            NSString *timeStr = [dateFormatter stringFromDate:weakeSelf.startDatePicker.date];
            
            if (weakeSelf.doneBlock) {
                weakeSelf.doneBlock([NSString stringWithFormat:@"%@",timeStr]);
            }
        }else if (_startDatePicker.datePickerMode == UIDatePickerModeDate){
//            NSString *dayStr = [NSDateFormatter localizedStringFromDate:weakeSelf.startDatePicker.date 
//                                                              dateStyle:NSDateFormatterMediumStyle 
//                                                              timeStyle:NSDateFormatterNoStyle];
            NSDateFormatter *dateFormatter = [Util dateFormatter];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];            
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];            
            NSString *dayStr = [dateFormatter stringFromDate:weakeSelf.startDatePicker.date];
            dayStr = [[dayStr componentsSeparatedByString:@", "] firstObject];
            
            NSString *weekDay = [Util weekdayStringFromDate:weakeSelf.startDatePicker.date];
            
            
            
            if (weakeSelf.datePickerBlock) {
                weakeSelf.datePickerBlock([NSString stringWithFormat:@"%@ %@",weekDay,dayStr],weakeSelf.startDatePicker.date,nil);
            }
        }
        
    }];
}
 

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return _dataSource.count; // 返回1表明该控件只包含1列
}

//UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    // 该方法返回teams.count，表明teams包含多少个元素，该控件就包含多少行
 //   return _dataSource.count;
    NSArray *temp = _dataSource[component];
    return temp.count;
}


// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为UIPickerView
// 中指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    // 由于该控件只包含一列，因此无须理会列序号参数component
    // 该方法根据row参数返回teams中的元素，row参数代表列表项的编号，
    // 因此该方法表示第几个列表项，就使用teams中的第几个元素
    
    NSArray *temp = _dataSource[component];
    return [temp objectAtIndex:row];
}

// 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    _selectedRow = row;
    _selectedComponent = component;
    
    NSLog(@"row=%ld,component=%ld",_selectedRow,_selectedComponent);
    
    if (_type == ZPickerTypePrice) {
        
        NSString *string = _dataSource[component][row];
        if (component==0) {
            NSArray  *array = _dataSource[1];
            if ([string isEqualToString:@"FREE"]) {
                [pickerView selectRow:array.count-1 inComponent:1 animated:YES];
            }else{ 
                NSString *tempStr = _dataSource[1][[pickerView selectedRowInComponent:1]];
                if (tempStr.length==0) {
                    [pickerView selectRow:array.count-2 inComponent:1 animated:YES];
                }
            }
        }
        if (component==1) {
            NSArray  *array = _dataSource[0];
            if (string.length==0) {
                [pickerView selectRow:array.count-1 inComponent:0 animated:YES];
            }
            if (string.length) {
                NSString *tempStr = _dataSource[0][[pickerView selectedRowInComponent:0]];
                if ([tempStr isEqualToString:@"FREE"]) {
                    [pickerView selectRow:array.count-2 inComponent:0 animated:YES];
                }
            }
        }
       
    }
    
    
    
   
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (_type == ZPickerTypeAgeRange) {
        if (component==0) {
            return 70;
        }else{
            return 140;
        }
    }
    return _width;
}
@end
