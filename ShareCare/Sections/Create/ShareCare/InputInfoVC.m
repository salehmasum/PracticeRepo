//
//  InputInfoVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/10/16.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "InputInfoVC.h"

@interface InputInfoVC ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textViewPlaceholder;

@end

@implementation InputInfoVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.shadowImage = [UIImage new]; 
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  //  [self.textView becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
    saveButton.tintColor = COLOR_GRAY;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    self.lbContent.text = self.contentTitle;
    self.textView.text = self.content;
    self.textView.delegate = self;
    
    _textViewPlaceholder.text = [self placeHolderString];
    _textViewPlaceholder.hidden = self.textView.text.length;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView{
    _textViewPlaceholder.hidden = textView.text.length;
}
- (void)save:(id)sender{
    
    _inputBlock(self.textView.text); 
    [self.navigationController popViewControllerAnimated:NO];
}



- (NSString *)placeHolderString{
    
    switch (_careType) {
        case AboutContentTypeCreateShareCare:
            return [self createShareCareAbout];
            break;
        case AboutContentTypeCreateBabysitting:
            return [self createbabysittingAbout];
            break;
        case AboutContentTypeCreateEvent:
            return [self createEventAbout];
            break;
        case AboutContentTypeProfileShareCare:
            return [self shareCareProfileAboutMe];
            break;
        case AboutContentTypeProfileBabysitting:
            return [self babysittingProfileAboutMe];
            break;
        case AboutContentTypeProfileEvent:
            return [self eventProfileAboutMe];
            break;
            
        default:
            return @"";
            break;
    }
}
- (NSString *)createShareCareAbout{
    return @"We have a huge, clean house which is super child-friendly and fun to explore. \n\nAs a parent of little ones, we have ensured that entire property is safe, fun and friendly for your little ones.\n\nWe can’t wait to meet your kids and please let us know if you have any questions.  ";
}

- (NSString *)createbabysittingAbout{
    return @"";
}

- (NSString *)createEventAbout{
    return @"We're going on an adventure to the fabulous Werribee Zoo! It is only a short drive out of Melbourne's CBD.\n\nAs soon as we get there,I promise the kids well be in heaven.\n\nIt's an excellent place to explore as a group,beyond the animals there are so many different things to do and see.There's the hippo water play,sandpit,safari,ranger kids and much more.\n\nThere's of course so much more to see and do at the zoo.\n\nCan't wait to have you there with us!";
}


- (NSString *)shareCareProfileAboutMe{
    return @"I have 2 children of my own, ranging from 4 - 12 years of age. I am relaxed,creative, have a great sense of humour,loads ofenergy & believe positivity is the key to happy kids - being interested & active in their world is very important.\n\nOur family has recently relocated to Prahan and would really love to open my home to other children in the same age bracket as my children. I really look forward to hearing from any families within 30 mins from Prahan & you can rest assured your that children will be provided with a very high level of care & kindness.\n\nKind regards,\nSarah";
}
- (NSString *)babysittingProfileAboutMe{
    return @"I am a healthy 27-year-old male who is returning to study Osteopathy.Currently, I am a Nurse, working in mental health. My usual daytime shift work is no longer feasible, due to time constraints with studies, I am looking at alternative ways of supplying my fridge with food. \n\nI grew up in a family of 6 kids so am very comfortable with looking after other people’s kids as a result.\n\nI’m available after 5 pm on Wednesday  evenings and some weekend evenings too.\n\nI’ve got my police check, first aid and working with children check. ";
}
- (NSString *)eventProfileAboutMe{
    return @"";
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
