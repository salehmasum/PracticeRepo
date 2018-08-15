//
//  CheckAvailabilityCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CheckAvailabilityCellDeletedBlock)(void);
@interface CheckAvailabilityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbDesc;
@property (strong, nonatomic) CheckAvailabilityCellDeletedBlock deletedBlock;

@end
