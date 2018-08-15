//
//  PopularTableVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "PopularTableVC.h"
#import "JPNavigationControllerKit.h"
#import "JPNavigationControllerCompat.h"
#import "JPAnimationTool.h"

#import "HShareCareDetailVC.h"
#import "HBabysittingDetailVC.h"
#import "HEventDetailVC.h"
#import "PlistHelper.h"

@interface PopularTableVC ()<UITableViewDelegate,UITableViewDataSource,JPTableViewCellDelegate>
//@property(nonatomic, strong)NSMutableArray *dataSource;
/** data */
@property(nonatomic, strong)NSArray *items;
/** animationTool */
@property(nonatomic, strong)JPAnimationTool *animationTool;

@end
static NSString *JPTableViewReuseID = @"JPTableViewReuseID";
@implementation PopularTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 30)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 //   [self initDataSource];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JPTableViewCell class]) bundle:nil] forCellReuseIdentifier:JPTableViewReuseID];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(refresh:) 
                                                 name:@"loadPopularPage" 
                                               object:nil];
    
    
    SET_AUTOM_REFRESH_POPULAR(NO);
    [self handleResponse:[PlistHelper localPopular]]; 
}    

- (void)refresh:(NSNotification *)notification{
    self.searchCondition = [notification object];//通过这个获取到传递的对象
    [self refreshStateChange:self.refreshControl];
}
- (NSString *)api{
    return API_ALL_NEWEST_LIST;
}

