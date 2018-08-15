//
//  CreateBabysittingCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgeRangeModel.h"
#import "CredentialsModel.h"
#import "BabysittingModel.h"

typedef void(^CreatebabysittingEditAboutBlock)(void);
@interface CreateBabysittingCell : UITableViewCell<UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnAges;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnCredentials;
@property (weak, nonatomic) IBOutlet UITextField *tfHeadline;
@property (weak, nonatomic) IBOutlet UILabel *lbAbout;

@property (weak, nonatomic) IBOutlet UITextField *tfPerday;
@property (weak, nonatomic) IBOutlet UITextField *tfPhotoCount;

@property (strong, nonatomic) NSMutableDictionary *ages;
@property (strong, nonatomic) NSMutableDictionary *credentials;


@property (strong, nonatomic) CreatebabysittingEditAboutBlock editAboutBlock;
@property (strong, nonatomic) AgeRangeModel *ageRangeModel;
@property (strong, nonatomic) CredentialsModel *credentialsModel;
@property (strong, nonatomic) BabysittingModel *babysittingModel;

@end
