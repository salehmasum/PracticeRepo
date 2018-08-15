//
//  CredentialsModel.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseModel.h"

@interface CredentialsModel : BaseModel
@property (nonatomic, assign) BOOL nonsmoker;
@property (nonatomic, assign) BOOL drivers;
@property (nonatomic, assign) BOOL havecar;
@property (nonatomic, assign) BOOL cleaning;
@property (nonatomic, assign) BOOL anphylaxis;
@property (nonatomic, assign) BOOL firstaid;
@property (nonatomic, assign) BOOL cooking;
@property (nonatomic, assign) BOOL tutoring;
@end
