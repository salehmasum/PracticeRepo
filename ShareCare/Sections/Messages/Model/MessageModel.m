//
//  MessageModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/12/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
- (instancetype)init{    
    if (self = [super init]) { 
        _user = @"";
        _toUser = @"";
        _toUserName = @"";
        _toUserIcon = [[NSBundle mainBundle] pathForResource:@"default_image" ofType:@"png"];
        _type = MessageTypeTEXT;
        _isFromSelf = NO;
        _content = @"";
        _timeinterval = 0;
        _isNotification = NO;
        _isRead = NO;
        _sessionId = @"";
        _messageState = SendMessageStateSuccess;
        _booking = [[BookingModel alloc] init];
        return self;   
    }    
    return nil;
} 

- (void)setBooking:(BookingModel *)booking{
    if ([booking isKindOfClass:[NSDictionary class]]) {
        _booking = [BookingModel modelWithDictionary:(NSDictionary *)booking];
    }
}

@end
