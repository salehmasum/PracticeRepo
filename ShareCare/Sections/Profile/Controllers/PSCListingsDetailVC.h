//
//  PSCListingsDetailVC.h
//  ShareCare
//
//  Created by 朱明 on 2018/5/15.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "BookingDetailVC.h"
#import "ChildrenModel.h"
#import "BookingModel.h"
typedef void(^CancelListingBlock)(id object);
@interface PSCListingsDetailVC : BookingDetailVC
@property (strong, nonatomic) id item;
@property (strong, nonatomic) CancelListingBlock cancelListingBlock;
;
@end
