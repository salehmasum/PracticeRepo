//
//  FavoriteVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/8/6.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "FavoriteVC.h" 
#import "FavoriteTableVC.h"
#import "FAllVC.h"
#import "FBabysittingVC.h"
#import "FShareCareVC.h"
#import "FEventsVC.h"
@interface FavoriteVC (){
    
    NSInteger _selectedIndex;
}

@property (strong, nonatomic) FAllVC         *allVC;
@property (strong, nonatomic) FShareCareVC   *sharecareVC;
@property (strong, nonatomic) FBabysittingVC *babysittingVC;
@property (strong, nonatomic) FEventsVC      *eventVC;
@property (strong, nonatomic) NSMutableArray *dataSource;
@end

@implementation FavoriteVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"_______%@________%ld",self.class,_selectedIndex);
    
    [self refreshAtIndex:_selectedIndex];
}

- (void)refreshAtIndex:(NSInteger)index{
    switch (_selectedIndex) {
        case 0:
            [self.allVC reload];
            break;
        case 1:
            [self.sharecareVC reload];
            break;
        case 2:
            [self.babysittingVC reload];
            break;
        case 3:
            [self.eventVC reload];
            break;
            
        default:
            break;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self queryAll];
    
  //  self.segScroll.showIndex
    _selectedIndex = 0;
}

- (void)didSelectedIndex:(NSInteger)index{
   // [super didSelectedIndex:index];
    _selectedIndex = index;
    [self refreshAtIndex:_selectedIndex];
}
#pragma mark --------------------------------------------------
#pragma mark Setup

- (NSArray *)vcArr{ 
    
    return @[self.allVC,self.sharecareVC,self.babysittingVC,self.eventVC];
}

- (FAllVC *)allVC{
    if (!_allVC) {
        _allVC = [[FAllVC alloc] init]; 
    }
    return _allVC;
}
- (FShareCareVC *)sharecareVC{
    if (!_sharecareVC) {
        _sharecareVC = [[FShareCareVC alloc] init]; 
    }
    return _sharecareVC;
}
- (FBabysittingVC *)babysittingVC{
    if (!_babysittingVC) {
        _babysittingVC = [[FBabysittingVC alloc] init]; 
    }
    return _babysittingVC;
}
- (FEventsVC *)eventVC{
    if (!_eventVC) {
        _eventVC = [[FEventsVC alloc] init]; 
    }
    return _eventVC;
}

- (NSString *)navTitle{
    return CustomLocalizedString(@"Favourites", @"home");
}
- (NSArray *)menuItems{
    return @[CustomLocalizedString(@"ALL", @"favorite"),
             CustomLocalizedString(@"ELECARE", @"favorite"),
             CustomLocalizedString(@"BABYSITTING", @"favorite"),
             CustomLocalizedString(@"EVENTS", @"favorite")
             ];
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
