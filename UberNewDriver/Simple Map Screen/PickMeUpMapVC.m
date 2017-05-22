//
//  PickMeUpMapVC.m
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "PickMeUpMapVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RegexKitLite.h"
#import "sbMapAnnotation.h"
#import "UIImageView+Download.h"
#import "ContactVC.h"
#import "ArrivedMapVC.h"
#import "RatingBar.h"
#import "UIView+Utils.h"

@interface PickMeUpMapVC ()
{
    CLLocationManager *locationManager;
    
    NSMutableArray *arrRequest;
    NSMutableString *strUserId;
    NSMutableString *strUserToken;
    NSMutableString *strRequsetId;
    NSMutableDictionary *dict;
    NSMutableDictionary *dictOwner;
    BOOL flag,isTo,is_approved;
    int time;
    float totalDist;
    CLLocationCoordinate2D currentOwner;
    GMSMarker *markerOwner;
    NSString *strEstDistanceUnit;
    CGRect mainMapFrame;
}

@end

@implementation PickMeUpMapVC

@synthesize lblBlue,lblGrey,lblTime,btnProfile,btnAccept,btnReject,lblDetails,lblName,lblRate,imgStar,ProfileView,imgUserProfile,sound1Player;

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
    [self hide];
    internet=[APPDELEGATE connected];
    [super viewDidLoad];
	[self.btnGoOnline setBackgroundColor:DarkBtnColor];
	[self.btnReject setBackgroundColor:LightBtnColor];
	[self.btnAccept setBackgroundColor:DarkBtnColor];
	[self.viewForGoOffline setBackgroundColor:ProfileViewColor];

    [self localizeString];
    
    //SideBarVC *sidebarObj=[self.storyboard instantiateViewControllerWithIdentifier:@"pickmeUp"];
    //[sidebarObj setDelegate:self];
    
    self.arrivedMap.pickMeUp=self;
    
    [self.imgUserProfile applyRoundedCornersFullWithColor:[UIColor whiteColor]];
    isTo=NO;
    progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(-50,-50, 320,20)];
    progressView.color = [UIColor colorWithRed:0.0f/255.0f green:193.0f/255.0f blue:63.0f/255.0f alpha:1.0];
    //progressView.background = [UIColor colorWithRed:122.0f/255.0f green:122.0f/255.0f blue:122.0f/255.0f alpha:1.0];
    progressView.progress = 1.0;
    progressView.showText = @NO;
    progressView.animate = @NO;
    progressView.borderRadius = @NO;
    [self.ProfileView addSubview:progressView];
    [self.ProfileView bringSubviewToFront:self.lblTime];
    
    
    [self.btnMenu addTarget:self.revealViewController action:@selector(revealToggle: ) forControlEvents:UIControlEventTouchUpInside];
    self.etaView.hidden=YES;
    
    
    [self.ratingView initRateBar];
    [self.ratingView setUserInteractionEnabled:NO];
    
    strUserId=[PREF objectForKey:PREF_USER_ID];
    strUserToken=[PREF objectForKey:PREF_USER_TOKEN];
    strRequsetId=[PREF objectForKey:PREF_REQUEST_ID];
    
    [self updateLocation];
    [self getPagesData];
    [self customFont];
    [self getUserLocation];
    
    [self.navigationController.navigationBar addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    time=0;
    
    CLLocationCoordinate2D current;
    current.latitude=[struser_lati doubleValue];
    current.longitude=[struser_longi doubleValue];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:current.latitude
                                                            longitude:current.longitude
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0,0,self.viewForMap.frame.size.width,self.viewForMap.frame.size.height) camera:camera];
    mapView_.myLocationEnabled = NO;
    mapView_.delegate=self;
    [self.viewForMap addSubview:mapView_];
    
    marker = [[GMSMarker alloc] init];
    marker.position = current;
    marker.icon = [UIImage imageNamed:@"pin_driver"];
    marker.map = mapView_;
    
    // Creates a marker in the center of the map.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    internet=[APPDELEGATE connected];
    
    strUserId=[PREF objectForKey:PREF_USER_ID];
    strUserToken=[PREF objectForKey:PREF_USER_TOKEN];
    strRequsetId=[PREF objectForKey:PREF_REQUEST_ID];
    is_approved=[[PREF valueForKey:PREF_IS_APPROVED] boolValue];
    
    if (is_approved)
    {
        self.btnGoOnline.hidden=NO;
        
        self.viewForNotApproved.hidden=YES;
        self.navigationController.navigationBarHidden=NO;
        [self checkState];
    }
    else
    {
        self.btnGoOnline.hidden=YES;
        self.viewForNotApproved.hidden=NO;
        self.navigationController.navigationBarHidden=YES;
        [self checkState];
    }
    
    [self updateLocation];
    
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
    [runloop addTimer:self.timer forMode:NSRunLoopCommonModes];
    [runloop addTimer:self.timer forMode:UITrackingRunLoopMode];
    
    self.navigationItem.hidesBackButton=YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showUserLoc) userInfo:nil repeats:NO];
    [self getRequestId];
    
    strowner_lati=nil;
    strowner_longi=nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.btnMenu setTitle:NSLocalizedString(@"APPNAME", nil) forState:UIControlStateNormal];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.mapView_ clear];
    //[mapView_ clear];
    
    CLLocationCoordinate2D current;
    current.latitude=[struser_lati doubleValue];
    current.longitude=[struser_longi doubleValue];
    
    marker.map=nil;
    marker = [[GMSMarker alloc] init];
    marker.position = current;
    marker.icon = [UIImage imageNamed:@"pin_driver"];
    marker.map = mapView_;
    [self hide];
    // [self.mapView removeAnnotations:self.mapView.annotations];
}

