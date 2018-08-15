//
//  FavoriteTableVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/1.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "FavoriteTableVC.h"
#import "FavoriteCell.h"
#import "HBaseDetailVC.h"
#import "HShareCareDetailVC.h"
#import "HBabysittingDetailVC.h"
#import "HEventDetailVC.h"
@interface FavoriteTableVC ()

@end

@implementation FavoriteTableVC
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FavoriteCell  class]) bundle:nil] forCellReuseIdentifier:@"FavoriteCell"];
    self.tableView.tableFooterView = [UIView new];
} 
//- (void)refreshStateChange:(UIRefreshControl *)control{
//    [control endRefreshing];
//    if (_delegate) {
//        [_delegate reload];
//    }
//} 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell" forIndexPath:indexPath];
    
    // Configure the cell...
    id item = self.dataSource[indexPath.row];
    
    [cell.icon setImageWithURL:[NSURL URLWithString:[self firstPhotoFrom:item]] 
              placeholderImage:kDEFAULT_IMAGE];
    cell.lbName.text = [self typeStringFrom:item];
    cell.lbDesc.text = [self contentStringFrom:item];
    cell.price = [self priceStringFrom:item];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    __weak typeof(self) weakSelf = self;
    HBaseDetailVC *presentViewController ;//
    
    id object = self.dataSource[indexPath.row];
    if ([object isKindOfClass:[ShareCareModel class]]) {
        presentViewController = [HShareCareDetailVC new];
    }else if ([object isKindOfClass:[BabysittingModel class]]){ 
        presentViewController = [HBabysittingDetailVC new];
    }else if ([object isKindOfClass:[EventModel class]]){ 
        presentViewController = [HEventDetailVC new];
    } 
    presentViewController.item = object; 
    
    presentViewController.favoriteBlock = ^(id obj, BOOL isFavorite) {
        //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   //     [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:obj];
        //  [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (isFavorite) {
            [weakSelf.dataSource insertObject:obj atIndex:indexPath.row];
        }else{
            [weakSelf.dataSource removeObject:obj];
        }
        
        [weakSelf.tableView reloadData];
    };
    
    presentViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:presentViewController animated:YES];
}

- (NSString *)typeStringFrom:(id)object{
    if ([object isKindOfClass:[ShareCareModel class]]) {
        return @"EleCare";
    }else if ([object isKindOfClass:[BabysittingModel class]]){
        return @"Babysitting";
    }else if ([object isKindOfClass:[EventModel class]]){
        return @"Events";
    }
    return @"EleCare";
}
- (NSString *)contentStringFrom:(id)object{
    if ([object isKindOfClass:[ShareCareModel class]]) {
        return ((ShareCareModel *)object).headline;
    }else if ([object isKindOfClass:[BabysittingModel class]]){
        return ((BabysittingModel *)object).headLine;
    }else if ([object isKindOfClass:[EventModel class]]){
        return ((EventModel *)object).listingHeadline;
    }
    return @"EleCare";
}
- (NSString *)priceStringFrom:(id)object{
    if ([object isKindOfClass:[ShareCareModel class]]) {
        return [NSString stringWithFormat:@"$%@/day",((ShareCareModel *)object).moneyPerDay];
    }else if ([object isKindOfClass:[BabysittingModel class]]){
        return [NSString stringWithFormat:@"$%@/hr",((BabysittingModel *)object).chargePerHour];
    }else if ([object isKindOfClass:[EventModel class]]){
       NSString*price = [NSString stringWithFormat:@"%@",((EventModel *)object).child.floatValue==0?@"FREE for kids":[NSString stringWithFormat:@"$%@",((EventModel *)object).child]];
        return @"";
    }
    return @"FREE";
}
- (NSString *)firstPhotoFrom:(id)object{
    if ([object isKindOfClass:[ShareCareModel class]]) {
        return URLStringForPath(((ShareCareModel *)object).thumbnail);
    }else if ([object isKindOfClass:[BabysittingModel class]]){
        return URLStringForPath(((BabysittingModel *)object).thumbnail);
    }else if ([object isKindOfClass:[EventModel class]]){
        return URLStringForPath(((EventModel *)object).thumbnail);
    }
    return @"";
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
