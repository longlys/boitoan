//
//  DALibViewController.m
//  DemoAds
//
//  Created by LongLy on 02/07/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "DALibViewController.h"
@import GoogleMobileAds;

@interface DALibViewController ()<UITextFieldDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate, GADInterstitialDelegate, GADBannerViewDelegate>
{
    UIDatePicker *datePicker;
}
@property(nonatomic)NSDictionary *dicdatanumberPhone;
@property(nonatomic)NSDictionary *dicdata;
@property(nonatomic)NSDictionary *dicdatachitay;
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextView *lbKetQua;
@property (weak, nonatomic) IBOutlet UITextField *numberPhoneTextfield;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIButton *btnTitle;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property(nonatomic, weak) IBOutlet GADBannerView *bannerView;
@property (nonatomic)GADInterstitial *interstitial;

@end

@implementation DALibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Bói Số Điện Thoại và Tên";
    self.dicdata = [NSDictionary new];
    self.dicdatachitay = [NSDictionary new];
    [self loadfiledata];
    
    [self.numberView setHidden:YES];
    [self.nameView setHidden:YES];
    [self.btnTitle setTitle:@"Chọn Loại Bói" forState:UIControlStateNormal];
    [self.btnTitle setBackgroundImage:[UIImage imageNamed:@"bg_button_dis"] forState:UIControlStateNormal];
    self.textField.delegate = self;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    NSLocale* currentLocale = [NSLocale currentLocale];
    [[NSDate date] descriptionWithLocale:currentLocale];
    NSString *maxDateString = [[NSDate date] descriptionWithLocale:currentLocale];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MMM-yyyy";
    
    NSDate *theMaximumDate = [dateFormatter dateFromString: maxDateString];
    NSDate *theMinimumDate = [dateFormatter dateFromString: maxDateString];
    [datePicker setMaximumDate:theMaximumDate]; //the min age restriction
    [datePicker setMinimumDate:theMinimumDate]; //the max age restriction (if needed, or else dont use this line)
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.textField setInputView:datePicker];
    self.interstitial = [self createAndLoadInterstitial];
    self.interstitial.delegate = self;
    
    //banner
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = kXBBanner;
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
}


-(void)showInterstitial {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
    self.interstitial = [self createAndLoadInterstitial];
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:kXBinterstitial];
    GADRequest *request = [GADRequest request];
    [interstitial loadRequest:request];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateTextField:(id)sender {
    UIDatePicker *picker = (UIDatePicker*)self.textField.inputView;
    self.textField.text = [self formatDate:picker.date];
}
- (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}
-(void)loadfiledata{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"boitoanso" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.dicdata = dic;
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"boitoansodt" ofType:@"json"];
    NSData *data2 = [NSData dataWithContentsOfFile:path2];
    NSDictionary *dic2 = [NSJSONSerialization JSONObjectWithData:data2 options:kNilOptions error:nil];
    self.dicdatanumberPhone = dic2;
    
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"datachitay" ofType:@"json"];
    NSData *data3 = [NSData dataWithContentsOfFile:path3];
    NSDictionary *dic3 = [NSJSONSerialization JSONObjectWithData:data3 options:kNilOptions error:nil];
    self.dicdatachitay = dic3;
}
- (IBAction)kqnumberPhone:(id)sender {
    if (self.numberPhoneTextfield.text.length == 0) {
        self.lbKetQua.text = @"Bạn phải nhập số điện thoại trước khi xem kết quả!!!";
    } else {
        [self.view endEditing:YES];
        [self showInterstitial];
        [self tinhSo];
    }
}

- (IBAction)xemkq:(id)sender {
    NSString *name = self.nameTextfield.text;
    if (name.length == 0) {
        self.lbKetQua.text = @"Bạn phải nhập Họ Tên trước!!!";
    } else {
        [self showInterstitial];
        [self thuattoan:name];
    }
}

-(void)thuattoan:(NSString *)name{
    int k = 0;
    NSArray *letterArray = [NSArray array];
    letterArray = [self covertStringToArray:name];
    for (NSString *i in letterArray){
        int n = [self getValueForchart:[i uppercaseString]];
        k = k + n;
    }
    NSString *names = [NSString stringWithFormat:@"%d",k];
    NSString *kq = [self sumX:names];
    [self setUpketqua:kq];
}
-(NSString *)sumX:(NSString*)number{
    NSInteger m = 0;
    if (number.length > 1) {
        NSArray *numberArray = [NSArray array];
        numberArray = [self covertStringToArray:number];
        for (NSString *i in numberArray){
            m = m + [i integerValue];
        }
    } else {
        return number;
    }
    if ([NSString stringWithFormat:@"%ld", (long)m].length == 1) {
        return [NSString stringWithFormat:@"%ld", (long)m];
    } else {
        return [self sumX:[NSString stringWithFormat:@"%ld", (long)m]];
    }
    return nil;
}

