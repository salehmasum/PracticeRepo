//
//  ChildrenModel.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ChildrenModel.h"

@implementation ChildrenModel
- (instancetype)init{    
    if (self = [super init]) { 
        _childId = @"";
        _age = @"";
        _fullName = @"";
        _gender = @"";
        _childIconPath = @"";
        _status = @"";
        _stateStr = @"";
        _timePeriod = @"";
        _emergencyContactPhone = @"";
        _emergencyContactPerson = @"";
        _birthday = @"";
        _isMyChild = NO;
        _myChild = NO;
        _relationship = @"";
        return self;    
    }   
    return nil;
}
 
- (void)setMyChild:(BOOL)myChild{
    _myChild = myChild;
    _isMyChild = myChild;
}

//- (void)setTimePeriod:(NSString *)timePeriod{
//    _timePeriod = timePeriod;
//}

- (void)setBirthday:(NSString *)birthday{
    if (birthday) {
        _birthday = birthday;
        if (birthday.length >4) {
            NSInteger ageValue = [Util getCurrentYear]-[[birthday componentsSeparatedByString:@"-"].firstObject integerValue];
            ageValue = ageValue>0?ageValue:1;
            _age = [NSString stringWithFormat:@"%ldyrs",(long)ageValue];
        }
    }
}

- (NSString *)age{
    if (_birthday) { 
        if (_birthday.length ==10) {
            NSInteger ageValue = [Util getCurrentYear]-[[_birthday componentsSeparatedByString:@"-"].firstObject integerValue];
            ageValue = ageValue>0?ageValue:1;
            _age = [NSString stringWithFormat:@"%ldyrs",(long)ageValue];
        }
    }
    return _age;
}

-(void)setChildStatus:(NSString *)childStatus{
    NSInteger childStatusValue = [childStatus integerValue];
    _childStatus = childStatus;
    self.state = childStatusValue;
}


- (void)setState:(ChildState)state{
    switch (state) {
        case ChildStateConfirmed:
            _stateStr = @"Confirmed";
            break;
        case ChildStateAvailable:
            _stateStr = @"Available";
            break;
        case ChildStateBusy:
            _stateStr = @"Busy"; 
            break;
            case ChildStateCheckAgeRange: 
            _stateStr = @"Check Age Range";
            break;
            
        default:
            _stateStr = @"";
            break;
    }
    _state = state;
}

//- (void)setChildIcon:(NSString *)childIcon{
//    _childIconPath = childIcon;
//    _childIcon = childIcon;
//}
//- (void)setChildName:(NSString *)childName{
//    _fullName = childName;
//    _childName = childName;
//}
- (NSString *)childIcon{
    return _childIconPath;
}
- (NSString *)childName{
    return _fullName;
}

@end
