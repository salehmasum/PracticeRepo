//
//  BookingReviewVC.m
//  ShareCare
//
//  Created by 朱明 on 2017/11/27.
//  Copyright © 2017年 Alvis. All rights reserved.
//

#import "BookingReviewVC.h"
#import "CWStarRateView.h"
#import "BHInfiniteScrollView.h"
#import "UIViewController+KeyboardState.h"

#define MAX_LIMIT_NUMS 500

@interface BookingReviewVC ()<BHInfiniteScrollViewDelegate,UITextViewDelegate>{
    
    IBOutletCollection(UIButton) NSArray *btnStars;
    
    NSInteger _score;
}


@property (strong, nonatomic) BHInfiniteScrollView *infinitePageView;
@property (strong, nonatomic) UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbCareType;
@property (weak, nonatomic) IBOutlet UILabel *lbUserName;



@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITextView *tvExperience;
@property (weak, nonatomic) IBOutlet UITextView *tvFeedback;
@property (weak, nonatomic) IBOutlet CWStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *lbExperienceCount;
@property (weak, nonatomic) IBOutlet UILabel *lbFeedbackCount;

@end

@implementation BookingReviewVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated]; 
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setTintColor:COLOR_BACK_BLUE]; 
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:1]];
    self.navigationController.navigationBar.shadowImage = [UIImage new]; 
}
- (BHInfiniteScrollView *)infinitePageView{
    if (_infinitePageView == nil) {
        _infinitePageView = [[BHInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 60*TX_SCREEN_OFFSET, TX_SCREEN_WIDTH, 188*TX_SCREEN_OFFSET)];
    }
    return _infinitePageView;
}
- (UIImageView *)userHeaderImageView{
    if (!_userHeaderImageView) {
        _userHeaderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TX_SCREEN_WIDTH-76*TX_SCREEN_OFFSET-20, ((60+188)*TX_SCREEN_OFFSET)-38*TX_SCREEN_OFFSET, 76*TX_SCREEN_OFFSET, 76*TX_SCREEN_OFFSET)];
        _userHeaderImageView.layer.masksToBounds = YES;
        _userHeaderImageView.layer.cornerRadius = CGRectGetWidth(self.userHeaderImageView.frame)/2.0;
        _userHeaderImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _userHeaderImageView.layer.borderWidth = 2;
        _userHeaderImageView.contentMode = UIViewContentModeScaleAspectFill;
        _userHeaderImageView.clipsToBounds = YES;
    }
    return _userHeaderImageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.headerView.frame = CGRectMake(0, 0, TX_SCREEN_WIDTH, 320*TX_SCREEN_OFFSET);
    
    [_headerView addSubview:self.infinitePageView];
    [_headerView addSubview:self.userHeaderImageView];
    
  //  [self setKeyboardNotificationWith:self.tableView];
    
    self.infinitePageView.placeholderImage = kDEFAULT_IMAGE;
    self.infinitePageView.delegate = self; 
    
    _starRateView.allowIncompleteStar = YES;
    _starRateView.scorePercent = 0.8;
    
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  //  self.tableView.allowsSelection = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"booking"];
    
    
  //  _booking.times = [_booking.whoIsComings.firstObject[@"timePeriod"] componentsSeparatedByString:@"|"];
    
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [self.headerView addGestureRecognizer:tapGesture1];
    [tapGesture1 setNumberOfTapsRequired:1];
    
    
    UITapGestureRecognizer * tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    [self.footerView addGestureRecognizer:tapGesture2];
    [tapGesture2 setNumberOfTapsRequired:1];
    
    _score = 1;
    
    [self requestBookingDetail];
     
}

