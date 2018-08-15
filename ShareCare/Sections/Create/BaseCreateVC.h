//
//  BaseCreateVC.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbnailCell.h"
#import "UIViewController+KeyboardState.h"

#import "UIViewController+XHPhoto.h"

//#define MAX_REQUEST_COUNT 15

@interface BaseCreateVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate,UITextFieldDelegate>{
}

@property(strong, nonatomic) NSMutableArray *photos;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) BHInfiniteScrollView *photoView;
@property (strong, nonatomic) UICollectionView *thumbnailCollectionView;
@property (strong, nonatomic) UILabel *warninglabel;



@property(assign, nonatomic) SourceType  sourceType;
@property(strong, nonatomic) NSString *  actionsheetTitle;
//TEST

@property(assign, nonatomic) NSInteger requestIndex;
- (void)save:(id)sender;
- (void)submissionSuccessful;
 
@end
