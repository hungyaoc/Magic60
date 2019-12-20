//
//  PlayViewCtrl.m
//  MagiNo
//
//  Created by Jeff Chen on 6/3/13.
//  Copyright (c) 2013 Jeff Chen. All rights reserved.
//

#import "PlayViewCtrl.h"
#import "MDScratchImageView.h"

@import GoogleMobileAds;

#define ID_DELAY 101

extern BOOL bFull;

@interface PlayViewCtrl ()
@property(nonatomic, strong) GADInterstitial*   admob;
@property(nonatomic, strong) GADBannerView*     adBannerView;
@property(nonatomic, strong) MDScratchImageView *scratchImageView;
@end

@implementation PlayViewCtrl
//@synthesize adBannerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //===
    [self resetEverying];
    
    // update UI by localization
    [self.btnYES        setTitle:NSLocalizedString(@"Yes", nil)     forState:UIControlStateNormal];
    [self.btnNO         setTitle:NSLocalizedString(@"No", nil)      forState:UIControlStateNormal];
    [self.btnRestart    setTitle:NSLocalizedString(@"Restart", nil)   forState:UIControlStateNormal];
    
    self.lblCheck.text = NSLocalizedString(@"Is your number list above?", nil);
    
    // background music
    [self prepareMusic];
    
    if(bFull == NO)
    {
        [self initAdmob];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark blow
-(void)initBlow
{
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
  	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
  	NSError *error;
    
  	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
  	if (recorder)
    {
  		[recorder prepareToRecord];
  		recorder.meteringEnabled = YES;
  		[recorder record];
        
        levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(listenForBlow:) userInfo: nil repeats: YES];
  	}
    else
    {
        NSLog(@"%@", [error description]);
    }
}

- (void)listenForBlow:(NSTimer*)timer
{
	[recorder updateMeters];
    
    const double ALPHA = 0.05;
	double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
	lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
	//NSLog(@"Average: %f Peak: %f Low-pass: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);
    NSLog(@"Low-pass: %f", lowPassResults);
    
    if (lowPassResults > 0.85)
    {
        NSLog(@"Mic blow detected");
        
        [levelTimer invalidate];
        [recorder stop];
        
        self.lblFinal.text = [NSString stringWithFormat:@"%d", finalNO];
        
        // restart button
        self.btnRestart.alpha = 1.0f;
        self.viewYesNo.alpha  = 0.0f;
    }
}


-(void)move2NextPage
{
    UIView* target;
    
    self.viewYesNo.alpha  = 1.0;
    self.viewCenter.alpha = 1.0;
    
    switch (curPageIndex)
    {
        case 0:
            target = self.view1;
            self.lblTitle.text = NSLocalizedString(@"Page 1/6", nil);
            curPageIndex ++;
            target.frame = self.viewCenter.bounds;
            [self.viewCenter addSubview:target];
            return;
            
        case 1:
            target = self.view2;
            self.lblTitle.text = NSLocalizedString(@"Page 2/6", nil);
            break;
            
        case 2:
            target = self.view3;
            self.lblTitle.text = NSLocalizedString(@"Page 3/6", nil);
            break;
            
        case 3:
            target = self.view4;
            self.lblTitle.text = NSLocalizedString(@"Page 4/6", nil);
            break;
            
        case 4:
            target = self.view5;
            self.lblTitle.text = NSLocalizedString(@"Page 5/6", nil);
            break;
            
        case 5:
            target = self.view6;
            self.lblTitle.text = NSLocalizedString(@"Page 6/6", nil);
            break;
            
        case 6:
            curPageIndex ++;
            self.lblTitle.text = @"";
            
            // prepare to show
            [self prepare2ShowAnswer];
            
            self.view7.frame = self.viewCenter.bounds;
            [self.viewCenter addSubview:self.view7];
            
            // add a scratchable view
            self.scratchImageView = [[MDScratchImageView alloc] initWithFrame:self.viewScratch.bounds];
            self.scratchImageView.image = [UIImage imageNamed:@"scratchable.jpg"];
            
            [self.viewScratch addSubview:self.scratchImageView];
            
            self.viewYesNo.alpha = 0.0;
            
            return;
    }
    
    curPageIndex ++;
    target.frame = self.viewCenter.bounds;
    [self.viewCenter addSubview:target];
    
    // flip
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.viewCenter cache:YES];
    [UIView commitAnimations];
}