-(void)showUserLoc
{
    if ([CLLocationManager locationServicesEnabled])
    {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude=[struser_lati doubleValue];
        coordinate.longitude=[struser_longi doubleValue];
        
        GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:coordinate zoom:15];
        
        [mapView_ animateWithCameraUpdate:updatedCamera];
    }
    else
    {
        UIAlertView *alertLocation=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"Enable Location access", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertLocation.tag=100;
        [alertLocation show];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-
#pragma mark- Custom Font

-(void)customFont
{
    self.btnMenu.titleLabel.font=[UberStyleGuide fontRegularLight];
    self.btnMenu.titleLabel.textColor=[UberStyleGuide fontColorNevigation];
    self.lblEstTime.font=[UberStyleGuide fontRegular:12.85f];
    self.lblEstDistance.font=[UberStyleGuide fontRegular:12.85f];
    self.lblName.font=[UberStyleGuide fontRegular:15.43f];
}

-(void)localizeString
{
    self.lblNotApproved.text = NSLocalizedString(@"YOU ARE NOT APPROVED BY ADMIN", nil);
    self.lblUnderReview.text = NSLocalizedString(@"YOU ARE NOT APPROVED BY ADMIN REVIEW", nil);
    [self.btnMenu setTitle:NSLocalizedString(@"APPNAME", nil) forState:UIControlStateNormal];
    [self.btnAccept setTitle:NSLocalizedString(@"ACCEPT",nil)forState:UIControlStateHighlighted];
    [self.btnAccept setTitle:NSLocalizedString(@"ACCEPT",nil)forState:UIControlStateNormal];
    [self.btnAccept setTitle:NSLocalizedString(@"ACCEPT",nil)forState:UIControlStateSelected];
    [self.btnReject setTitle:NSLocalizedString(@"REJECT",nil)forState:UIControlStateHighlighted];
    [self.btnReject setTitle:NSLocalizedString(@"REJECT",nil)forState:UIControlStateNormal];
    [self.btnReject setTitle:NSLocalizedString(@"REJECT",nil)forState:UIControlStateSelected];
    [self.btnClose setTitle:NSLocalizedString(@"CLOSE",nil)forState:UIControlStateHighlighted];
    [self.btnClose setTitle:NSLocalizedString(@"CLOSE",nil)forState:UIControlStateSelected];
    self.lblEstimateTime.text = NSLocalizedString(@"EST_TIME", nil);
    self.lblEstimateDistance.text = NSLocalizedString(@"EST_DISTANCE", nil);
}

#pragma mark-
#pragma mark- Profile View Hide/Show Method

-(void)hide
{
    self.lblTime.hidden=YES;
    self.lblWhite.hidden=YES;
    self.imgTimeBg.hidden=YES;
    [ProfileView setHidden:YES];
    [btnAccept setHidden:YES];
    [btnReject setHidden:YES];
    [self.btnGoOnline setHidden:NO];
    mainMapFrame = self.viewForMap.frame;
}

-(void)show
{
    [self.btnGoOnline setHidden:YES];
    self.lblTime.hidden=NO;
    self.lblWhite.hidden=NO;
    self.imgTimeBg.hidden=NO;
    [ProfileView setHidden:NO];
    [btnAccept setHidden:NO];
    [btnReject setHidden:NO];
    self.viewForMap.frame = CGRectMake(self.viewForMap.frame.origin.x,self.ProfileView.frame.origin.y ,self.viewForMap.frame.size.width, self.viewForMap.frame.size.height);
}

#pragma mark-
#pragma mark- If-Else Methods

-(void)getRequestId
{
    if (strRequsetId!=nil)
    {
        [self checkRequest];
    }
    else
    {
        [self requsetProgress];
    }
}
-(void)getRequestIdSecond
{
    if (strRequsetId!=nil)
    {
        [self checkRequest];
    }
    else
    {
        flag=YES;
        [self getAllRequests];
    }
}

-(void)requestThird
{
    if(strRequsetId!=nil)
    {
        [self respondToRequset];
    }
    else
    {
        flag=NO;
        [self.time invalidate];
        [self getAllRequests];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        self.time = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getAllRequests) userInfo:nil repeats:YES];
        [runloop addTimer:self.time forMode:NSRunLoopCommonModes];
        [runloop addTimer:self.time forMode:UITrackingRunLoopMode];
        self.navigationItem.hidesBackButton=YES;
    }
}

#pragma mark-
#pragma mark- API Methods

