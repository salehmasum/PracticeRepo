//
//  CheckAvailabilityView.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"


typedef void(^CheckAvailablityBlock)(void);

@interface CheckAvailabilityView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbReviews;
@property (weak, nonatomic) IBOutlet CWStarRateView *starView;
@property (strong, nonatomic) CheckAvailablityBlock checkAvailablityBlock;
@property (weak, nonatomic) IBOutlet UILabel *lbdesc;

@property (weak, nonatomic) IBOutlet UIButton *btnCheckAvailable;

- (void)configPrice:(NSString *)priceStr location:(NSString *)location careType:(NSInteger)type;
@end
