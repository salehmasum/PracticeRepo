//
//  HConditionCalendarVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/10.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HConditionCalendarVC.h"
#import "FXBlurView.h"
@interface HConditionCalendarVC ()

@property (weak, nonatomic) IBOutlet UIView *pickerBackgroundView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@end

@implementation HConditionCalendarVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
    
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timeLabel.text.length) {
        
        NSArray *days = [self.timeLabel.text componentsSeparatedByString:@"-"];
        [self.delegate conditionSelectedYear:[days[0] integerValue] 
                                       month:[days[1] integerValue] 
                                         day:[days[2] integerValue]];
        
        
        [self.delegate conditionSelectedTime:self.timeLabel.text andDate:_datePicker.date];
    }
     
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pickerBackgroundView.frame = CGRectMake(10, TX_SCREEN_HEIGHT, TX_SCREEN_WIDTH-20, CGRectGetHeight(self.pickerBackgroundView.frame));
    self.pickerBackgroundView.layer.masksToBounds = YES;
    self.pickerBackgroundView.layer.cornerRadius = 6;
   // self.pickerBackgroundView.blurRadius = 30;
    _datePicker.datePickerMode = UIDatePickerModeDate;
 //   self.titleView.blurRadius = 30;
}
- (IBAction)selectTime:(id)sender {
    
    _datePicker.date = [NSDate date];
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{
        self.pickerBackgroundView.frame = CGRectMake(10, TX_SCREEN_HEIGHT-CGRectGetHeight(self.pickerBackgroundView.frame)-10, TX_SCREEN_WIDTH-20, CGRectGetHeight(self.pickerBackgroundView.frame));
    }];
    
}
- (IBAction)selectedAnyTime:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate conditionAnyTime];
}
- (IBAction)selectedTonight:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate conditionTonight];
}
- (IBAction)done:(id)sender {
    NSDate *theDate = _datePicker.date;
    NSLog(@"%@",[theDate descriptionWithLocale:[NSLocale currentLocale]]); 
    NSDateFormatter *dateFormatter = [Util dateFormatter];
    dateFormatter.dateFormat = @"YYYY-MM-dd"; 
    self.timeLabel.text = [dateFormatter stringFromDate:theDate];
    
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{
        self.pickerBackgroundView.frame = CGRectMake(10, TX_SCREEN_HEIGHT, TX_SCREEN_WIDTH-20, CGRectGetHeight(self.pickerBackgroundView.frame));
    }completion:^(BOOL finished) {
        
        [self.navigationController popViewControllerAnimated:NO]; 
    }];
}
- (IBAction)cancel:(id)sender {
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{
        self.pickerBackgroundView.frame = CGRectMake(10, TX_SCREEN_HEIGHT, TX_SCREEN_WIDTH-20, CGRectGetHeight(self.pickerBackgroundView.frame));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