-(void)checkRequest
{
    if([APPDELEGATE connected])
    {
        NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
        
        [dictparam setObject:strUserId forKey:PARAM_ID];
        [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
        [dictparam setObject:strRequsetId forKey:PARAM_REQUEST_ID];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:FILE_GET_REQUEST withParamData:dictparam withBlock:^(id response, NSError *error)
         {
             
             NSLog(@"Check Request= %@",response);
             
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     NSMutableDictionary *dictRequest=[response valueForKey:@"request"];
                     
                     is_completed=[[dictRequest valueForKey:@"is_completed"]intValue];
                     is_dog_rated=[[dictRequest valueForKey:@"is_dog_rated"]intValue];
                     is_started=[[dictRequest valueForKey:@"is_started" ]intValue];
                     is_walker_arrived=[[dictRequest valueForKey:@"is_walker_arrived"]intValue];
                     is_walker_started=[[dictRequest valueForKey:@"is_walker_started"]intValue];
                     
                     
                     dictOwner=[dictRequest valueForKey:@"owner"];;//[arrOwner objectAtIndex:0];
                     strowner_lati=[dictOwner valueForKey:@"latitude"];
                     strowner_longi=[dictOwner valueForKey:@"longitude"];
                     payment=[[dictRequest valueForKey:@"payment_type"] intValue];
                     
                     
                     NSString *gmtDateString = [dictRequest valueForKey:@"start_time"];
                     NSDateFormatter *df = [NSDateFormatter new];
                     [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                     df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                     NSDate *datee = [df dateFromString:gmtDateString];
                     df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
                     
                     NSString *startTime=[NSString stringWithFormat:@"%f",[datee timeIntervalSince1970] * 1000];
                     
                     
                     [PREF setObject:startTime forKey:PREF_START_TIME];
                     [PREF synchronize];
                     
                     
                     [PREF setObject:[dictOwner valueForKey:@"name"] forKey:PREF_USER_NAME];
                     [PREF setObject:[dictOwner valueForKey:@"rating"] forKey:PREF_USER_RATING];
                     [PREF setObject:[dictOwner valueForKey:@"phone"] forKey:PREF_USER_PHONE];
                     [PREF setObject:[dictOwner valueForKey:@"picture"] forKey:PREF_USER_PICTURE];
                     [PREF synchronize];
                     [mapView_ clear];
                     
                     [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"PLEASE_WAIT", nil)];
                     [self performSegueWithIdentifier:@"segurtoarrived" sender:self];
                     // [self respondToRequset];
                 }
                 else
                 {
                     if ([[response valueForKey:@"error_code"] integerValue]==406)
                     {
                         [self performSegueWithIdentifier:@"logout" sender:self];
                     }
                     else
                     {
                         [PREF removeObjectForKey:PREF_REQUEST_ID];
                         strRequsetId=[PREF valueForKey:PREF_REQUEST_ID];
                         [PREF synchronize];
                         [self getRequestId];
                     }
                 }
             }
             
         }];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Internet", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)requsetProgress
{
    if([APPDELEGATE connected])
    {
        NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
        
        [dictparam setObject:strUserId forKey:PARAM_ID];
        [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:FILE_PROGRESS withParamData:dictparam withBlock:^(id response, NSError *error)
         {
             
             NSLog(@"Request in Progress= %@",response);
             
             if (response)
             {
                 if([[response valueForKey:@"success"]intValue]==1)
                 {
                     
                     if ([[response valueForKey:@"request_id"] intValue]!=-1)
                     {
                         
                         [PREF setObject:[response valueForKey:@"request_id"] forKey:PREF_REQUEST_ID];
                         [PREF synchronize];
                         strRequsetId=[response valueForKey:@"request_id"];
                     }
                     [self getRequestIdSecond];
                 }
                 else
                 {
                     if ([[response valueForKey:@"error_code"] integerValue]==406)
                     {
                         [self performSegueWithIdentifier:@"logout" sender:self];
                     }
                 }
             }
         }];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Internet", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)getAllRequests
{
    if([APPDELEGATE connected])
    {
        strUserId = [PREF valueForKey:PARAM_ID];
        strUserToken = [PREF valueForKey:PARAM_TOKEN];
        [PREF synchronize];
        NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
        
        [dictparam setObject:strUserId forKey:PARAM_ID];
        [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:FILE_REQUEST withParamData:dictparam withBlock:^(id response, NSError *error)
         {
             NSLog(@"Get All Request= %@",response);
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     [[AppDelegate sharedAppDelegate] hideLoadingView];
                     
                     [PREF setBool:[[response valueForKey:@"is_approved"] boolValue] forKey:PREF_IS_APPROVED];
                     is_approved=[[PREF valueForKey:PREF_IS_APPROVED] boolValue];
                     if (is_approved)
                     {
                         self.btnGoOnline.hidden=NO;
                         self.viewForNotApproved.hidden=YES;
                         self.navigationController.navigationBarHidden=NO;
                     }
                     else
                     {
                         self.btnGoOnline.hidden=YES;
                         self.viewForNotApproved.hidden=NO;
                         self.navigationController.navigationBarHidden=YES;
                     }
                     
                     NSMutableArray *arrRespone=[response valueForKey:@"incoming_requests"];
                     if(arrRespone.count!=0)
                     {
                         [self.time invalidate];
                         NSMutableDictionary *dictRequestData=[arrRespone valueForKey:@"request_data"];
                         NSMutableArray *arrOwner=[dictRequestData valueForKey:@"owner"];
                         dictOwner=[arrOwner objectAtIndex:0];
                         
                         NSMutableArray *arrRequest_Id=[arrRespone valueForKey:@"request_id"];
                         strRequsetId=[NSMutableString stringWithFormat:@"%@",[arrRequest_Id objectAtIndex:0]];
                         
                         [PREF setObject:strRequsetId forKey:PREF_REQUEST_ID];
                         
                         
                         lblName.text=[dictOwner valueForKey:@"name"];
                         
                         self.lblNumberOfRating.text=[NSString stringWithFormat:@"%@",[[dictOwner valueForKey:@"rating"] intValue]==0?@"0.0":[NSString stringWithFormat:@"%.1f",[[dictOwner valueForKey:@"rating"] floatValue]]];
                         
                         lblRate.text=[NSString stringWithFormat:@"%@",[dictOwner valueForKey:@"rating"]];
                         lblDetails.text=[NSString stringWithFormat:@"%@",[dictOwner valueForKey:@"phone"]];
                         [self.imgUserProfile downloadFromURL:[dictOwner valueForKey:@"picture"] withPlaceholder:nil];
                         
                         strowner_lati=[NSString stringWithFormat:@"%@",[dictOwner valueForKey:@"latitude"]];
                         strowner_longi=[NSString stringWithFormat:@"%@",[dictOwner valueForKey:@"longitude"]];
                         
                         RBRatings rate=([[dictOwner valueForKey:@"rating"]floatValue]*2);
                         [ self.ratingView setRatings:rate];
                         
                         payment=[[dictOwner valueForKey:@"payment_type"] integerValue];
                         
                         
                         [self.mapView_ clear];
                         
                         CLLocationCoordinate2D current;
                         current.latitude=[struser_lati doubleValue];
                         current.longitude=[struser_longi doubleValue];
                         
                         marker = [[GMSMarker alloc] init];
                         marker.position = current;
                         marker.icon = [UIImage imageNamed:@"pin_driver"];
                         marker.map = mapView_;

                         currentOwner.latitude=[strowner_lati doubleValue];
                         currentOwner.longitude=[strowner_longi doubleValue];
                         
                         markerOwner = [[GMSMarker alloc] init];
                         markerOwner.position = currentOwner;
                         markerOwner.icon = [UIImage imageNamed:@"pin_client_org"];
                         markerOwner.map = mapView_;
                         
                         self.lblPickupAddress.text=[dictOwner valueForKey:@"src_address"];
                         strEstDistanceUnit =[[arrRespone valueForKey:@"unit"]objectAtIndex:0];
                         
                         if (currentOwner.latitude!=0.00 && currentOwner.longitude!=0.00)
                         {
                             [self calculateEstimatedTimeAndDistance:current to:currentOwner];
                             [self.ratingView setHidden:YES];
                         }
                         else
                         {
                             self.lblEstDistance.text=[NSString stringWithFormat:@"%.2f %@.",0.0,NSLocalizedString(@"kms", nil)];
                             self.lblEstTime.text=[NSString stringWithFormat:@"%d %@.",0,NSLocalizedString(@"Min", nil)];
                         }
                         
                         NSMutableArray *arrTime=[arrRespone valueForKey:@"time_left_to_respond"];
                         time=[[arrTime objectAtIndex:0]intValue];
                         
                         
                         [self.progtime invalidate];
                         NSRunLoop *runloop = [NSRunLoop currentRunLoop];
                         self.progtime = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(customProgressBar) userInfo:nil repeats:YES];
                         [runloop addTimer:self.progtime forMode:NSRunLoopCommonModes];
                         [runloop addTimer:self.progtime forMode:UITrackingRunLoopMode];
                         
                         
                         [self.timerForCancelRequest invalidate];
                         self.timerForCancelRequest = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkForCancelRequest) userInfo:nil repeats:YES];
                         [runloop addTimer:self.timerForCancelRequest forMode:NSRunLoopCommonModes];
                         [runloop addTimer:self.timerForCancelRequest forMode:UITrackingRunLoopMode];
                         
                         [self show];
                         [self centerMapFirst:current two:currentOwner third:current];
                     }
                     
                     else if (flag==YES)
                     {
                         [self requestThird];
                         
                     }
                 }
                 else
                 {
                     if ([[response valueForKey:@"error_code"] integerValue]==406)
                     {
                         [self performSegueWithIdentifier:@"logout" sender:self];
                     }
                 }
             }
             
         }];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Internet", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)updateLocation
{
    if([CLLocationManager locationServicesEnabled])
    {
        if([APPDELEGATE connected])
        {
            
            if(((struser_lati==nil)&&(struser_longi==nil))
               ||(([struser_longi doubleValue]==0.00)&&([struser_lati doubleValue]==0)))
            {
            }
            else
            {
                strUserId = [PREF valueForKey:PARAM_ID];
                strUserToken = [PREF valueForKey:PARAM_TOKEN];
                
                NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
                [dictparam setObject:strUserId forKey:PARAM_ID];
                [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
                [dictparam setObject:struser_longi forKey:PARAM_LONGITUDE];
                [dictparam setObject:struser_lati forKey:PARAM_LATITUDE];
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_USERLOCATION withParamData:dictparam withBlock:^(id response, NSError *error)
                 {
                     
                     NSLog(@"Update Location = %@",response);
                     if (response)
                     {
                         if([[response valueForKey:@"success"] intValue]==1)
                         {
                             
                         }
                         else
                         {
                             if ([[response valueForKey:@"error_code"] integerValue]==406)
                             {
                                 [self performSegueWithIdentifier:@"logout" sender:self];
                             }
                         }
                     }
                     
                 }];
                
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Internet", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alertLocation=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"Enable Location access", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertLocation.tag=100;
        [alertLocation show];
    }
}

-(void)respondToRequset
{
    if([APPDELEGATE connected])
    {
        
        strRequsetId=[PREF objectForKey:PREF_REQUEST_ID];
        
        if (strRequsetId!=nil)
        {
            NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
            
            [dictparam setObject:strRequsetId forKey:PARAM_REQUEST_ID];
            [dictparam setObject:strUserId forKey:PARAM_ID];
            [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
            [dictparam setObject:@"1" forKey:PARAM_ACCEPTED];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_RESPOND_REQUEST withParamData:dictparam withBlock:^(id response, NSError *error)
             {
                 
                 NSLog(@"Respond to Request= %@",response);
                 [APPDELEGATE hideLoadingView];
                 if (response)
                 {
                     if([[response valueForKey:@"success"] intValue]==1)
                     {
                         
                         [APPDELEGATE showToastMessage:NSLocalizedString(@"REQUEST_ACCEPTED", nil)];
                         
                         [PREF setObject:[dictOwner valueForKey:@"name"] forKey:PREF_USER_NAME];
                         [PREF setObject:[dictOwner valueForKey:@"rating"] forKey:PREF_USER_RATING];
                         [PREF setObject:[dictOwner valueForKey:@"phone"] forKey:PREF_USER_PHONE];
                         [PREF setObject:[dictOwner valueForKey:@"picture"] forKey:PREF_USER_PICTURE];
                         [PREF synchronize];
                         
                         
                         lblName.text=[dictOwner valueForKey:@"name"];
                         lblRate.text=[NSString stringWithFormat:@"%@",[dictOwner valueForKey:@"rating"]];
                         lblDetails.text=[NSString stringWithFormat:@"%@",[dictOwner valueForKey:@"phone"]];
                         [self.imgUserProfile downloadFromURL:[dictOwner valueForKey:@"picture"] withPlaceholder:nil];
                         
                         [self.time invalidate];
                         [self.progtime invalidate];
                         [self.timerForCancelRequest invalidate];
                         [self hide];
                         [sound1Player stop];
                         [mapView_ clear];
                         [self performSegueWithIdentifier:@"segurtoarrived" sender:self];
                     }
                     else
                     {
                         if ([[response valueForKey:@"error_code"] integerValue]==406)
                         {
                             [self performSegueWithIdentifier:@"logout" sender:self];
                         }
                     }
                 }
                 
             }];
        }
        else
        {
            
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Internet", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(void)getPagesData
{
    if([APPDELEGATE connected])
    {
        NSMutableString *pageUrl=[NSMutableString stringWithFormat:@"%@?%@=%@",FILE_PAGES,PARAM_ID,strUserId];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:pageUrl withParamData:nil withBlock:^(id response, NSError *error)
         {
             
             NSLog(@"Page Data= %@",response);
             [APPDELEGATE hideLoadingView];
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     arrPage=[response valueForKey:@"informations"];
                 }
             }
             
         }];
        
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Internet", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)checkForCancelRequest
{
    if([CLLocationManager locationServicesEnabled])
    {
        if([APPDELEGATE connected])
        {
            if(((struser_lati==nil)&&(struser_longi==nil))
               ||(([struser_longi doubleValue]==0.00)&&([struser_lati doubleValue]==0)))
            {
            }
            else
            {
                strUserId = [PREF valueForKey:PARAM_ID];
                strUserToken = [PREF valueForKey:PARAM_TOKEN];
                
                NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
                [dictparam setObject:strUserId forKey:PARAM_ID];
                [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
                [dictparam setObject:struser_longi forKey:PARAM_LONGITUDE];
                [dictparam setObject:struser_lati forKey:PARAM_LATITUDE];
                [dictparam setObject:strRequsetId forKey:PARAM_REQUEST_ID];
                [dictparam setObject:@"0" forKey:PARAM_DISTANCE];
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_WALK_LOCATION withParamData:dictparam withBlock:^(id response, NSError *error)
                 {
                     
                     NSLog(@"Update Walk Location = %@",response);
                     if (response)
                     {
                         if([[response valueForKey:@"success"] intValue]==1)
                         {
                             
                         }
                         else
                         {
                             if ([[response valueForKey:@"error_code"] integerValue]==406)
                             {
                                 [self performSegueWithIdentifier:@"logout" sender:self];
                             }
                             else if ([[response valueForKey:@"is_cancelled"] integerValue]==1)
                             {
                                 
                                 [PREF removeObjectForKey:PREF_REQUEST_ID];
                                 [PREF removeObjectForKey:PREF_NAV];
                                 strRequsetId=[PREF valueForKey:PREF_REQUEST_ID];
                                 [PREF synchronize];
                                 
                                 [APPDELEGATE showToastMessage:NSLocalizedString(@"Request Canceled", nil) ];
                                 
                                 markerOwner.map = nil;
                                 [self showUserLoc];
                                 
                                 [self.timerForCancelRequest invalidate];
                                 [self.progtime invalidate];
                                 [self hide];
                                 
                                 [self.time invalidate];
                                 
                                 [self getAllRequests];
                                 NSRunLoop *runloop = [NSRunLoop currentRunLoop];
                                 self.time = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getAllRequests) userInfo:nil repeats:YES];
                                 [runloop addTimer:self.time forMode:NSRunLoopCommonModes];
                                 [runloop addTimer:self.time forMode:UITrackingRunLoopMode];
                                 
                                 
                             }
                         }
                     }
                     
                 }];
            }
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Internet", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView *alertLocation=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"Enable Location access", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertLocation.tag=100;
        [alertLocation show];
        
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -
#pragma mark - Draw Route Methods

- (NSMutableArray *)decodePolyLine: (NSMutableString *)encoded
{
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\" options:NSLiteralSearch range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len)
    {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do
        {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do
        {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        //printf("[%f,", [latitude doubleValue]);
        //printf("%f]", [longitude doubleValue]);
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:loc];
    }
    return array;
}

-(NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t
{
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
    
    NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];
    NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
    //NSLog(@"api url: %@", apiUrl);
    NSError* error = nil;
    NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSASCIIStringEncoding error:&error];
    NSString *encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
    return [self decodePolyLine:[encodedPoints mutableCopy]];
}

-(void) centerMap
{
    MKCoordinateRegion region;
    CLLocationDegrees maxLat = -90.0;
    CLLocationDegrees maxLon = -180.0;
    CLLocationDegrees minLat = 90.0;
    CLLocationDegrees minLon = 180.0;
    for(int idx = 0; idx < routes.count; idx++)
    {
        CLLocation* currentLocation = [routes objectAtIndex:idx];
        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }
    region.center.latitude     = (maxLat + minLat) / 2.0;
    region.center.longitude    = (maxLon + minLon) / 2.0;
    
    
    
    
    region.span.latitudeDelta  = ((maxLat - minLat)<0.0)?100.0:(maxLat - minLat);
    region.span.longitudeDelta = ((maxLon - minLon)<0.0)?100.0:(maxLon - minLon);
    
    region.span.latitudeDelta = 1.5;
    region.span.longitudeDelta = 1.5;
    
    //[self.mapView setRegion:region animated:YES];
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=region.center.latitude;
    coordinate.longitude=region.center.longitude;
    
    //GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude
    // longitude:coordinate.longitude
    //    zoom:6];
    //mapView_ = [GMSMapView mapWithFrame:CGRectMake(0,65,320,505) camera:camera];
    
    GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:coordinate zoom:15];
    
    [mapView_ animateWithCameraUpdate:updatedCamera];
}

-(void)centerMapFirst:(CLLocationCoordinate2D)pos1 two:(CLLocationCoordinate2D)pos2 third:(CLLocationCoordinate2D)pos3
{
    GMSCoordinateBounds* bounds =
    [[GMSCoordinateBounds alloc]initWithCoordinate:pos1 coordinate:pos2];
    bounds = [bounds includingCoordinate:pos3];
    
    CLLocationCoordinate2D location1 = bounds.southWest;
    CLLocationCoordinate2D location2 = bounds.northEast;
    
    float mapViewWidth = mapView_.frame.size.width;
    float mapViewHeight = mapView_.frame.size.height;
    
    MKMapPoint point1 = MKMapPointForCoordinate(location1);
    MKMapPoint point2 = MKMapPointForCoordinate(location2);
    
    MKMapPoint centrePoint = MKMapPointMake(
                                            (point1.x + point2.x) / 2,
                                            (point1.y + point2.y) / 2);
    CLLocationCoordinate2D centreLocation = MKCoordinateForMapPoint(centrePoint);
    
    double mapScaleWidth = mapViewWidth / fabs(point2.x - point1.x);
    double mapScaleHeight = mapViewHeight / fabs(point2.y - point1.y);
    double mapScale = MIN(mapScaleWidth, mapScaleHeight);
    
    double zoomLevel = 19.1 + log2(mapScale);
    
    //    GMSCameraPosition *camera = [GMSCameraPosition
    //                                 cameraWithLatitude: centreLocation.latitude
    //                                 longitude: centreLocation.longitude
    //                                 zoom: zoomLevel];
    GMSCameraUpdate *updatedCamera = [GMSCameraUpdate setTarget:centreLocation zoom: zoomLevel];
    
    [mapView_ animateWithCameraUpdate:updatedCamera];
}

-(void) showRouteFrom:(CLLocationCoordinate2D)f to:(CLLocationCoordinate2D)t

{
    if(routes)
    {
        [mapView_ clear];
    }
    
    
    markerOwner = [[GMSMarker alloc] init];
    markerOwner.position = f;
    markerOwner.icon = [UIImage imageNamed:@"pin_client_org"];
    markerOwner.map = mapView_;
    
    GMSMarker *markerDriver = [[GMSMarker alloc] init];
    markerDriver.position = f;
    markerDriver.icon = [UIImage imageNamed:@"pin_driver"];
    markerDriver.map = mapView_;
    
    routes = [self calculateRoutesFrom:f to:t];
    NSInteger numberOfSteps = routes.count;
    
    
    GMSMutablePath *pathpoliline=[GMSMutablePath path];
    
    CLLocationCoordinate2D coordinates[numberOfSteps];
    for (NSInteger index = 0; index < numberOfSteps; index++)
    {
        CLLocation *location = [routes objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        coordinates[index] = coordinate;
        [pathpoliline addCoordinate:coordinate];
    }
    GMSPolyline *polyLinePath = [GMSPolyline polylineWithPath:pathpoliline];
    
    polyLinePath.strokeColor = [UIColor blueColor];
    polyLinePath.strokeWidth = 5.f;
    polyLinePath.geodesic = YES;
    polyLinePath.map = mapView_;
    [self centerMap];
}




#pragma mark-
#pragma mark MKPolyline delegate functions

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor blueColor];
    polylineView.lineWidth = 5.0;
    return polylineView;
}

#pragma mark-
#pragma mark- MapView delegate
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    
    MKAnnotationView *annot=[[MKAnnotationView alloc] init];
    
    SBMapAnnotation *temp=(SBMapAnnotation*)annotation;
    if (temp.yTag==1000)
    {
        annot.image=[UIImage imageNamed:@"pin_driver"];
    }
    if (temp.yTag==1001)
    {
        annot.image=[UIImage imageNamed:@"pin_client_org"];
        
    }
    return annot;
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    
}

#pragma mark-
#pragma mark- Get Location

-(void)getUserLocation
{
    [locationManager startUpdatingLocation];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    
#ifdef __IPHONE_8_0
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        // Use one or the other, not both. Depending on what you put in info.plist
        [locationManager requestAlwaysAuthorization];
        //[locationManager requestAlwaysAuthorization];
    }
#endif
    
    [locationManager startUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        struser_lati=[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude];
        struser_longi=[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude];
    }
    
    
    
    marker.map=nil;
    CLLocationCoordinate2D current;
    current.latitude=[struser_lati doubleValue];
    current.longitude=[struser_longi doubleValue];
    
    mapView_.myLocationEnabled = NO;
    mapView_.delegate=self;
    marker = [[GMSMarker alloc] init];
    marker.position = current;
    marker.icon = [UIImage imageNamed:@"pin_driver"];
    marker.map = mapView_;
    
}

#pragma mark-
#pragma mark- Alert Button Clicked Event

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==100)
    {
        if (buttonIndex == 0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
    
    
}

#pragma mark -
#pragma mark - Google Api method for Calculate Estimate time and distance

-(NSArray*) calculateEstimatedTimeAndDistance:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t
{
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
    
    //NSString* apiUrlStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&key=%@",saddr,daddr,strForGoogleMapKey];
	 NSString* apiUrlStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@",saddr,daddr];
    
    NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
    NSLog(@"url :%@",apiUrl);
    
    NSError* error = nil;
    NSData *data = [[NSData alloc]initWithContentsOfURL:apiUrl];
    
    NSDictionary *json =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"get json :%@ and source :%@ destination :%@",json,saddr,daddr);
    
    if ([[json objectForKey:@"status"]isEqualToString:@"REQUEST_DENIED"] || [[json objectForKey:@"status"] isEqualToString:@"OVER_QUERY_LIMIT"] || [[json objectForKey:@"status"] isEqualToString:@"ZERO_RESULTS"]|| [[json objectForKey:@"status"] isEqualToString:@"NOT_FOUND"])
    {
        
    }
    else
    {
	
		GMSPath *path =[GMSPath pathFromEncodedPath:json[@"routes"][0][@"overview_polyline"][@"points"]];
		GMSPolyline *polyLinePath = [GMSPolyline polylineWithPath:path];
		polyLinePath.strokeColor = [UIColor colorWithRed:(27.0f/255.0f) green:(151.0f/255.0f) blue:(200.0f/255.0f) alpha:1.0];
		polyLinePath.strokeWidth = 5.f;
		polyLinePath.geodesic = YES;
		polyLinePath.map = mapView_;
	
		routes = json[@"routes"];
	
		NSString *points=[[[routes objectAtIndex:0] objectForKey:@"overview_polyline"] objectForKey:@"points"];
	
        NSDictionary *getRoutes = [json valueForKey:@"routes"];
        NSDictionary *getLegs = [getRoutes valueForKey:@"legs"];
        NSArray *getAddress = [getLegs valueForKey:@"duration"];
        NSArray *getDistance = [getLegs valueForKey:@"distance"];
        
        NSString *strDistance = [[[getDistance objectAtIndex:0]objectAtIndex:0] valueForKey:@"value"];
        
        // NSArray *time=[strDistance  componentsSeparatedByString:@" "];
        // NSString *strDistanceValue = [time objectAtIndex:0];
        // NSString *strDistanceUnit = [time objectAtIndex:1];
        
        if(getAddress.count>0)
        {
            NSString *strETA = [[[getAddress objectAtIndex:0]objectAtIndex:0] valueForKey:@"text"];
            
            if([strEstDistanceUnit isEqualToString:@"kms"])
            {
                self.lblEstDistance.text=[NSString stringWithFormat:@"%.2f %@",[strDistance floatValue]/1000, strEstDistanceUnit];
                
                self.lblEstTime.text=[NSString stringWithFormat:@"%@",strETA];
            }
            else
            {
                self.lblEstDistance.text=[NSString stringWithFormat:@"%.2f %@",[strDistance floatValue]/1609.34,strEstDistanceUnit];
                self.lblEstTime.text=[NSString stringWithFormat:@"%@",strETA];
            }
            
            // self.lblEstDistance.text=[NSString stringWithFormat:@"%@",strDistance];
            // self.lblEstTime.text=[NSString stringWithFormat:@"%@",strETA];
        }
        else
        {
            self.lblEstDistance.text=[NSString stringWithFormat:@"%.2f",0.0,NSLocalizedString(@"kms", nil)];
            self.lblEstTime.text=[NSString stringWithFormat:@"%d %@.",0,NSLocalizedString(@"Min", nil)];
        }
    }
    return nil;
}
#pragma mark-
#pragma mark- Button Click Events


