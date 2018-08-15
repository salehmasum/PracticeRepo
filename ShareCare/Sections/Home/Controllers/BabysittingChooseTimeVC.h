//
//  BabysittingChooseTimeVC.h
//  ShareCare
//
//  Created by 朱明 on 2018/5/29.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BabysittingChooseDateTimeDelegate <NSObject>

- (void)chooseDateAndTimeDidSelected:(NSString *)bookingTime labelText:(NSString *)text date:(NSDate *)date;
- (void)chooseDayPickerDidValueChanged:(NSString *)day;

@end
@interface BabysittingChooseTimeVC : UIViewController 
@property (weak, nonatomic) IBOutlet UIDatePicker *dayPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (assign,nonatomic) id<BabysittingChooseDateTimeDelegate>delegate;

- (void)showToView:(UIView *)superView;

@end
