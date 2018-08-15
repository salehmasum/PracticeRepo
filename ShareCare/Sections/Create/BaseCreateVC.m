//
//  BaseCreateVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BaseCreateVC.h" 
//#import <ZLPhotoBrowser/ZLPhotoBrowser.h>
#import "SKFPreViewNavController.h"
#import "UIViewController+Alert.h"
#import "CreateSuccessfulAlertVC.h"
#import "BasePolicyVC.h"
@interface BaseCreateVC ()<BHInfiniteScrollViewDelegate>{
    CreateSuccessfulAlertVC *_alertVC;
    BOOL _submissionSuccessful;
    UIAlertController *alertController;
}


@end
//https://github.com/netyouli/WHC_PhotoCameraChoicePictureDemo
@implementation BaseCreateVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"line"]; 
    
    if (_submissionSuccessful) {
       // [self.navigationController popViewControllerAnimated:YES];
        [self presentViewController:alertController animated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_submissionSuccessful) {
       
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"create"];
    [self.view addSubview:self.tableView];
    if(!IOS11) self.edgesForExtendedLayout=UIRectEdgeNone;
    [self setKeyboardNotificationWith:self.tableView];
    
    self.photos= [NSMutableArray array];
#ifdef DEBUG 
     UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveTest:)];
#else 
     UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(showAlertBeforeSave:)];
#endif
   
    saveButton.tintColor = COLOR_GRAY;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    _requestIndex = 0;
}
- (void)save11:(id)sender{
    [self submissionSuccessful];
}
- (void)showAlertBeforeSave:(id)sender{
    alertController = [UIAlertController 
                       alertControllerWithTitle:@"Save your listing?" 
                       message:@"Please make sure all your information is correct! You will not be able to make changes later."
                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Continue Editing" 
                                                           style:UIAlertActionStyleDefault 
                                                         handler:^(UIAlertAction * _Nonnull action) { 
                                                         }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save Listing" 
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction * _Nonnull action) { 
                                                           [self save:nil];
                                                       }];
    [alertController addAction:saveAction];
    [self presentViewController:alertController animated:YES completion:^{ 
    }];
}
- (void)submissionSuccessful{ 
    _submissionSuccessful = YES;
    
    [SVProgressHUD dismiss];   
    NSString *message = @"As per Terms and Conditions, we will be reviewing your identification. If you are then verified you will be registered as an official EleCare Babysitter and make your profile available to Parents.";
    
     alertController = [UIAlertController 
                                          alertControllerWithTitle:@"Submission Successful" 
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" 
                                                           style:UIAlertActionStyleCancel 
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                         }];
    [alertController addAction:cancelAction];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    
    NSDictionary *attributes = @{NSFontAttributeName:TX_FONT(15),
                                 NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:message 
                                                                                    attributes:attributes];
    
    NSString *conditionsStr = @"Terms and Conditions";
    NSRange range = [message rangeOfString:conditionsStr];
    [messageText addAttribute:NSUnderlineStyleAttributeName 
                        value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] 
                        range:range]; // 下划线类型  
//    [messageText addAttribute:NSUnderlineColorAttributeName 
//                        value:[UIColor blueColor] 
//                        range:range]; // 下划线颜色  
     
    [messageText addAttribute:NSLinkAttributeName 
                    value:@"onButton://terms" 
                    range:range];
     
    [alertController setValue:messageText forKey:@"attributedMessage"];
    
    [alertController.view addSubview:[self createButton]]; 
    [self presentViewController:alertController animated:YES completion:^{
         [self.navigationController popViewControllerAnimated:YES];
    }];
     
    
}
- (void)conditions:(id)sender{
    [alertController dismissViewControllerAnimated:YES completion:nil];
    BasePolicyVC *viewController = [[BasePolicyVC alloc] init];
    viewController.content = CONTENT_TERMS_AND_CONDITINONS; 
    viewController.subject = @"Terms and Conditions";
    [self.navigationController pushViewController:viewController animated:YES];
    [self performSelector:@selector(resetNavgationViewController) withObject:nil afterDelay:1];
     
}
- (UIButton *)createButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, 40, 200, 40);
    [button addTarget:self action:@selector(conditions:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)resetNavgationViewController{
    UINavigationController *navigationVC = self.navigationController;
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    //    遍历导航控制器中的控制器
    for (UIViewController *vc in navigationVC.viewControllers) { 
        if (![vc isKindOfClass:[self class]]) {
           [viewControllers addObject:vc];
        }
    }
    //    把控制器重新添加到导航控制器
    [navigationVC setViewControllers:viewControllers animated:YES];
    
}
 
- (UITableView *)tableView{
    if (!_tableView) {  
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, TX_SCREEN_HEIGHT-SYSTEM_NAVIGATIONBAR_HEIGHT*(!IOS11))];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
    
}

