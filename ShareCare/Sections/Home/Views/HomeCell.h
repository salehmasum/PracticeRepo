//
//  HomeCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/8/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"


@protocol FavoriteDelegate;
@interface HomeCell : UITableViewCell

@property (weak, nonatomic) id<FavoriteDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UIImageView *headPortraitView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet CWStarRateView *starView;
@property (weak, nonatomic) IBOutlet UILabel *evaluateDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbTime;
@property (weak, nonatomic) IBOutlet UILabel *lbHeadline;
@property (weak, nonatomic) IBOutlet UIButton *btFavorite;

@property(nonatomic, assign) UserRoleType roleType;
@property (strong, nonatomic) NSIndexPath *indexPath;
- (void)configPrice:(NSString *)priceStr location:(NSString *)location careType:(NSInteger)type;

@end
@protocol FavoriteDelegate

@optional
- (void)tableViewCell:(HomeCell *)cell didFavoriteAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewCell:(HomeCell *)cell didDeFavoriteAtIndexPath:(NSIndexPath *)indexPath;

@end