- (IBAction)onClickSetEta:(id)sender
{
    
    
}

- (IBAction)onClickReject:(id)sender
{
    if ([APPDELEGATE connected])
    {
        strRequsetId=[PREF objectForKey:PREF_REQUEST_ID];
        
        if (strRequsetId!=nil)
        {
            [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"PLEASE_WAIT", nil)];
            NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
            
            [dictparam setObject:strRequsetId forKey:PARAM_REQUEST_ID];
            [dictparam setObject:strUserId forKey:PARAM_ID];
            [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
            [dictparam setObject:@"0" forKey:PARAM_ACCEPTED];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_RESPOND_REQUEST withParamData:dictparam withBlock:^(id response, NSError *error)
             {
                 
                 NSLog(@"Respond to Request= %@",response);
                 [APPDELEGATE hideLoadingView];
                 if (response)
                 {
                     if([[response valueForKey:@"success"] intValue]==1)
                     {
                         
                         [APPDELEGATE showToastMessage:NSLocalizedString(@"REQUEST_REJECTED", nil)];
                         
                         
                         [PREF removeObjectForKey:PREF_REQUEST_ID];
                         strRequsetId=[PREF valueForKey:PREF_REQUEST_ID];
                         
                         [mapView_ clear];
                         
                         CLLocationCoordinate2D current;
                         current.latitude=[struser_lati doubleValue];
                         current.longitude=[struser_longi doubleValue];
                         
                         marker = [[GMSMarker alloc] init];
                         marker.position = current;
                         marker.icon = [UIImage imageNamed:@"pin_driver"];
                         marker.map = mapView_;
                         
                         [self.progtime invalidate];
                         [self.timerForCancelRequest invalidate];
                         [self hide];
                         [self showUserLoc];
                         
                         NSRunLoop *runloop = [NSRunLoop currentRunLoop];
                         self.time = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getAllRequests) userInfo:nil repeats:YES];
                         [runloop addTimer:self.time forMode:NSRunLoopCommonModes];
                         [runloop addTimer:self.time forMode:UITrackingRunLoopMode];
                     }
                     else
                     {
                         if ([[response valueForKey:@"error_code"] integerValue]==406)
                         {
                             [self performSegueWithIdentifier:@"logout" sender:self];
                         }
                         else
                         {
                             NSString *str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[afn getErrorMessage:str] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                             [alert show];
                         }
                         
                         //[APPDELEGATE showToastMessage:[response valueForKey:@"error"]];
                     }
                 }
                 
             }];
        }
        else
        {
            
        }
    }
    
}