-(void)prepare2ShowAnswer
{
    // message to user
    self.lblTitle.text = NSLocalizedString(@"Scratch to see the answer", nil);
    //
    self.lblFinal.font      = [UIFont systemFontOfSize:150];
    self.lblFinal.textColor = [UIColor yellowColor];
    self.lblFinal.text      = [NSString stringWithFormat:@"%d", finalNO];
    self.lblFinal.alpha     = 1.0f;
    
    self.btnRestart.hidden  = NO;
    self.btnRestart.alpha   = 1.0f;
}

- (IBAction)goYES:(id)sender
{
    switch (curPageIndex)
    {
        case 1:
            finalNO = 1;
            break;
            
        case 2:
            finalNO += 2;
            break;
            
        case 3:
            finalNO += 4;
            break;
            
        case 4:
            finalNO += 8;
            break;
            
        case 5:
            finalNO += 16;
            break;
            
        case 6:
            finalNO += 32;
    }
    
    // check if reach end
    [self move2NextPage];
}

- (IBAction)goNO:(id)sender
{
    [self move2NextPage];
}

- (IBAction)goClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goRestart:(id)sender
{
    [self resetEverying];
}

-(void)resetEverying
{
    finalNO      = 0;
    curPageIndex = 0;
    
    self.viewYesNo.alpha   = 0.0;
    self.viewCenter.alpha  = 0.0;
    self.btnRestart.alpha  = 0.0;
    
    [self.scratchImageView removeFromSuperview];
    self.scratchImageView = nil;
    
    self.lblTitle.text = @"";
    
    // pick a number
    NSString* strMsg1 = NSLocalizedString(@"Pick a Number", nil);
    NSString* strMsg2 = NSLocalizedString(@"Please choose a number from 1 to 60 and don't tell me.", nil);
    NSString* strMsg3 = NSLocalizedString(@"Continue", nil);
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:strMsg1
                                                    message:strMsg2
                                                   delegate:self
                                          cancelButtonTitle:strMsg3
                                          otherButtonTitles:nil];
    alert.tag = ID_DELAY;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == ID_DELAY)
    {
        [self move2NextPage];
    }
}


- (void)viewDidUnload {
    [self setViewCenter:nil];
    [self setView1:nil];
    [self setView2:nil];
    [self setView3:nil];
    [self setView4:nil];
    [self setView5:nil];
    [self setView6:nil];
    [self setView7:nil];
    [self setLblFinal:nil];
    [self setBtnYES:nil];
    [self setBtnNO:nil];
    [self setViewYesNo:nil];
    [self setBtnRestart:nil];
    [self setLblTitle:nil];
    [super viewDidUnload];
}



#pragma mark
#pragma mark shake
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if ( event.subtype == UIEventSubtypeMotionShake )
    {
    }
    
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder
{ return YES; }

- (void)prepareMusic
{
    NSError* error;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"destination" ofType:@"mp3"];
    
    // If we can access the file...
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        // Setup the player
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
        
        // Set the volume (range is 0 to 1)
        player.volume = 0.4f;
        
        // To minimize lag time before start of output, preload buffers
        [player play];
        
        // Play the sound once (set negative to loop)
        [player setNumberOfLoops:-1];
    }
}

#pragma mark
#pragma mark Google ADMob
-(void)initAdmob
{
    self.adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.adBannerView.adUnitID = MY_BANNER_UNIT_ID;
    self.adBannerView.delegate = self;
    self.adBannerView.rootViewController = self;
    
    [self.adBannerView loadRequest:[GADRequest request]];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    CGRect rc = bannerView.frame;
    CGRect rcScreen = self.view.frame;
    
    bannerView.frame = CGRectMake(0, rcScreen.size.height - rc.size.height, rc.size.width, rc.size.height);
    [self.view addSubview:bannerView];
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"error!");
}

/*-(void)initAdmob
{
    self.admob = [[GADInterstitial alloc] initWithAdUnitID:MY_BANNER_UNIT_ID];
    
    self.admob.delegate = self;
    
    GADRequest *request = [GADRequest request];
    
    [self.admob loadRequest:request];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    if([self.admob isReady])
    {
        [self.admob presentFromRootViewController:self];
    }
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
}*/

@end
