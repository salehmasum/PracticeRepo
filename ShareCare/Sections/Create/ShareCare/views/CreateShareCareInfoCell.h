//
//  CreateShareCareInfoCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/13.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgeRangeModel.h"
#import "CredentialsModel.h"

typedef void(^CreateShareCareEditAboutBlock)(void);
typedef void(^CreateShareCareAddressBlock)(NSString *text);
typedef void(^CreateShareCareAddressEditStateBlock)(BOOL begin);
@interface CreateShareCareInfoCell : UITableViewCell<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *tfHeadline;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (assign, nonatomic)  NSInteger childrens;
@property (assign, nonatomic)  double lat;
@property (assign, nonatomic)  double lon;
@property (weak, nonatomic) IBOutlet UILabel *lbAbout;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *checkBtns;
@property (weak, nonatomic) IBOutlet UITextField *tfPerday;
@property (weak, nonatomic) IBOutlet UITextField *tfPhotoCount;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSArray *dataSource;


@property (strong, nonatomic) CreateShareCareEditAboutBlock editAboutBlock;
@property (strong, nonatomic) CreateShareCareAddressBlock addressBlock;
@property (strong, nonatomic) CreateShareCareAddressEditStateBlock addressEditStateBlock;

@property (strong, nonatomic) NSMutableDictionary *ages;
@property (strong, nonatomic) NSMutableDictionary *credentials; 
@property (strong, nonatomic) AgeRangeModel *ageRangeModel;
@property (strong, nonatomic) CredentialsModel *credentialsModel;
@end
