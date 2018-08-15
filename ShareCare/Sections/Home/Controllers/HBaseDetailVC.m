//
//  HBaseDetailVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/15.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "HBaseDetailVC.h"
#import "HIteminfoCell.h"
#import "HItemJoinListCell.h"
#import "ContactTitleCell.h"
#import "ReviewsCell.h"
#import "EventsRangeCell.h"
#import "AgesCell.h"
#import "ShareVC.h"
#import "ReviewListVC.h"
#import "ChatViewController.h"
#import "AgeAndCredientialsCell.h"

#define PHOTO_PAGE_HEIGHT 200*TX_SCREEN_OFFSET
#define CHECK_AVAILABILITY_HEIGHT (60+30*iSiPhoneX)


@interface HBaseDetailVC ()<BHInfiniteScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ReviewsCellDelagete>

@property (strong, nonatomic)  UIImageView *coverImageView; 
@property (weak, nonatomic)  NSLayoutConstraint *detailImageUpCons;

@end

@implementation HBaseDetailVC
-(instancetype)init{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.fadeBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            
            [strongSelf.view layoutIfNeeded];
            
            strongSelf.detailImageUpCons.constant = 0;
            [UIView animateWithDuration:0.45 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf) return;
                strongSelf.tableView.alpha = 1;
                strongSelf.coverImageView.alpha = 0;
         //       [strongSelf.view layoutIfNeeded];
                
             //   [strongSelf reloadTableView];
                
            }completion:nil];
        };
    }
    return self;
}
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_WHITE];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)reloadTableView{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;  
    self.view.backgroundColor = [UIColor whiteColor];
    
    //reloadData避免视图漂移或者闪动
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    _favoriteBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"like-disabled"] 
                                                   style:UIBarButtonItemStyleDone 
                                                  target:self 
                                                  action:@selector(changFavoriteStatus:)];
    [_favoriteBtn setImage:self.isFavorite?[UIImage imageNamed:@"like-enabled"]:[UIImage imageNamed:@"like-disabled"]];
    
    NSArray *items = @[[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"inspect-share"] 
                                                       style:UIBarButtonItemStyleDone 
                                                      target:self 
                                                      action:@selector(shareAction:)],
                       _favoriteBtn
                       ];
    self.navigationItem.rightBarButtonItems = items;
     
    
    UINib *infoNib = [UINib nibWithNibName:@"HIteminfoCell" bundle:nil];
    [self.tableView registerNib:infoNib forCellReuseIdentifier:@"infocell"];
    
    
    UINib *joinlistNib = [UINib nibWithNibName:NSStringFromClass([HItemJoinListCell class]) bundle:nil];
    [self.tableView registerNib:joinlistNib forCellReuseIdentifier:@"HItemJoinListCell"];
    
    UINib *contactTitleNib = [UINib nibWithNibName:NSStringFromClass([ContactTitleCell class]) bundle:nil]; 
    [self.tableView registerNib:contactTitleNib forCellReuseIdentifier:@"ContactTitleCell"];
    
    
    UINib *reviewsCellNib = [UINib nibWithNibName:NSStringFromClass([ReviewsCell class]) bundle:nil]; 
    [self.tableView registerNib:reviewsCellNib forCellReuseIdentifier:@"ReviewsCell"];
    
    
    UINib *eventsRangeCellNib = [UINib nibWithNibName:NSStringFromClass([EventsRangeCell class]) bundle:nil]; 
    [self.tableView registerNib:eventsRangeCellNib forCellReuseIdentifier:@"EventsRangeCell"];
    
    
    UINib *agesCellNib = [UINib nibWithNibName:NSStringFromClass([AgesCell class]) bundle:nil]; 
    [self.tableView registerNib:agesCellNib forCellReuseIdentifier:@"AgesCell"];
    
    UINib *agesCellNib2 = [UINib nibWithNibName:NSStringFromClass([AgeAndCredientialsCell class]) bundle:nil]; 
    [self.tableView registerNib:agesCellNib2 forCellReuseIdentifier:@"AgeAndCredientialsCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
  //  self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    /*
     self.tableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
     self.tableView.rowHeight = UITableViewAutomaticDimension;
     */
 //   self.automaticallyAdjustsScrollViewInsets = YES;
    [self requestDetails];
    
    if (self.coverImage) {
         
        self.coverImageView.image = self.coverImage; 
        self.tableView.alpha = 0;
 //       self.detailImageUpCons.constant = 25;
        [self.view layoutIfNeeded];
        [self.tableView reloadData];
    }
    
    
}

