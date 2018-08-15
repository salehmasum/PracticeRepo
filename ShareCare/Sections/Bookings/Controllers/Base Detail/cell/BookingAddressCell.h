//
//  BookingAddressCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/11/29.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GetDirectionBlock)(double lon,double lat);

@interface BookingAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnGetDirection;


@property (assign, nonatomic) double lon;
@property (assign, nonatomic) double lat;

@property (strong, nonatomic) GetDirectionBlock getDirectionBlock;
@end
