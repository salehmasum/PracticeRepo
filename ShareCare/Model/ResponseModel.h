//
//  ResponseModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"

@class PageModel;
@interface ResponseModel : BaseModel
@property (nonatomic, copy) id data;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) BOOL success;
 
@end
 
@interface PageModel : BaseModel
@property (nonatomic, copy) NSArray *content;
@property (nonatomic, assign) BOOL first;
@property (nonatomic, assign) BOOL last;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int numberOfElements;
@property (nonatomic, assign) int size;
@property (nonatomic, strong) NSArray *sort;
@property (nonatomic, assign) int totalElements;
@property (nonatomic, assign) int totalPages;
@property (nonatomic, assign) int nextNumber;
@end





