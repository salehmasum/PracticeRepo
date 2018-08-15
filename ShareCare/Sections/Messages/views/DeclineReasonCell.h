//
//  DeclineReasonCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/12/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeclineReasonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView; 
@property (weak, nonatomic) IBOutlet UILabel *lbReason;

@end
