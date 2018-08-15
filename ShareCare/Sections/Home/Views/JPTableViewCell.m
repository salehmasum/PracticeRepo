//
//  JPTableViewCell.m
//  JPAnimation
//
//  Hello! I am NewPan from Guangzhou of China, Glad you could use my framework, If you have any question or wanna to contact me, please open https://github.com/Chris-Pan or http://www.jianshu.com/users/e2f2d779c022/latest_articles
//

#import "JPTableViewCell.h"
#import "ShareCareModel.h"
#import "BabysittingModel.h"
#import "EventModel.h"

@interface JPTableViewCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

const CGFloat JPCollectionCellW = 130;
const CGFloat JPCollectionCellInfoH = 209;
static NSString *JPCollectionViewReuseID = @"JPCollectionViewReuseID";
@implementation JPTableViewCell

-(void)awakeFromNib{
    [super awakeFromNib];
 
    [self setup];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title; 
   // _titleLabel.font = TX_FONT(28);
}
-(void)setItems:(NSArray *)items{
    _items = items;
    [self.collectionView reloadData];
}


#pragma mark --------------------------------------------------
#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(collectionViewDidSelectedItemIndexPath:collcetionView:forCell:)]) {
        
        //[NSIndexPath indexPathForRow:indexPath.row inSection:self.row]
        [self.delegate collectionViewDidSelectedItemIndexPath: [NSIndexPath indexPathForRow:indexPath.row inSection:self.row]
                                               collcetionView:collectionView 
                                                      forCell:self];
    }
}


#pragma mark --------------------------------------------------
#pragma mark UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JPCollectionViewReuseID forIndexPath:indexPath];
    
    id object = self.items[indexPath.row];
    if ([object isKindOfClass:[ShareCareModel class]]) {
        ShareCareModel *model = (ShareCareModel *)object;
        [cell.coverImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(model.thumbnail)] 
                            placeholderImage:kDEFAULT_IMAGE];
        [cell configPrice:[NSString stringWithFormat:@"$%@/day",model.moneyPerDay] 
                 location:model.address];
        cell.lbDesc.text = model.shareCareContent;
        cell.btnFavorite.selected = model.isFavorite;
        cell.starView.scorePercent = [[model totalStarRating] floatValue];
        cell.evaluateDescLabel.text = [NSString stringWithFormat:@"%@ Reviews",model.reviewsCount];
        cell.row = indexPath.row;
        cell.delegate = self;
    }
    if ([object isKindOfClass:[BabysittingModel class]]) {
        BabysittingModel *model = (BabysittingModel *)object;
        [cell.coverImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(model.thumbnail)] 
                            placeholderImage:kDEFAULT_IMAGE];
        [cell configPrice:[NSString stringWithFormat:@"$%@/hr",model.chargePerHour] 
                 location:model.headLine];
        cell.lbDesc.text = model.aboutMe;
        cell.btnFavorite.selected = model.isFavorite;
        cell.starView.scorePercent = [[model totalStarRating] floatValue];
        cell.evaluateDescLabel.text = [NSString stringWithFormat:@"%@ Reviews",model.reviewsCount];
        cell.row = indexPath.row;
        cell.delegate = self;
    }
    if ([object isKindOfClass:[EventModel class]]) {
        EventModel *model = (EventModel *)object;
        [cell.coverImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(model.thumbnail)] 
                            placeholderImage:kDEFAULT_IMAGE];
        [cell configPrice:model.listingHeadline location:model.ageRange];
        cell.lbDesc.text = model.eventDescription;
        cell.btnFavorite.selected = model.isFavorite;
//        cell.starView.scorePercent = [[model totalStarRating] floatValue];
//        cell.evaluateDescLabel.text = [NSString stringWithFormat:@"%@ Reviews",model.reviewsCount];
        cell.starView.hidden = YES;
        cell.evaluateDescLabel.hidden = YES;
        cell.row = indexPath.row;
        cell.delegate = self;
        
    }
    
    
    return cell;
}

- (void)collectionViewDidFavoriteItemIndexPath:(NSIndexPath *)indexPath forCell:(JPCollectionViewCell *)cell{
    if (_delegate) {
        [_delegate collectionViewDidFavoriteItemIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:_row] 
                                           collcetionView:self.collectionView 
                                                  forCell:cell];
    }
}

#pragma mark --------------------------------------------------
#pragma mark Setup

-(void)setup{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JPCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:JPCollectionViewReuseID];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(JPCollectionCellW, JPCollectionCellInfoH);
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0 ;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 0);
}

@end
