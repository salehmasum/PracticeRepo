//
//  PlistHelper.m
//  ShareCare
//
//  Created by 朱明 on 2018/4/25.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "PlistHelper.h"
#define PLIST_FILE_PATH [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"localdata.plist"] 
@implementation PlistHelper

+ (void)createPlist{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:PLIST_FILE_PATH]) {
        if ([fileManager createFileAtPath:PLIST_FILE_PATH contents:nil attributes:nil]) {
            NSLog(@"create plist");
        }else{
            NSLog(@"create plist faild");
        }
    }else{
        NSLog(@"plist 文件已经存在");
    }
    
}

+ (void)saveEleCare:(NSArray *)list{  
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"elecare"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSArray *)localEleCareList{
    id result = [[NSUserDefaults standardUserDefaults] objectForKey:@"elecare"];
    if ([result isKindOfClass:[NSArray class]]) {
        return result;
    }
    return @[];
} 

+ (void)saveBabysitting:(NSArray *)list{
      
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"babysitting"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSArray *)localBabysittingList{
    id result = [[NSUserDefaults standardUserDefaults] objectForKey:@"babysitting"];
    if ([result isKindOfClass:[NSArray class]]) {
        return result;
    }
    return @[];
}
+ (void)saveEvent:(NSArray *)list{
   
    [[NSUserDefaults standardUserDefaults] setObject:list forKey:@"event"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)localEventList{ 
    id result = [[NSUserDefaults standardUserDefaults] objectForKey:@"event"];
    if ([result isKindOfClass:[NSArray class]]) {
        return result;
    }
    return @[];
}
 

+ (void)savePopular:(NSDictionary *)object{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:@"popular"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSDictionary *)localPopular{ 
    id result = [[NSUserDefaults standardUserDefaults] objectForKey:@"popular"];
    if ([result isKindOfClass:[NSDictionary class]]) {
        return result;
    }
    return @{};
}


@end
