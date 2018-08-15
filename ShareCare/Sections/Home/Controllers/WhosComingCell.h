//
//  WhosComingCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/28.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChildrenModel.h"

typedef void(^DeleteButtonClickBlock)(void);

@interface WhosComingCell : UITableViewCell

@property (strong, nonatomic) ChildrenModel *child;

@property (assign, nonatomic) BOOL isBoy;
@property (assign, nonatomic) ChildState state;
@property (assign, nonatomic) BOOL isMyChildren;
@property (strong, nonatomic) DeleteButtonClickBlock deleteBlock;

@property (weak, nonatomic) IBOutlet UILabel *lbAge;
@property (weak, nonatomic) IBOutlet UILabel *lbStatus;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *imgheader;
@property (weak, nonatomic) IBOutlet UIButton *minBtn;

@end
