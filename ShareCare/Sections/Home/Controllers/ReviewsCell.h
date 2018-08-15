//
//  ReviewsCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReviewsCellDelagete <NSObject>

- (void)reviewCellDidReport:(id)sender;

@end

@interface ReviewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonHeader;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbReview;
@property (strong, nonatomic) id reviewId;

@property (assign, nonatomic) id<ReviewsCellDelagete>delegate;

- (void)configIcon:(NSString *)path userName:(NSString *)name time:(NSString *)time content:(NSString *)content;

@end
