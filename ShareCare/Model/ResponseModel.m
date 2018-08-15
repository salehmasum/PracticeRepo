//
//  ResponseModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ResponseModel.h"

@implementation ResponseModel

@end
@implementation PageModel
- (instancetype)init{
    if (self = [super init]) { 
        _number = 0;
        _numberOfElements = 0;
        _size = 0;
        _sort = @[];
        _totalElements = 0;
        _totalPages = 0;
        _first = YES;
        _last = YES;
        _content = @[];
        
        _nextNumber = 1;
        return self;
    }
    return nil;
} 

- (int)nextNumber{
    return _number+1;
}

@end
