//
//  ZPicker.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/24.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h> 


typedef void(^ZPickerDidSelectedBlock)(id object);
typedef void(^ZPickerCancelBlock)(void);
typedef void(^ZPickerDoneBlock)(id object); 
typedef void(^ZDatePickerDoneBlock)(id object,NSDate *one,NSDate *two); 

typedef enum : NSUInteger {
    ZPickerTypePrice,
    ZPickerTypeAgeRange,
    ZPickerTypeDefault
} ZPickerType;
 
@protocol  ZPickerDidValueChengedDelegate <NSObject>

- (void)zpickerDidSelectedStart:(UIDatePicker *)startPicker end:(UIDatePicker *)endPicker;

@end
@interface ZPicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>


@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *dataSource;
@property (nonatomic, assign) ZPickerType type;

@property (strong, nonatomic) ZPickerDidSelectedBlock selectedBlock;
@property (strong, nonatomic) ZPickerCancelBlock cancelBlock;
@property (strong, nonatomic) ZPickerDoneBlock doneBlock;
@property (strong, nonatomic) ZDatePickerDoneBlock datePickerBlock;

@property(strong, nonatomic) UIDatePicker *startDatePicker;
@property(strong, nonatomic) UIDatePicker *endDatePicker;


+ (void)showPickerTitle:(NSString *)title dataSource:(NSArray *)dataSource done:(ZPickerDoneBlock)doneBlock;
+ (void)showPickerTitle:(NSString *)title dataSource:(NSArray *)dataSource pickerType:(ZPickerType)type done:(ZPickerDoneBlock)doneBlock;



//选择日期和时间
+ (void)showDateAndTimePickerTitle:(NSString *)title done:(ZPickerDoneBlock)doneBlock;


+ (void)showDateAndTimePickerTitle:(NSString *)title 
                           minDate:(NSDate*)minDate 
                           maxDate:(NSDate *)maxDate 
                              done:(ZDatePickerDoneBlock)datePickerBlock;
+ (void)showDateAndTimePickerTitle:(NSString *)title 
                           minDate:(NSDate*)minDate 
                           maxDate:(NSDate *)maxDate 
                            target:(id)target
                              done:(ZDatePickerDoneBlock)datePickerBlock;

//选择时间
+ (void)showTimePickerTitle:(NSString *)title done:(ZPickerDoneBlock)doneBlock;

//选择日期
+ (void)showDatePickerTitle:(NSString *)title done:(ZDatePickerDoneBlock)datePickerBlock;

//选择起止时间
+ (void)showStartEndDatePickerTitle:(NSString *)title done:(ZPickerDoneBlock)doneBlock;


@end
