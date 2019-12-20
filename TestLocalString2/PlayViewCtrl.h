//
//  PlayViewCtrl.h
//  MagiNo
//
//  Created by Jeff Chen on 6/3/13.
//  Copyright (c) 2013 Jeff Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <GoogleMobileAds/GoogleMobileAds.h>


#define MY_BANNER_UNIT_ID @"ca-app-pub-7171184960888074/3552578749"


@interface PlayViewCtrl : UIViewController
<UIAlertViewDelegate,
GADInterstitialDelegate,
GADBannerViewDelegate> //admob
{
    GADBannerView *adMobView;
    
    int curPageIndex;
    int finalNO;
    
    // blow
    AVAudioRecorder *recorder;
    NSTimer *levelTimer;
    double lowPassResults;
    
    AVAudioPlayer*  player; // music
}

//@property (nonatomic, retain) IBOutlet ADBannerView *adBannerView;
@property (strong, nonatomic) IBOutlet UIView *viewCenter;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet UIView *view6;
@property (strong, nonatomic) IBOutlet UIView *view7;

@property (strong, nonatomic) IBOutlet UILabel *lblFinal;
@property (strong, nonatomic) IBOutlet UIButton *btnYES;
@property (strong, nonatomic) IBOutlet UIButton *btnNO;
@property (strong, nonatomic) IBOutlet UIView *viewYesNo;
@property (strong, nonatomic) IBOutlet UIButton *btnRestart;

@property (strong, nonatomic) IBOutlet UILabel *lblCheck;
@property (weak, nonatomic) IBOutlet UIView *viewScratch;

- (IBAction)goYES:(id)sender;
- (IBAction)goNO:(id)sender;
- (IBAction)goClose:(id)sender;
- (IBAction)goRestart:(id)sender;


@end
