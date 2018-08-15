//
//  UpcomingCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "UpcomingCell.h"

@implementation UpcomingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configStartDate:(NSString *)start endDate:(NSString *)end{
    
    
    NSDateFormatter *dateFormatter = [Util dateFormatter] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [dateFormatter dateFromString:start];
    NSDate *endDate = [dateFormatter dateFromString:end];
    
//    start = [NSDateFormatter localizedStringFromDate:startDate 
//                                           dateStyle:NSDateFormatterNoStyle 
//                                           timeStyle:NSDateFormatterShortStyle]; 
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    start = [dateFormatter stringFromDate:startDate];
    
    
//    end = [NSDateFormatter localizedStringFromDate:endDate 
//                                         dateStyle:NSDateFormatterNoStyle 
//                                         timeStyle:NSDateFormatterShortStyle]; 
//    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    end = [dateFormatter stringFromDate:endDate];
    
    
    start = [start stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
    start = [start stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    end = [end stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
    end = [end stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    
    
    
    _lbTime.text = [NSString stringWithFormat:@"%@ - %@",start,end];
    
    
    NSString *weekDay = [Util weekdayLongStringFromDate:startDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    //   NSInteger currentYear=[[formatter stringFromDate:startDate] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:startDate]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:startDate] integerValue];
    
    _lbDate.text = [NSString stringWithFormat:@"%@ %ld/%ld",weekDay,currentDay,currentMonth];
}
- (IBAction)moreAction:(id)sender {
    if (_selectedBlock) {
        _selectedBlock(self.row);
    }
}

@end