- (IBAction)onClickAccept:(id)sender
{
    
    [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"WAITING_ADMIN_APPROVE", nil)];
    [self.progtime invalidate];

    [self respondToRequset];
    //[self performSegueWithIdentifier:@"segurtoarrived" sender:self];
    
    //[self.etaView setHidden:NO];
}

- (IBAction)onClickNoKey:(id)sender
{
    [self.etaView setHidden:YES];
}

- (IBAction)pickMeBtnPressed:(id)sender
{
    [self showUserLoc];
}


-(void)goToSetting:(NSString *)str
{
    [self performSegueWithIdentifier:str sender:self];
}

-(void)invalidateTimer
{
    [self.timer invalidate];
    [self.time invalidate];
}



#pragma mark-
#pragma mark- Progress Bar Method


-(void)customProgressBar
{
    progressView.hidden=YES;
    float t=(time/60.0f);
    lblTime.text=[NSString stringWithFormat:@"%d",time];
    //self.lblTime.font=[UberStyleGuide fontRegular:48.0f];
    self.lblTime.font=[UIFont fontWithName:@"OpenSans" size:30.0f];
    if(time<5)
    {
        progressView.color = [UIColor colorWithRed:245.0f/255.0f green:25.0f/255.0f blue:42.0f/255.0f alpha:1.0];
    }
    else
    {
        progressView.color = [UIColor colorWithRed:0.0f/255.0f green:186.0f/255.0f blue:214.0f/255.0f alpha:1.0];
    }
    
    
    progressView.background = [UIColor colorWithRed:122.0f/255.0f green:122.0f/255.0f blue:122.0f/255.0f alpha:1.0];
    progressView.showText = @NO;
    progressView.progress = t;
    progressView.borderRadius = @NO;
    progressView.animate = @NO;
    progressView.type = LDProgressSolid;
    time=time-1;
    
    //if(time<15)
    //{
        
        if ([[PREF valueForKey:@"SOUND"] isEqualToString:@"on"])
        {
            [self PlaySound];
            [sound1Player play];
        }
    //}
    if(time<0)
    {
        [self.progtime invalidate];
        [self.timerForCancelRequest invalidate];
        [self hide];
        [sound1Player stop];
        
        [self.time invalidate];
        
        [PREF removeObjectForKey:PREF_REQUEST_ID];
        strRequsetId=[PREF valueForKey:PREF_REQUEST_ID];
        
        
        [self getAllRequests];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        self.time = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getAllRequests) userInfo:nil repeats:YES];
        [runloop addTimer:self.time forMode:NSRunLoopCommonModes];
        [runloop addTimer:self.time forMode:UITrackingRunLoopMode];
        
        [mapView_ clear];
        
        CLLocationCoordinate2D current;
        current.latitude=[struser_lati doubleValue];
        current.longitude=[struser_longi doubleValue];
        
        
        marker = [[GMSMarker alloc] init];
        marker.position = current;
        marker.icon = [UIImage imageNamed:@"pin_driver"];
        marker.map = mapView_;
        [self showUserLoc];
        
    }
    
}

