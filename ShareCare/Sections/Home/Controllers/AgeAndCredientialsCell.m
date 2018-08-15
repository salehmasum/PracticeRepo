//
//  AgeAndCredientialsCell.m
//  ShareCare
//
//  Created by 朱明 on 2018/5/4.
//  Copyright © 2018年 Alvis. All rights reserved.
//

#import "AgeAndCredientialsCell.h"
#import "JYEqualCellSpaceFlowLayout.h"
@implementation AgeAndCredientialsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //1.初始化layout
    UICollectionViewFlowLayout *layout = [[JYEqualCellSpaceFlowLayout alloc] initWthType:AlignWithCenter];
    //设置collectionView滚动方向
    //    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //设置headerView的尺寸大小
    layout.headerReferenceSize = CGSizeMake(self.frame.size.width, 30);
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(110, 150); 
    
    //2.初始化collectionView
   // self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    [self addSubview:self.collectionView];
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollEnabled = NO;
    //3.注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerNib:[UINib nibWithNibName:@"AgeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AgeCollectionViewCell"];
    
//    //注册headerView  此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致  均为reusableView
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //4.设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
     
}
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithArray:@[@[],@[],@[]]];
    }
    return _dataSource;
}
- (void)setAgeRange:(AgeRangeModel *)ageRange{
    _ageRange = ageRange;
    NSMutableArray *array = [NSMutableArray array];
    if (ageRange.age0_1) {
        [array addObject:@{@"icon":@"0-12months-enabled",@"name":@"0-12months"}];
    }
    if (ageRange.age1_2) {
        [array addObject:@{@"icon":@"1-2years-enabled",@"name":@"1-2 years"}];
    }
    if (ageRange.age2_3) {
        [array addObject:@{@"icon":@"2-3years-enabled",@"name":@"2-3 years"}];
    }
    if (ageRange.age3_5) {
        [array addObject:@{@"icon":@"3-5years-enabled",@"name":@"3-5 years"}];
    }
    if (ageRange.age5) {
        [array addObject:@{@"icon":@"5+years-enabled",@"name":@"5+ years"}];
    } 
    
    [self.dataSource replaceObjectAtIndex:0 withObject:array];
    [self.collectionView reloadData];
}

- (void)setCredentials:(CredentialsModel *)credentials{
    _credentials = credentials;
    NSMutableArray *array = [NSMutableArray array];
    if (credentials.nonsmoker) {
        [array addObject:@{@"icon":@"non-smoker-enabled",@"name":@"Non smoker"}];
    }
    if (credentials.drivers) {
        [array addObject:@{@"icon":@"drivers-license-enabled",@"name":@"Driver’s License"}];
    }
    if (credentials.havecar) {
        [array addObject:@{@"icon":@"has-car-enabled",@"name":@"Has Car"}];
    }
    if (credentials.cleaning) {
        [array addObject:@{@"icon":@"cleaning-enabled",@"name":@"Cleaning"}];
    }
    if (credentials.anphylaxis) {
        [array addObject:@{@"icon":@"anaphylaxis-enabled",@"name":@"Anaphylaxis"}];
    } 
    if (credentials.firstaid) {
        [array addObject:@{@"icon":@"firstaid-enabled",@"name":@"First Aid"}];
    }
    if (credentials.cooking) {
        [array addObject:@{@"icon":@"cooking-enabled",@"name":@"Cooking"}];
    }
    if (credentials.tutoring) {
        [array addObject:@{@"icon":@"tutoring-enabled",@"name":@"Tutor"}];
    }  
    
    NSMutableArray *temp1 = [NSMutableArray array];
    NSMutableArray *temp2 = [NSMutableArray array];
    
    if (array.count == 5) {
        [temp1 addObject:array[0]];
        [temp1 addObject:array[1]];
        [temp2 addObject:array[2]];
        [temp2 addObject:array[3]];
        [temp2 addObject:array[4]]; 
    }else if (array.count == 6){ 
        [temp1 addObject:array[0]];
        [temp1 addObject:array[1]];
        [temp1 addObject:array[2]];
        [temp2 addObject:array[3]];
        [temp2 addObject:array[4]]; 
        [temp2 addObject:array[5]]; 
        
    }else if (array.count == 7){ 
        [temp1 addObject:array[0]];
        [temp1 addObject:array[1]];
        [temp1 addObject:array[2]];
        [temp2 addObject:array[3]];
        [temp2 addObject:array[4]]; 
        [temp2 addObject:array[5]]; 
        [temp2 addObject:array[6]]; 
    }else if (array.count == 8){
        [temp1 addObject:array[0]];
        [temp1 addObject:array[1]];
        [temp1 addObject:array[2]];
        [temp1 addObject:array[3]];
        [temp2 addObject:array[4]]; 
        [temp2 addObject:array[5]]; 
        [temp2 addObject:array[6]]; 
        [temp2 addObject:array[7]]; 
    }else{
        [temp1 addObjectsFromArray:array];
    }
    
    
    [self.dataSource replaceObjectAtIndex:1 withObject:array];
    [self.dataSource replaceObjectAtIndex:2 withObject:temp2];
    [self.collectionView reloadData];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataSource[section];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AgeCollectionViewCell *cell = (AgeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"AgeCollectionViewCell" forIndexPath:indexPath];
    
    NSArray *array = self.dataSource[indexPath.section];
    cell.icon.image = [UIImage imageNamed:array[indexPath.row][@"icon"]];
    cell.lbName.text = array[indexPath.row][@"name"];
   // cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((60+20*(indexPath.section>0))*TX_SCREEN_OFFSET, 80);
}

//footer的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//header的size
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(10, 10);
//}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{ 
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}


//通过设置SupplementaryViewOfKind 来设置头部或者底部的view，其中 ReuseIdentifier 的值必须和 注册是填写的一致，本例都为 “reusableView”
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];  
    if (headerView.subviews.count == 0) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 200, 30)];
        label.text = (indexPath.section?@"Credientials":@"Provides Care for Ages");
        label.font = TX_FONT(16);
        label.textColor = TX_RGB(136, 136, 136);
        
        [headerView addSubview:label];
    }
    
    for (id obj in headerView.subviews) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel *temp = (UILabel *)obj;
            temp.text = (indexPath.section?@"Credientials":@"Provides Care for Ages");
        }
    }
    
    return headerView;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
}
@end