- (UIView *)headerView{
    if (!_headerView) {  
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 240*TX_SCREEN_OFFSET)];
         
        [_headerView addSubview:self.photoView];
        [_headerView addSubview:self.thumbnailCollectionView];
        
        _warninglabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 46)];
        _warninglabel.textColor = [UIColor whiteColor];
        _warninglabel.font =TX_FONT(16);
        _warninglabel.textAlignment = NSTextAlignmentCenter;
        [_headerView addSubview:_warninglabel];
        
        UIButton *cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 46)];
        [cameraBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
        [_headerView addSubview:cameraBtn];
        [cameraBtn addTarget:self action:@selector(takeOrChoosePhoto:) forControlEvents:UIControlEventTouchUpInside];
        cameraBtn.center = CGPointMake(TX_SCREEN_WIDTH-30, CGRectGetMaxY(self.photoView.frame)-23);
        
        _warninglabel.center = CGPointMake(_warninglabel.center.x, cameraBtn.center.y);
    }
    return _headerView;
    
}
- (BHInfiniteScrollView *)photoView{
    if (!_photoView) {  
        _photoView = [BHInfiniteScrollView infiniteScrollViewWithFrame:CGRectMake(0, 0, TX_SCREEN_WIDTH, 188*TX_SCREEN_OFFSET) Delegate:self ImagesArray:@[kDEFAULT_IMAGE] PlageHolderImage:kDEFAULT_IMAGE];
//        _photoView.imagesArray = @[kDEFAULT_IMAGE];
//        _photoView.delegate = self;
    }
    return _photoView;
    
}
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index{
    if (self.photos.count) { 
        __weak typeof(self) weakSelf = self;
        NSMutableArray *photos = [NSMutableArray arrayWithArray:self.photos];
        SKFPreViewNavController *imagePickerVc = [[SKFPreViewNavController alloc] initWithSelectedPhotos:photos 
                                                                                                   index:index 
                                                                                               DeletePic:YES];
        
        [imagePickerVc setDidFinishDeletePic:^(NSArray<UIImage *> *photos) { 
                    [weakSelf.photos removeAllObjects];
            
                    [weakSelf.photos addObjectsFromArray:photos];
            weakSelf.photoView.imagesArray = weakSelf.photos.count?weakSelf.photos:@[kDEFAULT_IMAGE];
            [weakSelf.thumbnailCollectionView reloadData];
            
            weakSelf.warninglabel.hidden = weakSelf.photos.count;
            
        }]; 
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger)index{
   
}

- (UICollectionView *)thumbnailCollectionView{
    if (!_thumbnailCollectionView) {  
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(88*TX_SCREEN_OFFSET, 44*TX_SCREEN_OFFSET); 
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 5 ;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _thumbnailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 194*TX_SCREEN_OFFSET, TX_SCREEN_WIDTH, 44*TX_SCREEN_OFFSET) collectionViewLayout:layout];
        
        [_thumbnailCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ThumbnailCell class]) bundle:nil] forCellWithReuseIdentifier:@"ThumbnailCell"];
        
        
        
        _thumbnailCollectionView.backgroundColor = [UIColor whiteColor];
        _thumbnailCollectionView.showsHorizontalScrollIndicator = NO;
        _thumbnailCollectionView.showsVerticalScrollIndicator = NO;
        
        _thumbnailCollectionView.dataSource = self;
        _thumbnailCollectionView.delegate = self;
      //  _thumbnailCollectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 0);
    }
    return _thumbnailCollectionView;
    
}

- (void)takeOrChoosePhoto:(id)sender{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES]; 
    
    if (self.photos.count < kMAX_SELECTED_PHOTOS) {
        
        __block typeof(self) weakeSelf = self;
//        [self showCanEdit:NO photo:^(UIImage *photo) {
//            
//        }];
        
        
        
        [self showPhotoSourceType:self.sourceType alerttitle:self.actionsheetTitle photo:^(UIImage *photo) {
            [weakeSelf.photos  addObject:photo];
            [weakeSelf.thumbnailCollectionView reloadData];
            weakeSelf.photoView.imagesArray = weakeSelf.photos;
            
            weakeSelf.warninglabel.hidden = weakeSelf.photos.count;
        }];
    }
} 

#pragma mark --------------------------------------------------
#pragma mark UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ThumbnailCell" forIndexPath:indexPath];
    [cell.imageView setImage:self.photos[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.photoView scrollToPageAtIndex:indexPath.row Animation:NO];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark --------------------------------------------------
#pragma mark UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"create" forIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}


#pragma mark --------------------------------------------------
#pragma mark UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
