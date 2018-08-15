//
//  BabysittingChooseTimeVC.m
//  ShareCare
//
//  Created by 朱明 on 2018/5/29.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "BabysittingChooseTimeVC.h"

@interface BabysittingChooseTimeVC ()
@property (weak, nonatomic) IBOutlet UIView *pickerView;

@end

@implementation BabysittingChooseTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pickerView.layer.masksToBounds = YES;
    self.pickerView.layer.cornerRadius = 10;
    
    self.view.hidden = YES;
    self.pickerView.hidden = YES;
    [self cancel:nil];
    
}
- (IBAction)cancel:(id)sender {
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{
        self.pickerView.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT+CGRectGetHeight(self.pickerView.frame)/2); 
    }completion:^(BOOL finished) {
        //[self.view removeFromSuperview];
        
        self.view.hidden = YES;
        self.pickerView.hidden = YES;
    }];
}
- (IBAction)done:(id)sender {
    [self cancel:nil];
    
    NSDateFormatter *dateFormatter = [Util dateFormatter];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];            
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];            
    NSString *dayStr = [dateFormatter stringFromDate:self.dayPicker.date];
    
    
    
    dayStr = [[dayStr componentsSeparatedByString:@", "] firstObject]; 
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];            
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];            
    NSString *timeStr = [dateFormatter stringFromDate:self.timePicker.date];
    
    
    
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];            
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    
    NSString *weekDay = [Util weekdayStringFromDate:self.dayPicker.date];
    
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *day = [dateFormatter stringFromDate:self.dayPicker.date];
    dateFormatter.dateFormat = @"HH:mm:ss";
    NSString *time = [dateFormatter stringFromDate:self.timePicker.date];
    
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %@",day,time]];
    
    if (_delegate) { 
        
        [_delegate chooseDateAndTimeDidSelected:[NSString stringWithFormat:@"%@T%@",day,time]
                                      labelText:[NSString stringWithFormat:@"%@ %@ • %@",weekDay,dayStr,timeStr] 
                                           date:date];
    }
    
    
}

- (void)showToView:(UIView *)superView{
    
    self.view.hidden = NO;
    self.pickerView.hidden = NO;
  //  [superView addSubview:self.view];
    
    self.pickerView.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT+CGRectGetHeight(self.pickerView.frame)/2);
    [UIView animateWithDuration:UIKEYBOARD_OPEN_ANIMATION_DURATION animations:^{        
        self.pickerView.center = CGPointMake(TX_SCREEN_WIDTH/2, TX_SCREEN_HEIGHT-10-CGRectGetHeight(self.pickerView.frame)/2-30*iSiPhoneX);     
        
    }];
}
- (IBAction)dayPickerDidValueChanged:(UIDatePicker *)sender {
    if (_delegate) {
        NSDateFormatter *formatter = [Util dateFormatter]; 
        formatter.dateFormat = @"yyyy-MM-dd";
        [_delegate chooseDayPickerDidValueChanged:[formatter stringFromDate:sender.date]];
    }
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
