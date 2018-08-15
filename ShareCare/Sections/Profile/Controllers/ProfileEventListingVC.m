//
//  ProfileEventListingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/2.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "ProfileEventListingVC.h"
#import "CreateEventsVC.h"
#import "HomeCell.h"
#import "UIViewController+Create.h"
@interface ProfileEventListingVC ()

@end

@implementation ProfileEventListingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCell class]) bundle:nil] forCellReuseIdentifier:@"reuseIdentifier"];
}
- (NSString *)headerTitleText{
    return @"You don’t have any listings!";
}
- (NSString *)headerDescText{
    return @"Make money by renting out your extra space on EleCare. You’ll also get to meet amazing parents from around your area! ";
}

- (NSString *)api{
    return API_EVENT_MYSELF_LIST;
}

- (id)convertObjectWithObject:(id)object{
    return [EventModel modelWithDictionary:object];
}
- (void)post:(id)sender{ 
    [self verifyChildrenLicenseForType:2 pass:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240*TX_SCREEN_OFFSET;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
    EventModel *event = self.dataSource[indexPath.row];
    
 //   NSArray *photos = event.imagePath;
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
    cell.btFavorite.hidden = YES;
    
    return cell;
}

- (NSString *)dateAndTimewith:(EventModel *)event{
    if ([event.startDateStr containsString:@" • "] && [event.endDateStr containsString:@" • "] ) {
        NSString *endStr = [event.endDateStr componentsSeparatedByString:@" • "][1]; 
        return [NSString stringWithFormat:@"%@-%@",event.startDateStr,endStr];
    }
    
    return [NSString stringWithFormat:@"%@-%@",event.startDateStr,event.endDateStr];
}

@end
