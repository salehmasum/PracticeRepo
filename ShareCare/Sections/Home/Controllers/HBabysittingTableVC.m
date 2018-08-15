//
//  HBabysittingTableVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HBabysittingTableVC.h"
#import "HBabysittingDetailVC.h"
#import "BabysittingModel.h"
@interface HBabysittingTableVC ()

@end

@implementation HBabysittingTableVC
@synthesize searchCondition = _searchCondition;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refresh:) 
                                                 name:@"loadBabysittingPage" 
                                               object:nil];
    SET_AUTOM_REFRESH_HOME(1, NO);  
    NSArray *array = [PlistHelper localBabysittingList];
    for (id obj in array) [self.dataSource addObject:[self convertObjectWithObject:obj]];
}



- (NSDictionary *)paramentsFormat:(id)obj{
    BabysittingModel *model = (BabysittingModel *)obj; 
    return @{@"fType":@"1",
             @"fTypeId":model.idValue,
             @"status":[NSString stringWithFormat:@"%d",!model.isFavorite]
             };
}
- (NSString *)api{
    //return [NSString stringWithFormat:@"%@%@&",API_BABYSITTING_LIST,self.searchKey];
    return API_BABYSITTING_LIST;
}
- (id)convertObjectWithObject:(id)object{
    return [BabysittingModel modelWithDictionary:object];
}
- (void)handleResponse:(id)response{
    [super handleResponse:response];
    if (self.pageModel.first)  [PlistHelper saveBabysitting:self.pageModel.content];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    // Configure the cell...
    
    BabysittingModel *model = self.dataSource[indexPath.row]; 
    NSArray *photos = model.photosPath;
//    if (photos.count) {
//        [cell.thumbnailView setImageWithURL:[NSURL URLWithString:URLStringForPath([photos firstObject])] 
//                           placeholderImage:HOME_CELL_PLACEHOLDIMAGE]; 
//    }else{
//        [cell.thumbnailView setImage:HOME_CELL_PLACEHOLDIMAGE];
//    }  
    [cell.thumbnailView setImageWithURL:[NSURL URLWithString:URLStringForPath(model.thumbnail)] 
                        placeholderImage:HOME_CELL_PLACEHOLDIMAGE]; 
    cell.descLabel.text = [NSString stringWithFormat:@"%@",model.headLine]; 
    
    [cell configPrice:[NSString stringWithFormat:@"$%@/hr",model.chargePerHour] 
             location:model.headLine
             careType:1];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