#pragma mark-
#pragma mark - Sound Player
-(void)PlaySound
{
    
    [sound1Player stop];
    
    NSString *bk=[NSString stringWithFormat:@"beep-07"];
    NSString *path = [[NSBundle mainBundle] pathForResource:bk ofType:@"mp3"];
    NSURL *url=[NSURL fileURLWithPath:path];
    
    sound1Player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    if(!sound1Player)
    {
        NSLog(@"error");
    }
    
    sound1Player.delegate=self;
    sound1Player.numberOfLoops=0;
    [sound1Player stop];
}

#pragma mark-
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"contact us"])
    {
        ContactVC *obj=[segue destinationViewController];
        obj.dictContact=sender;
    }
    
}


- (IBAction)onClickClose:(id)sender
{
    exit(0);
    //[self performSegueWithIdentifier:@"segueToMain" sender:nil];
    
}



#pragma -mark
#pragma mark getStatus
-(void)checkState
{
    if([APPDELEGATE connected])
    {
        
        strUserId = [PREF objectForKey:@"id"];
        strUserToken = [PREF objectForKey:@"token"];
        NSMutableString *pageUrl=[NSMutableString stringWithFormat:@"%@?%@=%@&%@=%@",FILE_CHECKSTATUS,PARAM_ID,strUserId,PARAM_TOKEN,strUserToken];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:pageUrl withParamData:nil withBlock:^(id response, NSError *error)
         {
             NSLog(@"History Data= %@",response);
             
             if (response)
             {
                 [APPDELEGATE hideLoadingView];
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     if([[response valueForKey:@"is_active"] intValue]==1)
                     {
                         [self.btnGoOnline setTitle:NSLocalizedString(@"GO_OFFLINE", nil) forState:UIControlStateNormal];
                         
                         [self.imgbg setHidden:YES];
                         [self.imgOnline setHidden:YES];
						[self.lblGoOnline setHidden:YES];
						[self.viewForGoOffline setHidden:YES];
                         
                     }
                     else
                     {
                         [self.btnGoOnline setTitle:NSLocalizedString(@"GO_ONLINE", nil) forState:UIControlStateNormal];
                         if (self.viewForNotApproved.isHidden)
                         {
                             [self.imgbg setHidden:NO];
                             [self.imgOnline setHidden:NO];
							[self.lblGoOnline setHidden:NO];
							[self.viewForGoOffline setHidden:NO];
                         }
                     }
                 }
                 else
                 {
                     if ([[response valueForKey:@"error_code"] integerValue]==406)
                     {
                         [self performSegueWithIdentifier:@"logout" sender:self];
                     }
                 }
             }
         }];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Internet", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma -mark
