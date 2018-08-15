//
//  FAllVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/11.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "FAllVC.h"

@interface FAllVC ()

@end

@implementation FAllVC


- (void)reload{
    
    if (self.viewLoaded == NO) return;
    
    if (IS_AUTOM_REFRESH_FAVORITE(Faveritor_all) && !self.requestIsLoading) {
     //   [SVProgressHUD showWithStatus:TEXT_LOADING];
        [self refreshStateChange:self.refreshControl];
        SET_AUTOM_REFRESH_FAVORITE(Faveritor_all,NO);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)refreshStateChange:(UIRefreshControl *)control{
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_ALL_FAVORITE_LIST withParaments:nil withSuccessBlock:^(id response) {
       // NSLog(@"%@",response); 
        
        weakSelf.dataSource = [NSMutableArray array];
        id shareCareObject = response[@"favoriteShareCareList"];
        id babySittingObject = response[@"favoriteBabysittingList"];
        id eventsObject = response[@"favoriteEventList"];
        
        if ([shareCareObject isKindOfClass:[NSArray class]]) { 
            for (id object in shareCareObject) {
                NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:object];
                [mutableDic setObject:@"1" forKey:@"isFavorite"];
                [weakSelf.dataSource addObject:[ShareCareModel modelWithDictionary:mutableDic]];
            } 
        }
        
        if ([babySittingObject isKindOfClass:[NSArray class]]) { 
            for (id object in babySittingObject) {
                NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:object];
                [mutableDic setObject:@"1" forKey:@"isFavorite"];
                [weakSelf.dataSource addObject:[BabysittingModel modelWithDictionary:mutableDic]];
            } 
        }
        if ([eventsObject isKindOfClass:[NSArray class]]) { 
            for (id object in eventsObject) {
                NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:object];
                [mutableDic setObject:@"1" forKey:@"isFavorite"];
                [weakSelf.dataSource addObject:[EventModel modelWithDictionary:mutableDic]];
            } 
        }
        [weakSelf.tableView reloadData];
        
        [weakSelf resetUI];
        
        // 3. 结束刷新
        [control endRefreshing];
        
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        // 3. 结束刷新
        [weakSelf resetUI];
        [control endRefreshing];
        [SVProgressHUD dismiss];
    }];
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