- (UIImageView *)coverImageView{
    if (!_coverImageView) { 
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -5, TX_SCREEN_WIDTH, 274*TX_SCREEN_OFFSET-20)];
        _coverImageView.clipsToBounds = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_coverImageView];
    }
    return _coverImageView;
}


- (void)requestDetails{
    [self performSelector:@selector(addView:) withObject:nil afterDelay:0];
    
    //获取评论
    [ShareCareHttp GET:API_REVIEW_LIST withParaments:@[NSStringFromInt(self.roleType),((BaseModel *)_item).idValue] withSuccessBlock:^(id response) {
        response = response[@"content"];
        if ([response isKindOfClass:[NSArray class]]) {
            NSMutableArray *testArray = [NSMutableArray array];
            [testArray addObjectsFromArray:response]; 
            [testArray addObjectsFromArray:response]; 
            self.reviewDtoList = response; 
            [self.tableView reloadData];
        } 
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}


- (void)addView:(id)sender{
     
    __weak typeof(self) weakSelf = self; 
    self.checkAvailabilityView.checkAvailablityBlock = ^{
        [weakSelf checkAvailabilityClick:nil];
    };
    [self.view addSubview:self.checkAvailabilityView]; 
     
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-CHECK_AVAILABILITY_HEIGHT)];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //   _tableView.tableHeaderView = self.infinitePageView;
    //    _tableView.alpha = 0;
        
        if (IOS11) {   
            _tableView.frame =CGRectMake(0, -64, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-CHECK_AVAILABILITY_HEIGHT+64);
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}
- (CheckAvailabilityView *)checkAvailabilityView{
    if (!_checkAvailabilityView) { 
         
        _checkAvailabilityView = [[[NSBundle mainBundle]loadNibNamed:@"CheckAvailabilityView" owner:self options:nil]objectAtIndex:0]; 
        _checkAvailabilityView.frame = CGRectMake(0, TX_SCREEN_HEIGHT-CHECK_AVAILABILITY_HEIGHT, TX_SCREEN_WIDTH, CHECK_AVAILABILITY_HEIGHT);
    }
    return _checkAvailabilityView;
}
- (BHInfiniteScrollView *)infinitePageView{
    if (!_infinitePageView) {
        _infinitePageView = [[BHInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, PHOTO_PAGE_HEIGHT)]; 
        _infinitePageView.delegate =self;
    }
    return _infinitePageView;
}

- (ReportAlertView *)reportAlert{
    if (!_reportAlert) {
        _reportAlert = [[[NSBundle mainBundle]loadNibNamed:@"ReportAlertView" owner:self options:nil]objectAtIndex:0]; 
        _reportAlert.frame = self.view.frame;
    }
    return _reportAlert;
}

- (void)changFavoriteStatus:(id)sender{
 
}

- (void)shareAction:(id)sender{
    ShareVC *shareVC = [[ShareVC alloc] init];
    shareVC.shareTitle = self.headline;
    shareVC.imagePath = [[self photos] firstObject];
    [self.navigationController pushViewController:shareVC animated:YES];
}
#pragma mark -BHInfiniteScrollView
/** 点击图片*/
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

#pragma mark -ReviewsCellDelagete

- (void)reviewCellDidReport:(id)sender{
     
 //   __weak HBaseDetailVC *weakSelf = self; 
    [self.reportAlert showInView:[UIApplication sharedApplication].keyWindow selectedInappropriate:^{
        [self reportIndex:0 reviewId:sender];
    } dishonest:^{
        [self reportIndex:1 reviewId:sender];
    } fake:^{
        [self reportIndex:2 reviewId:sender];
    } cancel:^{
        
    }];
    
} 
- (void)reportIndex:(NSInteger)index reviewId:sender{
    [ShareCareHttp GET:@"/v1/review/report/" withParaments:@[[NSString stringWithFormat:@"%ld",index],sender] withSuccessBlock:^(id response) {
        [self showAlert];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)showAlert{
    UIAlertController *alertController = [UIAlertController 
                                          alertControllerWithTitle:@"Your Report has been sent to our service department."
                                          message:@"Thank you, we will get back to shortly." 
                                          preferredStyle:UIAlertControllerStyleAlert]; 
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CustomLocalizedString(@"OK", @"password") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
 

/*
 sections
 0---图片+基本信息
 1---sharecare 加入小孩的状态信息
 2---events 参加的人数限制
 3---情况说明
 4---babysittings Ages和Credientials说明
 5---contact 标题，如：‘Contact Host’  ‘Contact Babysitter’
 6---reviews list
 7---read more按钮

 */


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    return 8;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 370*TX_SCREEN_OFFSET;
            break;
        case 1:
            return 80*TX_SCREEN_OFFSET;
            break;
        case 2:
            return 90*TX_SCREEN_OFFSET;
            break;
        case 3:
            return [self getTextHeightWithString:[self testIntroduction]];
            break;
        case 4:
            return 284*TX_SCREEN_OFFSET+60-[self resetCredentialsCell:self.credentialsModel]*80;
            break;
        case 5:
            return 58*TX_SCREEN_OFFSET;
            break;
        case 6:
            return 85*TX_SCREEN_OFFSET;
            break; 
        case 7:
            return 44*TX_SCREEN_OFFSET;
            break;
        default:
            break;
    } 
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     
    if (indexPath.section == 0) {
        
        __weak typeof(self) weakSelf = self;
        HIteminfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infocell" forIndexPath:indexPath]; 
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *path in self.photos) {
            [array addObject:URLStringForPath(path)];
        }
        if (array.count) {
            [array replaceObjectAtIndex:0 withObject:URLStringForPath(self.thumbnail)];
        }
        cell.infinitePageView.imagesArray = array; 
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.lbTitle.text = [self headline]; 
        cell.lbTime.text = [self dateAndTime];
        cell.lbDesc.text = [self address];
        cell.lbType.text = [self typeString];
        [cell.imgPersonHeader setImageWithURL:[NSURL URLWithString:URLStringForPath(self.userIcon)] 
                             placeholderImage:kDEFAULT_HEAD_IMAGE];
        cell.selectedIndexBlock = ^(NSInteger index) {
            [weakSelf previewPhotosAtIndex:index];
        }; 
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 100)];
        tempImageView.hidden = YES;
        [cell addSubview:tempImageView];
      //  [tempImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(self.photos.firstObject)]];
        
        NSURL *url = [NSURL URLWithString:URLStringForPath(self.photos.firstObject)];
        [tempImageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:HOME_CELL_PLACEHOLDIMAGE success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            [array replaceObjectAtIndex:0 withObject:URLStringForPath(self.photos.firstObject)];
            cell.infinitePageView.imagesArray = array; 
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
        
        
        return cell;
    }else if (indexPath.section == 1) {
        HItemJoinListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HItemJoinListCell" forIndexPath:indexPath]; 
        [cell configMaxChild:[((ShareCareModel *)_item).childrenNums integerValue] 
               bookingChilds:self.childrens];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 2) {
        EventsRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventsRangeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        EventModel *model = (EventModel *)_item;
        cell.remainingPlace = model.remainingPlace;
        cell.maxAttendees = model.maximumAttendees;
        cell.ageRange = model.ageRange;
        return cell;
    }else if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = TX_FONT(13);
        cell.textLabel.textColor = COLOR_GRAY;  
        cell.textLabel.attributedText = [self aboutAttributedString];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 4) {
        AgeAndCredientialsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AgeAndCredientialsCell" forIndexPath:indexPath];
        cell.ageRange = [self ageRangeModel];
        cell.credentials = self.credentialsModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 5) {
        ContactTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactTitleCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.starView.scorePercent = self.totalStarRating;
        cell.delegate = self;
        
        if (self.reviewDtoList.count == 0 || self.roleType == UserRoleTypeEvent) {
            cell.lbReviews.hidden = YES;
            cell.starView.hidden = YES;
        }else{
            cell.lbReviews.hidden = NO;
            cell.starView.hidden = NO;
        }
        
        if (self.roleType == UserRoleTypeBabySitting) {
            cell.lbTitle.text = @"Contact Babysitter";
        }
        
        return cell;
    } else if (indexPath.section == 6) {
        ReviewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewsCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSDictionary *dic = self.reviewDtoList[indexPath.row];
        [cell configIcon:dic[@"userIcon"] 
                userName:dic[@"userName"] 
                    time:dic[@"createTime"] 
                 content:dic[@"experience"]];
        cell.reviewId = [NSString stringWithFormat:@"%@",dic[@"id"]];
        return cell;
    } else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath]; 
        cell.textLabel.font = TX_FONT(17);
        cell.textLabel.textColor = COLOR_BLUE;
        cell.textLabel.text = @"Read More";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 7) {
        ReviewListVC *reviews = [[ReviewListVC alloc] init];
        reviews.reviewDtoList = self.reviewDtoList;
        reviews.reviewType = NSStringFromInt(self.roleType);
        reviews.reviewTypeId = ((BaseModel *)_item).idValue;
        [self.navigationController pushViewController:reviews animated:YES];
    }
}