#pragma mark setStatus on server

-(void)setStatus
{
    if([APPDELEGATE connected])
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"CHANGING AVAILABILITY", nil)];
        NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
        
        [dictparam setObject:strUserId forKey:PARAM_ID];
        [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_TOGGLE withParamData:dictparam withBlock:^(id response, NSError *error)
         {
             
             NSLog(@"Request in Progress= %@",response);
             if (response)
             {
                 [APPDELEGATE hideLoadingView];
                 if([[response valueForKey:@"success"]intValue]==1)
                 {
                     if ([[response valueForKey:@"is_active"] boolValue])
                     {
                         [self.btnGoOnline setTitle:NSLocalizedString(@"GO_OFFLINE", nil) forState:UIControlStateNormal];
                         
                         [self.imgbg setHidden:YES];
                         [self.imgOnline setHidden:YES];
					 [self.lblGoOnline setHidden:YES];
						[self.viewForGoOffline setHidden:YES];
                     }
                     else
                     {
                         [self.btnGoOnline setTitle:NSLocalizedString(@"GO_ONLINE", nil) forState:UIControlStateNormal];
                         [self.imgbg setHidden:NO];
                         [self.imgOnline setHidden:NO];
					 [self.lblGoOnline setHidden:NO];
						[self.viewForGoOffline setHidden:NO];
                         
                     }
                     [APPDELEGATE showToastMessage:NSLocalizedString(@"AVAILABILITY_UODATE", nil)];
                 }
                 else
                 {
                     if ([[response valueForKey:@"error_code"] integerValue]==406)
                     {
                         [self performSegueWithIdentifier:@"logout" sender:self];
                     }
                 }
             }
             else
             {
                 [APPDELEGATE hideLoadingView];
             }
             
         }];
    }
}


#pragma mark
#pragma mark click Go Online Button

- (IBAction)clickGoOnline:(id)sender
{
    /*
     UIButton *b  = sender;
     if ([b.titleLabel.text isEqualToString:NSLocalizedString(@"GO_OFFLINE", nil)])
     {
     
     [self.btnGoOnline setTitle:NSLocalizedString(@"GO_ONLINE", nil) forState:UIControlStateNormal];
     [self.imgbg setHidden:NO];
     [self.imgOnline setHidden:NO];
     }
     else
     {
     [self.btnGoOnline setTitle:NSLocalizedString(@"GO_OFFLINE", nil) forState:UIControlStateNormal];
     
     [self.imgbg setHidden:YES];
     [self.imgOnline setHidden:YES];
     
     }
     */
    [self setStatus];
}

@end
