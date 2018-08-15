//
//  HItemJoinListCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HItemJoinListCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger _max;
    NSArray *_childrens;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

/** delegate */
//@property(nonatomic, weak)id<JPTableViewCellDelegate> delegate;

/** data */
//@property(nonatomic, strong)NSArray *items;
//@property(nonatomic, strong)NSArray *childs;


- (void)configMaxChild:(NSInteger)max bookingChilds:(NSArray *)childrens;
@end
