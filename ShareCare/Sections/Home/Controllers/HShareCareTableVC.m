//
//  HShareCareTableVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HShareCareTableVC.h"
#import "HShareCareDetailVC.h"
#import "ShareCareModel.h"
@interface HShareCareTableVC ()

@end

@implementation HShareCareTableVC 
@synthesize searchCondition = _searchCondition;

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
      
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional s
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refresh:) 
                                                 name:@"loadShareCarePage" 
                                               object:nil];
    SET_AUTOM_REFRESH_HOME(0, NO); 
    
    NSArray *array = [PlistHelper localEleCareList];
    for (id obj in array) [self.dataSource addObject:[self convertObjectWithObject:obj]];
}



- (NSString *)api{
  //  return [NSString stringWithFormat:@"%@%@&",API_SHARECARE_LIST,self.searchKey];
    return API_SHARECARE_LIST;
}
- (NSDictionary *)paramentsFormat:(id)obj{
    ShareCareModel *model = (ShareCareModel *)obj; 
    return @{@"fType":@"0",
             @"fTypeId":model.idValue,
             @"status":[NSString stringWithFormat:@"%d",!model.isFavorite]
             };
}
- (id)convertObjectWithObject:(id)object{
    return [ShareCareModel modelWithDictionary:object];
}

- (void)handleResponse:(id)response{
    [super handleResponse:response];
    if (self.pageModel.first)  [PlistHelper saveEleCare:self.pageModel.content];
    
}

//- (void)resetUI{
//    [super resetUI];
//    [self.tableView reloadData];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    // Configure the cell...
    
    ShareCareModel *model = self.dataSource[indexPath.row]; 
//    NSArray *photos = model.photosPath; 
//    if (photos.count) {
//        [cell.thumbnailView setImageWithURL:[NSURL URLWithString:URLStringForPath(photos.firstObject)] 
//                           placeholderImage:HOME_CELL_PLACEHOLDIMAGE]; 
//    }else{
//        [cell.thumbnailView setImage:HOME_CELL_PLACEHOLDIMAGE];
//    }  
    
    [cell.thumbnailView setImageWithURL:[NSURL URLWithString:URLStringForPath(model.thumbnail)] 
                       placeholderImage:HOME_CELL_PLACEHOLDIMAGE]; 
    cell.descLabel.text = [NSString stringWithFormat:@"%@",model.headline]; 
    [cell configPrice:[NSString stringWithFormat:@"$%@/day",model.moneyPerDay] 
             location:model.address
             careType:0];
    [cell.headPortraitView setImageWithURL:[NSURL URLWithString:URLStringForPath(model.userIcon)] 
                          placeholderImage:kDEFAULT_HEAD_IMAGE];
    cell.btFavorite.selected = model.isFavorite;
    cell.starView.scorePercent = [[model totalStarRating] floatValue];
    cell.evaluateDescLabel.text = [NSString stringWithFormat:@"%@ Reviews",model.reviewsCount];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

@end