- (BOOL )resetCredentialsCell:(CredentialsModel *)credentials{ 
    NSMutableArray *array = [NSMutableArray array];
    if (credentials.nonsmoker) {
        [array addObject:@{@"icon":@"non-smoker-enabled",@"name":@"Non smoker"}];
    }
    if (credentials.drivers) {
        [array addObject:@{@"icon":@"drivers-license-enabled",@"name":@"Driver’s License"}];
    }
    if (credentials.havecar) {
        [array addObject:@{@"icon":@"has-car-enabled",@"name":@"Has Car"}];
    }
    if (credentials.cleaning) {
        [array addObject:@{@"icon":@"cleaning-enabled",@"name":@"Cleaning"}];
    }
    if (credentials.anphylaxis) {
        [array addObject:@{@"icon":@"anaphylaxis-enabled",@"name":@"Anaphylaxis"}];
    } 
    if (credentials.firstaid) {
        [array addObject:@{@"icon":@"firstaid-enabled",@"name":@"First Aid"}];
    }
    if (credentials.cooking) {
        [array addObject:@{@"icon":@"cooking-enabled",@"name":@"Cooking"}];
    }
    if (credentials.tutoring) {
        [array addObject:@{@"icon":@"tutoring-enabled",@"name":@"Tutor"}];
    }  
    return array.count<=4;
}


- (void)contactShareCarer{
    ChatViewController *detail = [[ChatViewController alloc] init];
    detail.hidesBottomBarWhenPushed = YES;
    detail.toUserName = self.userName;
    detail.toUser = self.accountId;
    detail.toUserIcon = self.userIcon;
    [self.navigationController pushViewController:detail animated:YES];
}
  
- (CGFloat)getTextHeightWithString:(NSString *)string{  
    CGRect rect = [string boundingRectWithSize:CGSizeMake(TX_SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:TX_FONT(13)} context:nil];  
    return  rect.size.height+20;  
}  

- (void)checkAvailabilityClick:(id)sender{ 
}
//[NSMutableArray arrayWithArray:[self testImages]]
- (void)previewPhotosAtIndex:(NSInteger)index{
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *path in self.photos) {
        [array addObject:URLStringForPath(path)];
    }
    if (array.count) {
        SKFPreViewNavController *imagePickerVc = [[SKFPreViewNavController alloc] initWithSelectedPhotoURLs:array 
                                                                                                      index:index ];
        
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
    
    
}


- (NSString *)testIntroduction{
   return [NSString stringWithFormat:@"\n%@",[self aboutAttributedString].string];
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
