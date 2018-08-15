//
//  BookingModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/20.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BookingModel.h"
#import "ChildrenModel.h"

@implementation BookingModel
- (instancetype)init{
    if (self = [super init]) { 
        _careId = @"";
        _typeId = @"";
        _careType = @"";
        _endDate = @"";
        _peopleNums = @"";
        _startDate = @"";
        _stayDays = @"";
        _totalPrice = @"0";
        _unitPrice = @"";
        _whoIsComings = @[];
        _times = @[];
        _timePeriod = @"";
        _firstPic = @"";
        _userIcon = @"";
        _userName = @"";
        _unitPriceStr = @"";
        _adultPrice = @"0";
        _remainingPlace = 0;
        
        _shareIcon = @[];
        
        _endDateStr = @"";
        _startDateStr = @"";
        
        _rejectReason = @"";
        
        _bookingCode = @"";
        _whereToMeetLat = 0;
        _whereToMeetLon = 0;
        _whereToMeet = @"";
        _addressLon = 0;
        _addressLat = 0;
        
        _bookingId = @"";
        _bookingid = @"";
        _toUserName = @"";
        _pubUserIcon = @"";
        _accountId = @"";
        _pubAccountId = @"";
        _thumbnail = @"";
        return self;
    }
    return nil;
} 
- (NSString *)thumbnail{
    if (_thumbnail==nil || _thumbnail.length==0) {
        if (_shareIcon.count) {
            return _shareIcon.firstObject;
        }
    }
    return @"";
}
- (void)setBookingId:(NSString *)bookingId{
    _bookingId = bookingId;
    _bookingid = bookingId;
}

- (void)setBookingid:(NSString *)bookingid{
    _bookingId = bookingid;
    _bookingid = bookingid;
}
- (NSString *)toUserName{
    return _userName;
}
//
//- (NSString *)pubAccountId{
//    return _accountId;
//}
- (NSString *)timePeriod{
    _timePeriod = @"";
    if (_times.count) {
        for ( NSInteger index=0; index<_times.count; index++) {
            NSDictionary *dic = _times[index];
            _timePeriod = [NSString stringWithFormat:@"%@%@",_timePeriod,dic[@"timePeriod"]];
            if (index+1<_times.count) {
                _timePeriod = [NSString stringWithFormat:@"%@|",_timePeriod];
            }
        }
    }
    
//    if (_whoIsComings.count) {
//        for (NSDictionary *dic in _whoIsComings) {
//            _timePeriod = dic[@"timePeriod"];
//            break;
//        }
//    }
    
    return _timePeriod;
}

//- (NSString *)userIcon{
//    if (_userIcon == nil) {
//        return _pubUserIcon;
//    }
//    if (_userIcon.length==0) {
//        return _pubUserIcon;
//    }
//    return @"";
//}

@end
