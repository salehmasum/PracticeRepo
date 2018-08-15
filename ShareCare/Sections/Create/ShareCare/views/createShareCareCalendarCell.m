//
//  createShareCareCalendarCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "createShareCareCalendarCell.h"



@implementation createShareCareCalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    self.calendar.backgroundColor = [UIColor whiteColor];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    self.calendar.pagingEnabled = YES; // important
    
   // self.calendar.scrollEnabled = YES; 
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
    
 //   NSLog(@"%f",self.calendar.co)
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
    NSLog(@"did select %@",[self.dateFormatter stringFromDate:date]);
    NSString *key = [self.dateFormatter stringFromDate:date];
    NSString *todayKey = [self.dateFormatter stringFromDate:[NSDate date]];
    if (![key isEqualToString:todayKey]) {
        _selectedDayBlock([self.dateFormatter stringFromDate:date]);
    }
    
    
//    if (_isConfirmViewShow) {
//        [calendar deselectDate:_selectedDate];
//    }
//    [self showConfirmView];
//    _selectedDate = date;
}
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(nonnull NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
    NSLog(@"did deselect %@",[self.dateFormatter stringFromDate:date]);
  //  [self removeDate:date];
    _deSelectedDayBlock([self.dateFormatter stringFromDate:date]);
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    NSLog(@"did change page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    NSString *key = [self.dateFormatter stringFromDate:date];
    NSString *todayKey = [self.dateFormatter stringFromDate:[NSDate date]];
    if ([key isEqualToString:todayKey]) {
        return NO;
    }
    return YES;
//    NSString *key = [self.dateFormatter stringFromDate:date];
//    if ([_borderDefaultColors.allKeys containsObject:key] && (monthPosition == FSCalendarMonthPositionCurrent)) {
//        return YES;
//    }
//    
//    return NO;
}
#pragma mark - FSCalendarDelegate Appearance


- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date
{
//    NSString *key = [self.dateFormatter stringFromDate:date];
//    if ([_borderDefaultColors.allKeys containsObject:key]) {
//        return _borderDefaultColors[key];
//    }
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
