//
//  HEventTableVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HEventTableVC.h"
#import "HEventDetailVC.h"

@interface HEventTableVC ()


@end

@implementation HEventTableVC
@synthesize searchCondition = _searchCondition;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refresh:) 
                                                 name:@"loadEventPage" 
                                               object:nil];
    SET_AUTOM_REFRESH_HOME(2, NO);  
    NSArray *array = [PlistHelper localEventList];
    for (id obj in array) [self.dataSource addObject:[self convertObjectWithObject:obj]];
}


- (NSDictionary *)paramentsFormat:(id)obj{
    EventModel *model = (EventModel *)obj; 
    return @{@"fType":@"2",
             @"fTypeId":model.idValue,
             @"status":[NSString stringWithFormat:@"%d",!model.isFavorite]
             };
}
- (NSString *)api{
   // return [NSString stringWithFormat:@"%@%@&",API_EVENT_LIST,self.searchKey];
    return API_EVENT_LIST;
}
- (id)convertObjectWithObject:(id)object{
    return [EventModel modelWithDictionary:object];
}
- (void)handleResponse:(id)response{
    [super handleResponse:response];
    if (self.pageModel.first)  [PlistHelper saveEvent:self.pageModel.content];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    // Configure the cell...
    
    EventModel *event = self.dataSource[indexPath.row];
    
//    NSArray *photos = event.imagePath;
//    if (photos && photos.count) {
//        [cell.thumbnailView setImageWithURL:[NSURL URLWithString:URLStringForPath([photos firstObject])] 
//                           placeholderImage:HOME_CELL_PLACEHOLDIMAGE]; 
//    }else{
//        [cell.thumbnailView setImage:HOME_CELL_PLACEHOLDIMAGE];
//    }  
    
    NSLog(@"thumbnailView.imageUrl:%@",URLStringForPath(event.thumbnail));
    [cell.thumbnailView setImageWithURL:[NSURL URLWithString:URLStringForPath(event.thumbnail)] 
                       placeholderImage:HOME_CELL_PLACEHOLDIMAGE]; 
    cell.descLabel.text =event.eventDescription; 
    cell.starView.hidden = YES; 
    cell.evaluateDescLabel.hidden = YES;
    cell.lbTime.text = [self dateAndTimewith:event];
    [cell configPrice:event.listingHeadline 
             location:event.ageRange
             careType:2];
    [cell.headPortraitView setImageWithURL:[NSURL URLWithString:URLStringForPath(event.userIcon)] 
                          placeholderImage:kDEFAULT_HEAD_IMAGE];
    cell.btFavorite.selected = event.isFavorite;
    cell.starView.scorePercent = [[event totalStarRating] floatValue];
    cell.evaluateDescLabel.text = [NSString stringWithFormat:@"%@ Reviews",event.reviewsCount];
    return cell;
}
- (NSString *)dateAndTimewith:(EventModel *)event{
    if ([event.startDateStr containsString:@" • "] && [event.endDateStr containsString:@" • "] ) {
        NSString *endStr = [event.endDateStr componentsSeparatedByString:@" • "][1]; 
        return [NSString stringWithFormat:@"%@-%@",event.startDateStr,endStr];
    }
    
    return [NSString stringWithFormat:@"%@-%@",event.startDateStr,event.endDateStr];
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
