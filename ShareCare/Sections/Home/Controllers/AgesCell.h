//
//  AgesCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AgeRangeModel.h"
#import "CredentialsModel.h"

@interface AgesCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *statusInfo;
@property (strong, nonatomic) AgeRangeModel *ageRange;
@property (strong, nonatomic) CredentialsModel *credentials;

@end