- (void)handleResponse:(id)response{ 
    [PlistHelper savePopular:response];//缓存在本地
    [self.dataSource removeAllObjects];
    id shareCareObject = response[@"shareCareList"];
    id babySittingObject = response[@"babySittingList"];
    id eventsObject = response[@"eventList"];
    
    if ([shareCareObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *array = (NSArray *)shareCareObject;
        for (NSInteger index=0; index<array.count && index<5; index++) {
            [arrM addObject:[ShareCareModel modelWithDictionary:array[index]]];
        }
        if (arrM.count) {
            [self.dataSource addObject:@{@"title":CustomLocalizedString(@"EleCare", @"home"),
                                             @"items":arrM}];
            self.tableView.tableHeaderView = [UIView new];
        } 
    }
    
    if ([babySittingObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *array = (NSArray *)babySittingObject;
        for (NSInteger index=0; index<array.count && index<5; index++)   {
            [arrM addObject:[BabysittingModel modelWithDictionary:array[index]]];
        }
        if (arrM.count) { 
            [self.dataSource addObject:@{@"title":CustomLocalizedString(@"BabySitting", @"home"),
                                             @"items":arrM}];
            self.tableView.tableHeaderView = [UIView new];
        } 
    }
    if ([eventsObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrM = [NSMutableArray array];
        NSArray *array = (NSArray *)eventsObject;
        for (NSInteger index=0; index<array.count && index<5; index++) {
            [arrM addObject:[EventModel modelWithDictionary:array[index]]];
        }
        
        if (arrM.count) {
            [self.dataSource addObject:@{@"title":CustomLocalizedString(@"Events", @"home"),
                                             @"items":arrM}];
            self.tableView.tableHeaderView = [UIView new];
        } 
    }
    [self.tableView reloadData];
}
-(JPAnimationTool *)animationTool{
    if (!_animationTool) {
        _animationTool = [JPAnimationTool new];
    }
    return _animationTool;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --------------------------------------------------
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
#pragma mark --------------------------------------------------
#pragma mark UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 260;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JPTableViewReuseID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.items = self.dataSource[indexPath.row][@"items"];
    cell.title = self.dataSource[indexPath.row][@"title"];
    cell.delegate = self;
    cell.row = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark --------------------------------------------------
#pragma mark JPTableViewCellDelegate

-(void)collectionViewDidSelectedItemIndexPath:(NSIndexPath *)indexPath collcetionView:(UICollectionView *)collectionView forCell:(JPTableViewCell *)cell{
     
    NSInteger tableViewCellSection = indexPath.section;
    NSInteger tableViewCellRow = indexPath.row;
    
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    //    
    JPCollectionViewCell *collectionCell = (JPCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    CGRect frame = [collectionCell.coverImageView convertRect:collectionCell.coverImageView.bounds toView:nil];  
    NSLog(@"%@",NSStringFromCGRect(frame));
    
    
    __weak typeof(self) weakSelf = self;
    HBaseDetailVC *presentViewController ;//
    
    NSMutableArray *items  = [NSMutableArray arrayWithArray:self.dataSource[tableViewCellSection][@"items"]];
    id object = items[tableViewCellRow];
    if ([object isKindOfClass:[ShareCareModel class]]) {
        presentViewController = [HShareCareDetailVC new];
    }else if ([object isKindOfClass:[BabysittingModel class]]){ 
        presentViewController = [HBabysittingDetailVC new];
    }else if ([object isKindOfClass:[EventModel class]]){ 
        presentViewController = [HEventDetailVC new];
    } 
    presentViewController.item = object; 
    [presentViewController setHidesBottomBarWhenPushed:YES];
    presentViewController.coverImage = collectionCell.coverImageView.image;
    
    presentViewController.favoriteBlock = ^(id obj,BOOL isFavorite) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.dataSource[tableViewCellSection]];
        
        [items replaceObjectAtIndex:tableViewCellRow withObject:obj];
        [dic setObject:items forKey:@"items"];
        
        [weakSelf.dataSource replaceObjectAtIndex:tableViewCellSection withObject:dic];
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:tableViewCellSection inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    };
    
    presentViewController.closeBlock =  [self.animationTool begainAnimationWithCollectionViewDidSelectedItemIndexPath:indexPath collcetionView:collectionView forViewController:self presentViewController:presentViewController afterPresentedBlock:presentViewController.fadeBlock];
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)collectionViewDidFavoriteItemIndexPath:(NSIndexPath *)indexPath collcetionView:(UICollectionView *)collectionView forCell:(JPCollectionViewCell *)cell{
    __weak typeof(self) weakSelf = self;
    NSMutableArray *items  = [NSMutableArray arrayWithArray:self.dataSource[indexPath.section][@"items"]];
    id object = items[indexPath.row];
    NSDictionary *params = [self paramentsFormat:object];
    
    [ShareCareHttp POST:API_SHARECARE_FAVORITE_ADD_OR_REMOVE 
          withParaments:params 
       withSuccessBlock:^(id response) {
           
           BOOL status = [response[@"status"] boolValue];
           
           if ([object isKindOfClass:[ShareCareModel class]]) {
               // _shareCare.isFavorite = !_shareCare.isFavorite;
               ShareCareModel *model = (ShareCareModel *)object; 
               model.isFavorite=status;
               [items replaceObjectAtIndex:indexPath.row withObject:model];
           }else if ([object isKindOfClass:[BabysittingModel class]]){ 
               BabysittingModel *model = (BabysittingModel *)object; 
               model.isFavorite=status;
               [items replaceObjectAtIndex:indexPath.row withObject:model];
               
           }else if ([object isKindOfClass:[EventModel class]]){ 
               EventModel *model = (EventModel *)object; 
               model.isFavorite=status;
               [items replaceObjectAtIndex:indexPath.row withObject:model];
           } 
           NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.dataSource[indexPath.section]];
           [dic setObject:items forKey:@"items"];
           [weakSelf.dataSource replaceObjectAtIndex:indexPath.section withObject:dic];
           
           cell.btnFavorite.selected = status; 
           SET_AUTOM_REFRESH_FAVORITE([params[@"fType"] intValue], YES);
           SET_AUTOM_REFRESH_FAVORITE(Faveritor_all, YES);
           
       } withFailureBlock:^(NSString *error) {
           [SVProgressHUD showErrorWithStatus:error];
       }];
    
}
- (NSDictionary *)paramentsFormat:(id)object{
    if ([object isKindOfClass:[ShareCareModel class]]) {
        ShareCareModel *model = (ShareCareModel *)object; 
        return @{@"fType":@"0",
                 @"fTypeId":model.idValue,
                 @"status":[NSString stringWithFormat:@"%d",!model.isFavorite]
                 };
    }else if ([object isKindOfClass:[BabysittingModel class]]){ 
        BabysittingModel *model = (BabysittingModel *)object; 
        return @{@"fType":@"1",
                 @"fTypeId":model.idValue,
                 @"status":[NSString stringWithFormat:@"%d",!model.isFavorite]
                 };
    }else if ([object isKindOfClass:[EventModel class]]){ 
        EventModel *model = (EventModel *)object; 
        return @{@"fType":@"2",
                 @"fTypeId":model.idValue,
                 @"status":[NSString stringWithFormat:@"%d",!model.isFavorite]
                 };
    } 
    return nil;
    
}
@end
