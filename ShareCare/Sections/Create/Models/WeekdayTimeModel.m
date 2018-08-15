//
//  WeekdayTimeModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "WeekdayTimeModel.h"

@implementation WeekdayTimeModel

- (instancetype)init{
    if (self = [super init]) {
        
        _mon = @"";
        _tues = @"";
        _wed = @"";
        _thur = @"";
        _fri = @"";
        _sat = @"";
        _sun = @"";
        
        return self;
    }
    return nil;
}

@end