- (void)requestBookingDetail{
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    
    __weak typeof(self) weakSelf = self;
    [ShareCareHttp GET:API_BOOKING_DETAIL withParaments:@[_bookingId] withSuccessBlock:^(id response) {
        
        weakSelf.booking = [BookingModel modelWithDictionary:response]; 
        
        [weakSelf updateUI];
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}

- (void)updateUI{
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    NSMutableArray *imgs = [NSMutableArray array];
    for (id path in _booking.shareIcon) {
        [imgs addObject:URLStringForPath(path)];
    }
    
    self.infinitePageView.imagesArray = imgs;// • 
    _lbCareType.text = [NSString stringWithFormat:@"%@ %@",_booking.careType.integerValue==0?@"EleCare":(_booking.careType.integerValue==1?@"Babysitting":@"Events"),@""];
    _lbUserName.text = [NSString stringWithFormat:@"Hosted by %@",_booking.pubUserName];
    [self.userHeaderImageView setImageWithURL:[NSURL URLWithString:URLStringForPath(_booking.pubUserIcon)] 
                             placeholderImage:kDEFAULT_HEAD_IMAGE];
    
    if (_booking.whoIsComings.count) {
        NSString *timePeriod = _booking.whoIsComings.firstObject[@"timePeriod"];
        if ([timePeriod containsString:@"T"]) {
            _booking.times = [timePeriod componentsSeparatedByString:@"|"];
        }else{
            _booking.times = @[[NSString stringWithFormat:@"%@ - %@",_booking.startDate,_booking.endDate]];
        }
    }
    [self.tableView reloadData];
}
- (IBAction)starRating:(UIButton *)sender {
    for (UIButton *button in btnStars) {
        if (button.tag<=sender.tag) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    
    _score = sender.tag;
}


#pragma mark 执行触发的方法

- (void)event:(UITapGestureRecognizer *)gesture{
[[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static int count=0;
- (IBAction)submit:(id)sender {
 
    //  if(count<10){
    NSString *experience = _tvExperience.text;
    //    experience = [experience substringFromIndex:arc4random()%experience.length];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [SVProgressHUD showWithStatus:TEXT_LOADING];
    NSDictionary *dic = @{@"babySittingId"  : _booking.careType.integerValue==1?_booking.typeId:@"",
                          @"eventId"        : _booking.careType.integerValue==2?_booking.typeId:@"",
                          @"experience"     : experience,
                          @"privateFeedback": _tvFeedback.text,
                          @"reviewType"     : _booking.careType,
                          @"shareCareId"    : _booking.careType.integerValue==0?_booking.typeId:@"",
                          @"starRating"     : [NSString stringWithFormat:@"%ld",_score]
                          };//_starRateView.scorePercent*StarRatingScale
    [ShareCareHttp POST:API_REVIEW_ADD withParaments:dic withSuccessBlock:^(id response) {
        // if(count==9)
        [self.navigationController popViewControllerAnimated:YES];
        if (_delegate) {
            [_delegate addReviewWith:self.booking];
        }
        [SVProgressHUD dismiss];
    } withFailureBlock:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }]; 
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    CGRect rect = [textView convertRect:textView.bounds toView:self.tableView];
    NSLog(@"%f",rect.origin.y);
    [self.tableView scrollRectToVisible:rect animated:YES];
}
 
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range  
 replacementText:(NSString *)text  
{
    if ([text isEqualToString:@"\n"]){ 
        [textView resignFirstResponder];
        return NO;  
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];  
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;  
    
    if (caninputlen >= 0)  
    {  
        return YES;  
    }  
    else  
    {  
        NSInteger len = text.length + caninputlen;  
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错  
        NSRange rg = {0,MAX(len,0)};  
        
        if (rg.length > 0)  
        {  
            NSString *s = [text substringWithRange:rg];  
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];  
            
            
            if (textView.tag) {
                self.lbFeedbackCount.text = [NSString stringWithFormat:@"%ld words left",MAX(0,MAX_LIMIT_NUMS - textView.text.length)]; 
            }else{
                _btnSubmit.enabled = textView.text.length;
                self.lbExperienceCount.text = [NSString stringWithFormat:@"%ld words left",MAX(0,MAX_LIMIT_NUMS - textView.text.length)]; 
            }
            
        }  
        return NO;  
    }  
    
}  

- (void)textViewDidChange:(UITextView *)textView  
{  
    NSString  *nsTextContent = textView.text;  
    NSInteger existTextNum = nsTextContent.length;  
    
    if (existTextNum > MAX_LIMIT_NUMS)  
    {  
        //截取到最大位置的字符  
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];  
        
        [textView setText:s];  
    }  
    
    if (textView.tag) {
        self.lbFeedbackCount.text = [NSString stringWithFormat:@"%ld words left",MAX(0,MAX_LIMIT_NUMS - existTextNum)]; 
        
    }else{
        _btnSubmit.enabled = textView.text.length;
        self.lbExperienceCount.text = [NSString stringWithFormat:@"%ld words left",MAX(0,MAX_LIMIT_NUMS - existTextNum)]; 
    }
    //不让显示负数   
    
}  




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _booking.times.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"booking" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    cell.textLabel.textColor = TX_RGB(90, 90, 90);
    cell.textLabel.font = TX_FONT(15);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = @"20 May 2017 • 11:00am - 2:00pm";
    
    NSString *string = _booking.times[indexPath.row];
    string = [string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    
    cell.textLabel.text = [self configStartDate:[string componentsSeparatedByString:@" - "][0] endDate:[string componentsSeparatedByString:@" - "][1]];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}
- (NSString *)configStartDate:(NSString *)start endDate:(NSString *)end{
    
    
    NSDateFormatter *dateFormatter = [Util dateFormatter] ;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [dateFormatter dateFromString:start];
    NSDate *endDate = [dateFormatter dateFromString:end];
    
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *startTime = [dateFormatter stringFromDate:startDate];
    NSString *endTime = [dateFormatter stringFromDate:endDate];
    
    
    startTime = [startTime stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
    startTime = [startTime stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    endTime = [endTime stringByReplacingOccurrencesOfString:@" PM" withString:@"pm"];
    endTime = [endTime stringByReplacingOccurrencesOfString:@" AM" withString:@"am"];
    
    
    
    NSString *timeStr = [NSString stringWithFormat:@"%@ - %@",startTime,endTime];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *dateStr = [dateFormatter stringFromDate:startDate];
    
    return [NSString stringWithFormat:@"%@ • %@",dateStr,timeStr];
}                          
                           


@end
