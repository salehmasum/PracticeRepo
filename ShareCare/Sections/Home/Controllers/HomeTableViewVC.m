//
//  HomeTableViewVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/30.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HomeTableViewVC.h"
#import "HBaseDetailVC.h"
#import "HShareCareDetailVC.h"
#import "HBabysittingDetailVC.h"
#import "HEventDetailVC.h"
@interface HomeTableViewVC (){
}

/** animationTool */
@property(nonatomic, strong)JPAnimationTool *animationTool;
@end

@implementation HomeTableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO; 
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCell class]) bundle:nil] forCellReuseIdentifier:@"reuseIdentifier"];
    self.tableView.tableFooterView = [UIView new];
    
    
}  
- (HTTPMethod)httpMethod{
    return HTTPMethodPOST;
}
- (id)paraments{
    
    return self.searchCondition;
}

- (void)setConditionEnable:(BOOL)conditionEnable{
    _conditionEnable = conditionEnable;
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:self.searchCondition];
    [temp setObject:@(conditionEnable) forKey:@"conditionEnable"];
    self.searchCondition = temp;
}
- (void)refresh:(NSNotification*) notification{
    self.searchCondition = [notification object];//通过这个获取到传递的对象
    [self loadPage:0];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240*TX_SCREEN_OFFSET;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    // Configure the cell...
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
    presentViewController.hidesBottomBarWhenPushed = YES;
 //   presentViewController.idValue = ((BaseModel *)object).idValue;
    //
    presentViewController.favoriteBlock = ^(id obj,BOOL isFavorite) {
      //  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:obj];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    };
    [self.navigationController pushViewController:presentViewController animated:YES];
}

- (void)tableViewCell:(HomeCell *)cell didFavoriteAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    id object = self.dataSource[indexPath.row];
    NSDictionary *params = [self paramentsFormat:object];
    
    [ShareCareHttp POST:API_SHARECARE_FAVORITE_ADD_OR_REMOVE 
          withParaments:params 
       withSuccessBlock:^(id response) {
        
           BOOL status = [response[@"status"] boolValue];
           
           if ([object isKindOfClass:[ShareCareModel class]]) {
              // _shareCare.isFavorite = !_shareCare.isFavorite;
               ShareCareModel *model = (ShareCareModel *)object; 
               model.isFavorite=status;
               [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
           }else if ([object isKindOfClass:[BabysittingModel class]]){ 
               BabysittingModel *model = (BabysittingModel *)object; 
               model.isFavorite=status;
               [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
               
           }else if ([object isKindOfClass:[EventModel class]]){ 
               EventModel *model = (EventModel *)object; 
               model.isFavorite=status;
               [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
           } 
           cell.btFavorite.selected = status; 
           SET_AUTOM_REFRESH_FAVORITE([params[@"fType"] intValue], YES);
           SET_AUTOM_REFRESH_FAVORITE(Faveritor_all, YES);
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint vel = [scrollView.panGestureRecognizer velocityInView:scrollView];
   // NSLog(@"%f",vel.y);
    if (vel.y >= 0) {
        // 下拉
    }else
    {
        // 上拉
        [_delegate homeTableViewDidScrollUpwardDirection];
    }
}
@end
