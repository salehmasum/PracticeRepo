//
//  createShareCareCalendarCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h" 



typedef void(^FSCalendarDidSelectedDayBlock)(NSString *day);
typedef void(^FSCalendarDidDeSelectedDayBlock)(NSString *day);

@interface createShareCareCalendarCell : UITableViewCell<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>

@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateFormatter *dateFormatter; 
@property (strong, nonatomic) NSDate *minimumDate;
@property (strong, nonatomic) NSDate *maximumDate;  


@property (strong, nonatomic) NSDictionary *borderDefaultColors;
@property (strong, nonatomic) NSDictionary *borderSelectionColors;

@property (strong, nonatomic) FSCalendarDidSelectedDayBlock selectedDayBlock;
@property (strong, nonatomic) FSCalendarDidDeSelectedDayBlock deSelectedDayBlock;

@end
