//
//  NewChildrenCell.h
//  ShareCare
//
//  Created by 朱明 on 2017/10/24.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^NewChildrenCellEditNameBlock)(void);
typedef void(^NewChildrenCellEditAgeBlock)(void);
typedef void(^NewChildrenCellEditGenderBlock)(void);
typedef void(^NewChildrenCellEditEmergencyContactBlock)(void);

@interface NewChildrenCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAge;
@property (weak, nonatomic) IBOutlet UILabel *lbGender;
@property (weak, nonatomic) IBOutlet UILabel *lbPhone;
@property (weak, nonatomic) IBOutlet UILabel *lbRelationship;


@property (strong, nonatomic) NewChildrenCellEditNameBlock   editNameBlock;
@property (strong, nonatomic) NewChildrenCellEditAgeBlock    editAgeBlock;
@property (strong, nonatomic) NewChildrenCellEditGenderBlock editGenderBlock;
@property (strong, nonatomic) NewChildrenCellEditEmergencyContactBlock editPhoneBlock;

- (IBAction)editName:(id)sender;
- (IBAction)editAge:(id)sender;
- (IBAction)editGender:(id)sender;

@end
