//
//  JPCollectionViewCell.h
//  JPAnimation
//
//  Hello! I am NewPan from Guangzhou of China, Glad you could use my framework, If you have any question or wanna to contact me, please open https://github.com/Chris-Pan or http://www.jianshu.com/users/e2f2d779c022/latest_articles
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"


@class JPTableViewCell, JPCollectionViewCell;
@protocol JPCollectionViewCellDelegate <NSObject>

@optional

- (void)collectionViewDidFavoriteItemIndexPath:(NSIndexPath *)indexPath forCell:(JPCollectionViewCell *)cell;

@end
@interface JPCollectionViewCell : UICollectionViewCell

@property(nonatomic, weak)id<JPCollectionViewCellDelegate> delegate;
/** dataSrouce */
@property(nonatomic, strong)NSString *dataString;
@property(nonatomic, strong)NSString *priceStr;
@property(nonatomic, strong)NSString *desc;

@property (nonatomic, assign) NSInteger row;

@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbDesc;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnFavorite;
@property (weak, nonatomic) IBOutlet UILabel *evaluateDescLabel;
@property (weak, nonatomic) IBOutlet CWStarRateView *starView;
- (void)configPrice:(NSString *)priceStr location:(NSString *)location;
@end
