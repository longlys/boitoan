//
//  BTChiTayViewController.m
//  BoiToan
//
//  Created by LongLy on 23/12/2018.
//  Copyright © 2018 LongLy. All rights reserved.
//

#import "BTChiTayViewController.h"
@import GoogleMobileAds;

@interface BTChiTayViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIAlertViewDelegate, GADInterstitialDelegate, GADBannerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL isCamera;
@property(nonatomic)NSDictionary *dicdatachitay;
@property (nonatomic)NSUInteger randomIndex;
@property (nonatomic)GADInterstitial *interstitial;
@property(nonatomic, weak) IBOutlet GADBannerView *bannerView;
@end

@implementation BTChiTayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Bói Chỉ Tay";
    self.isCamera = NO;
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"datachitay" ofType:@"json"];
    NSData *data3 = [NSData dataWithContentsOfFile:path3];
    NSDictionary *dic3 = [NSJSONSerialization JSONObjectWithData:data3 options:kNilOptions error:nil];
    self.dicdatachitay = dic3;
    self.interstitial = [self createAndLoadInterstitial];
    self.interstitial.delegate = self;
    
    //banner
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = kXBBanner;
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    [self.bannerView loadRequest:request];
    UIImageView *imgtest = [[UIImageView alloc] initWithFrame:self.imageView.bounds];
    [imgtest setImage:[UIImage imageNamed:@"img.png"]];
    [self.view addSubview:imgtest];
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


- (IBAction)showCamera:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}
- (IBAction)xemkq:(id)sender {
    if (self.isCamera) {
        [self showError:NO];
        //        self.textViewKQ.text = [NSString stringWithFormat:@"Coming soon..."];
    } else {
        [self showError:YES];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self showInterstitial];
    }];
    self.isCamera = YES;
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)showError:(BOOL)isError{
    NSString *title = @"Lỗi";
    NSString *message = @"Chụp ảnh bàn tay trước mới xem kết quả!";
    if (!isError) {
        title = @"Kết quả phân tích";
        if (self.randomIndex == -1) {
            self.randomIndex = arc4random() % self.dicdatachitay.count;
        }
        message = [self.dicdatachitay objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)self.randomIndex]];
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    //We add buttons to the alert controller by creating UIAlertActions:
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"Đồng Ý"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil]; //You can use a block here to handle a press on this button
    [alertController addAction:actionOk];
    [self presentViewController:alertController animated:YES completion:nil];
}

    
@end
