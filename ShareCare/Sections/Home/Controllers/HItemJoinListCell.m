//
//  HItemJoinListCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HItemJoinListCell.h"
#import "HJoinCell.h"
#import "ChildrenModel.h"


#define CollectionCellW 75.0f
#define CollectionCellH 70.0f

@implementation HItemJoinListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}


- (void)configMaxChild:(NSInteger)max bookingChilds:(NSArray *)childrens{
    
    _max = max;
    _childrens=childrens;
    
    CGFloat width = (CollectionCellW+10)*max;
    width = (width>=TX_SCREEN_WIDTH)?TX_SCREEN_WIDTH:width;
    
    self.collectionView.frame = CGRectMake(0, 0, width, CollectionCellH);
    self.collectionView.center = CGPointMake(TX_SCREEN_WIDTH/2, CollectionCellH/2);
    [self.collectionView reloadData];
}

#pragma mark --------------------------------------------------
#pragma mark UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _max;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HJoinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HJoinCell" forIndexPath:indexPath];
    
    if (indexPath.row<_childrens.count) {
        ChildrenModel *child = _childrens[indexPath.row];
        cell.lbAge.text = child.age;
        
        if ([child.gender isEqualToString:@"Female"]) {
            cell.icon.image = [UIImage imageNamed:@"elephant-pink"];//女
        }else{
            cell.icon.image = [UIImage imageNamed:@"bookings-enabled"];//男／未填写
        }
    }else{
        cell.icon.image = [UIImage imageNamed:@"booking-disabled"];//女
        cell.lbAge.text = @"available";
    }
    
    return cell;
}

#pragma mark --------------------------------------------------
#pragma mark Setup

-(void)setup{
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HJoinCell class]) bundle:nil] forCellWithReuseIdentifier:@"HJoinCell"];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake(CollectionCellW, CollectionCellH);
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0 ;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 0);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
