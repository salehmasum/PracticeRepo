//
//  ContactTitleCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"
@interface ContactTitleCell : UITableViewCell

@property (assign, nonatomic) id<ContactSharecarerDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle; 
@property (weak, nonatomic) IBOutlet CWStarRateView *starView;
@property (weak, nonatomic) IBOutlet UILabel *lbReviews;
@end
