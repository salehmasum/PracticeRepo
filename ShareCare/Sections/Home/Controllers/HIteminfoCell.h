//
//  HIteminfoCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HIteminfoCellDidSelectedImageBlock)(NSInteger index);

@interface HIteminfoCell : UITableViewCell<BHInfiniteScrollViewDelegate>
@property (strong, nonatomic) BHInfiniteScrollView *infinitePageView;
@property (strong, nonatomic) UIImageView *imgPersonHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbType;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbDesc;
@property (strong, nonatomic) HIteminfoCellDidSelectedImageBlock selectedIndexBlock;

@end
