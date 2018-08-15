//
//  FBabysittingVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/11.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "FBabysittingVC.h"

@interface FBabysittingVC ()

@end

@implementation FBabysittingVC
- (void)reload{
    
    if (self.viewLoaded == NO) return;
    if (IS_AUTOM_REFRESH_FAVORITE(1) && !self.requestIsLoading) {
     //   [SVProgressHUD showWithStatus:TEXT_LOADING];
        [self refreshStateChange:self.refreshControl];
        
        SET_AUTOM_REFRESH_FAVORITE(1,NO);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view. 
}
- (NSString *)api{
    return API_BABYSITTING_FAVORITE_LIST;
}
- (id)modelWithDictionary:(NSDictionary *)dic{
    return [BabysittingModel modelWithDictionary:dic];
}
- (id)convertObjectWithObject:(id)object{
    BabysittingModel *model = [BabysittingModel modelWithDictionary:object];
    model.isFavorite = YES;
    return model;
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
