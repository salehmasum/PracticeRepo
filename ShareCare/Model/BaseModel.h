//
//  BaseModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
+ (id)modelWithDictionary:(NSDictionary *)dic; /** 这是公用的过滤接口数据的方法 */
- (NSDictionary*)convertToDictionary;


@property (copy, nonatomic) NSString *idValue;
@end
