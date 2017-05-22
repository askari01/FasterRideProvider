//
//  PickMeUpMapVC.h
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"
#import "SWRevealViewController.h"
#import <MapKit/MapKit.h>
#import "sbMapAnnotation.h"
#import <CoreLocation/CoreLocation.h>
#import "LDProgressView.h"
#import "UIColor+RGBValues.h"
#import <AVFoundation/AVAudioPlayer.h>
#import "AudioToolbox/AudioToolbox.h"
#import <GoogleMaps/GoogleMaps.h>

@class SideBarVC;
@class ArrivedMapVC,RatingBar;


@interface PickMeUpMapVC : BaseVC <MKAnnotation,MKMapViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>
{
    Reachability *internetReachableFoo;
    BOOL internet;
    UIImageView* routeView;
    
	NSArray* routes;
	
	UIColor* lineColor;
    
    LDProgressView *progressView;
    GMSMapView *mapView_;
    GMSMarker *marker;

}

@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIView *etaView;
@property (weak, nonatomic) IBOutlet UIView *datePicker;

- (IBAction)onClickSetEta:(id)sender;
- (IBAction)onClickReject:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblGoOnline;

- (IBAction)onClickAccept:(id)sender;

- (IBAction)onClickNoKey:(id)sender;
-(void)goToSetting:(NSString *)str;
@property (weak, nonatomic) IBOutlet UIView *viewForGoOffline;

@property (weak, nonatomic) IBOutlet UILabel *lblBlue;
@property (weak, nonatomic) IBOutlet UILabel *lblGrey;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblDetails;
@property (weak, nonatomic) IBOutlet UIImageView *imgStar;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnReject;
- (IBAction)pickMeBtnPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *ProfileView;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfile;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView_;

@property (weak, nonatomic) IBOutlet UIProgressView *progressTimer;


@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) NSTimer *time;
@property(nonatomic, strong) NSTimer *progtime;
@property (weak, nonatomic) IBOutlet UIImageView *imgTimeBg;

@property (weak, nonatomic) IBOutlet UILabel *lblWhite;
@property(nonatomic, strong) ArrivedMapVC *arrivedMap;

@property (weak, nonatomic) IBOutlet RatingBar *ratingView;
@property (weak, nonatomic) IBOutlet UIView *viewForMap;
@property (weak, nonatomic) IBOutlet UIView *viewForNotApproved;
- (IBAction)onClickClose:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblNotApproved;
@property (weak, nonatomic) IBOutlet UILabel *lblUnderReview;
@property (weak, nonatomic) IBOutlet UILabel *lblEstimateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEstimateDistance;

@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (strong, nonatomic) AVAudioPlayer *sound1Player;
@property (strong, nonatomic) IBOutlet UIButton *btnGoOnline;
- (IBAction)clickGoOnline:(id)sender;


//number of rating 
@property (strong, nonatomic) IBOutlet UILabel *lblNumberOfRating;

//ESTIMATE.
@property (strong, nonatomic) IBOutlet UILabel *lblEstDistance;
@property (strong, nonatomic) IBOutlet UILabel *lblEstTime;

//Destinaation Address
@property (strong, nonatomic) IBOutlet UILabel *lblDestinationAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblPickupAddress;

@property (strong, nonatomic) IBOutlet UIImageView *imgbg;
@property (strong, nonatomic) IBOutlet UIImageView *imgOnline;

@property(nonatomic, strong) NSTimer *timerForCancelRequest;

@end