-(NSArray*)covertStringToArray:(NSString *)letter{
    NSMutableArray *letterArray = [NSMutableArray array];
    [letter enumerateSubstringsInRange:NSMakeRange(0, [letter length])
                               options:(NSStringEnumerationByComposedCharacterSequences)
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [letterArray addObject:substring];
                            }];
    return letterArray;
}

-(int)getValueForchart:(NSString *)charts{
    int k = 0;
    if ([charts isEqualToString:@"A"] || [charts isEqualToString:@"J"] || [charts isEqualToString:@"S"]) {
        k = 1;
    } else if ([charts isEqualToString:@"B"] || [charts isEqualToString:@"K"] || [charts isEqualToString:@"T"]) {
        k = 2;
    } else if ([charts isEqualToString:@"C"] || [charts isEqualToString:@"L"] || [charts isEqualToString:@"U"]) {
        k = 3;
    } else if ([charts isEqualToString:@"D"] || [charts isEqualToString:@"M"] || [charts isEqualToString:@"V"]) {
        k = 4;
    } else if ([charts isEqualToString:@"E"] || [charts isEqualToString:@"N"] || [charts isEqualToString:@"W"]) {
        k = 5;
    } else if ([charts isEqualToString:@"F"] || [charts isEqualToString:@"O"] || [charts isEqualToString:@"X"]) {
        k = 6;
    } else if ([charts isEqualToString:@"G"] || [charts isEqualToString:@"P"] || [charts isEqualToString:@"Y"]) {
        k = 7;
    } else if ([charts isEqualToString:@"H"] || [charts isEqualToString:@"Q"] || [charts isEqualToString:@"Z"]) {
        k = 8;
    } else if ([charts isEqualToString:@"I"] || [charts isEqualToString:@"R"]) {
        k = 9;
    } else {
        k = 0;
    }
    return k;
}

-(void)setUpketqua:(NSString *)key{
    NSLog(@"KEY KQ: %@", key);
    if ([key isEqualToString:@"0"]) {
        self.lbKetQua.text = @"Bạn kiểm tra lại Họ Tên Nhập chưa đúng!!!";
    } else {
        NSDictionary *dic = [self.dicdata objectForKey:[NSString stringWithFormat:@"%@",key]];
        self.lbKetQua.text = [dic objectForKey:@"title"];
    }
}

///// phone
-(void)tinhSo{
    NSString *strNumber = self.numberPhoneTextfield.text;
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([strNumber rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        NSString *strNew = [strNumber substringWithRange:NSMakeRange(strNumber.length-4, 4)];
        float x1 = [strNew intValue]/80;
        float x2 = [strNew floatValue]/80;
        int x3 = (int)((x2-x1)*80);
        [self checkso:x3];
    } else {
        NSLog(@"NHAP SAI");
        self.lbKetQua.text = @"Bạn kiểm tra lại số điện thoại nhập chưa đúng!!!";
    }
}

-(void)checkso:(int)key{
    NSDictionary *dic = [self.dicdatanumberPhone objectForKey:[NSString stringWithFormat:@"%d",key]];
    NSString *title = [dic objectForKey:@"title"];
    NSString *kq = [dic objectForKey:@"kq"];
    self.lbKetQua.text = [NSString stringWithFormat:@"%@ \n==> %@", title, kq];
    NSLog(@"KEY KQ: %d", key);
}

//choose mode
-(void)chooseMode{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Chọn Loại Bói" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Bói Họ và Tên" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.btnTitle setTitle:@"Bói Họ và Tên" forState:UIControlStateNormal];
        [self.nameView setHidden:NO];
        [self.numberView setHidden:YES];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Bói Số Điện Thoại" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.btnTitle setTitle:@"Bói Số Điện Thoại" forState:UIControlStateNormal];
        [self.nameView setHidden:YES];
        [self.numberView setHidden:NO];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:actionSheet];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else{
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}


- (IBAction)touchChoosemode:(id)sender {
    [self chooseMode];
}
- (IBAction)showPinkker:(id)sender {
    
}



@end
