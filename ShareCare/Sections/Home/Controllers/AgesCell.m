//
//  AgesCell.m
//  ShareCare
//
//  Created by 朱明 on 2017/9/26.
//  Copyright © 2017年 Alvis. All rights reserved.
//


#import "AgesCell.h"

@interface AgesCell()
@property (weak, nonatomic) IBOutlet UIImageView *img012month;
@property (weak, nonatomic) IBOutlet UIImageView *img1_2years;
@property (weak, nonatomic) IBOutlet UIImageView *img2_3years;
@property (weak, nonatomic) IBOutlet UIImageView *img3_5years;
@property (weak, nonatomic) IBOutlet UIImageView *img5_years;

@property (weak, nonatomic) IBOutlet UILabel *lb0_12months;
@property (weak, nonatomic) IBOutlet UILabel *lb1_2years;
@property (weak, nonatomic) IBOutlet UILabel *lb2_3years;
@property (weak, nonatomic) IBOutlet UILabel *lb3_5years;
@property (weak, nonatomic) IBOutlet UILabel *lb5_years;


@property (weak, nonatomic) IBOutlet UIImageView *imgSmoking;
@property (weak, nonatomic) IBOutlet UIImageView *imgDriverLicense;
@property (weak, nonatomic) IBOutlet UIImageView *imgHasCar;
@property (weak, nonatomic) IBOutlet UIImageView *imgCleaning;
@property (weak, nonatomic) IBOutlet UIImageView *imgAnaphylaxis;
@property (weak, nonatomic) IBOutlet UIImageView *imgFirstAid;
@property (weak, nonatomic) IBOutlet UIImageView *imgCooking;
@property (weak, nonatomic) IBOutlet UIImageView *imgTutoring;

@property (weak, nonatomic) IBOutlet UILabel *lbSmoking;
@property (weak, nonatomic) IBOutlet UILabel *lbDriverLicense;
@property (weak, nonatomic) IBOutlet UILabel *lbHasCar;
@property (weak, nonatomic) IBOutlet UILabel *lbCleaning;
@property (weak, nonatomic) IBOutlet UILabel *lbAnaphylaxis;
@property (weak, nonatomic) IBOutlet UILabel *lbFirstAid;
@property (weak, nonatomic) IBOutlet UILabel *lbCooking;
@property (weak, nonatomic) IBOutlet UILabel *lbTutoring;

@end

@implementation AgesCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAgeRange:(AgeRangeModel *)ageRange{
    _ageRange = ageRange;
    self.img012month.highlighted = ageRange.age0_1;
    self.img1_2years.highlighted = ageRange.age1_2;
    self.img2_3years.highlighted = ageRange.age2_3;
    self.img3_5years.highlighted = ageRange.age3_5;
    self.img5_years.highlighted  = ageRange.age5;
    
    self.lb0_12months.highlighted = ageRange.age0_1;
    self.lb1_2years.highlighted   = ageRange.age1_2;
    self.lb2_3years.highlighted   = ageRange.age2_3;
    self.lb3_5years.highlighted   = ageRange.age3_5;
    self.lb5_years.highlighted    = ageRange.age5;
     
}

- (void)setCredentials:(CredentialsModel *)credentials{
    _credentials = credentials;
    self.imgSmoking.highlighted       = credentials.nonsmoker;
     self.imgDriverLicense.highlighted = credentials.drivers;
     self.imgHasCar.highlighted        = credentials.havecar;
     self.imgCleaning.highlighted      = credentials.cleaning;
     self.imgAnaphylaxis.highlighted   = credentials.anphylaxis;
     self.imgFirstAid.highlighted      = credentials.firstaid;
     self.imgCooking.highlighted       = credentials.cooking;
    self.imgTutoring.highlighted       = credentials.tutoring;
     
     self.lbSmoking.highlighted        = credentials.nonsmoker;
     self.lbDriverLicense.highlighted  = credentials.drivers;
     self.lbHasCar.highlighted         = credentials.havecar;
     self.lbCleaning.highlighted       = credentials.cleaning;
     self.lbAnaphylaxis.highlighted    = credentials.anphylaxis;
     self.lbFirstAid.highlighted       = credentials.firstaid;
     self.lbCooking.highlighted        = credentials.cooking;
    self.lbTutoring.highlighted        = credentials.tutoring;
     
}

@end
    
    

