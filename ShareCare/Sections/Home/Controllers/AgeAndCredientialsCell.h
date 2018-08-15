//
//  AgeAndCredientialsCell.h
//  ShareCare
//
//  Created by 朱明 on 2018/5/4.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgeCollectionViewCell.h"
#import "AgeRangeModel.h"
#import "CredentialsModel.h"

@interface AgeAndCredientialsCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) AgeRangeModel *ageRange;
@property (strong, nonatomic) CredentialsModel *credentials;
@property (strong, nonatomic) NSMutableArray *dataSource;
@end
