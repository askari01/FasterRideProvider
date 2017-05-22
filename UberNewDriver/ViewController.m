//
//  ViewController.m
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()
{
    CLLocationManager *locationManager;
    
    BOOL internet;
    BOOL IS_LOGIN;
    NSMutableDictionary *dictparam;
    NSMutableString * strEmail;
    NSMutableString * strPassword;
    NSMutableString * strLogin;
    NSMutableString * strSocialId;
}

@end

@implementation ViewController

#pragma mark -
#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"SIGN_IN", nil)];

	[self.btnRegister setBackgroundColor:DarkBtnColor];
	[self.btnSignIn setBackgroundColor:LightBtnColor];
	[self.btnOK setBackgroundColor:DarkBtnColor];
	[self.viewForSplashBG setBackgroundColor:ProfileViewColor];

    [self GetGoolePlusKeys];
    self.lblCopyrights.text = NSLocalizedString(@"COPYRIGHTS_NOTE", nil);
    [self.btnSignIn setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
    [self.btnSignIn setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateSelected];
    [self.btnRegister setTitle:NSLocalizedString(@"REGISTER", nil) forState:UIControlStateNormal];
    [self.btnRegister setTitle:NSLocalizedString(@"REGISTER", nil) forState:UIControlStateSelected];
    
    internet=[APPDELEGATE connected];
    if ([CLLocationManager locationServicesEnabled])
    {
        if([APPDELEGATE connected])
            [self getUserLocation];
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
        
    self.viewNote.frame = self.view.frame;
    self.lblImpNote.text = NSLocalizedString(@"IMPORTANT_NOTE", nil);
    self.txtNote.text = NSLocalizedString(@"IMPORTANT_NOTE_TEXT", nil);
    [self.btnOK setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    
   // [APPDELEGATE.window addSubview:self.viewNote];
}

-(void)viewWillAppear:(BOOL)animated
{
    dictparam=[[NSMutableDictionary alloc]init];
    
    IS_LOGIN=[PREF boolForKey:PREF_IS_LOGIN];
    
    if(IS_LOGIN)
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"SIGN_IN", nil)];
        
        strEmail=[PREF objectForKey:PREF_EMAIL];
        strPassword=[PREF objectForKey:PREF_PASSWORD];
        strLogin=[PREF objectForKey:PREF_LOGIN_BY];
        strSocialId=[PREF objectForKey:PREF_SOCIAL_ID];
        device_token=[PREF objectForKey:PREF_DEVICE_TOKEN];
        [self getSignIn];
        
    }
    else
    {
        self.navigationController.navigationBarHidden=YES;
    }
    
    // self.navigationController.navigationBarHidden=YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    IS_LOGIN=[PREF boolForKey:PREF_IS_LOGIN];
    
    if(!IS_LOGIN)
        [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)GetGoolePlusKeys
{
    if([APPDELEGATE connected])
    {
        NSMutableString *url=[NSMutableString stringWithFormat:@"%@",FILE_GET_GOOGLE_KEYS];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:url withParamData:nil withBlock:^(id response, NSError *error)
         {
             NSLog(@"Keys = %@",response);
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                     
                     dict = [response valueForKey:@"provider"];
                     strForGooglePlusClientId = [dict valueForKey:@"Google_Client_id"];
                     strForGooglePlusClientSecret = [dict valueForKey:@"Google_Client_secret"];
                     strForGoogleMapKey = [dict valueForKey:@"Google_Map_key"];
                     [PREF setValue:strForGoogleMapKey forKey:@"Google_Map_key"];
                     [PREF setValue:strForGooglePlusClientId forKey:@"Google_Client_id"];
                     [PREF setValue:strForGooglePlusClientSecret forKey:@"Google_Client_secret"];
                     [PREF synchronize];
                     [GMSServices provideAPIKey:strForGoogleMapKey];
				 [APPDELEGATE hideLoadingView];
                 }
             }
         }];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet" message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Sign In

-(void)getSignIn
{
    if (strSocialId==nil)
    {
        strEmail=[PREF objectForKey:PREF_EMAIL];
        strPassword=[PREF objectForKey:PREF_PASSWORD];
        strLogin=[PREF objectForKey:PREF_LOGIN_BY];
        strSocialId=[PREF objectForKey:PREF_SOCIAL_ID];
    }
    if([APPDELEGATE connected])
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
        
        [dictparam setObject:device_token forKey:PARAM_DEVICE_TOKEN];
        [dictparam setObject:@"ios" forKey:PARAM_DEVICE_TYPE];
        [dictparam setObject:strEmail forKey:PARAM_EMAIL];
        
        [dictparam setObject:strLogin forKey:PARAM_LOGIN_BY];
        if (![strLogin isEqualToString:@"manual"])
        {
            [dictparam setObject:strSocialId forKey:PARAM_SOCIAL_ID];
            
        }
        else
        {
            [dictparam setObject:strPassword forKey:PARAM_PASSWORD];
        }
        
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_LOGIN withParamData:dictparam withBlock:^(id response, NSError *error)
         {
             
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     arrUser=response;
                     
                     [PREF setObject:[response valueForKey:@"token"] forKey:PREF_USER_TOKEN];
                     [PREF setObject:[response valueForKey:@"id"] forKey:PREF_USER_ID];
                     [PREF setObject:[response valueForKey:@"is_approved"] forKey:PREF_IS_APPROVED];
                     [PREF synchronize];
                     
                     strForGooglePlusClientId = [PREF valueForKey:@"Google_Client_id"];
                     strForGooglePlusClientSecret = [PREF valueForKey:@"Google_Client_secret"];
                     strForGoogleMapKey = [PREF valueForKey:@"Google_Map_key"];
                     [GMSServices provideAPIKey:strForGoogleMapKey];
                     
                     [APPDELEGATE hideLoadingView];
                     [APPDELEGATE showToastMessage:(NSLocalizedString(@"SIGING_SUCCESS", nil))];
                     [self performSegueWithIdentifier:@"segueToDirectLogin" sender:self];
                 }
                 else
                 {
                     [APPDELEGATE hideLoadingView];
                     
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"SIGNIN_FAILED", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                     [alert show];
                 }
             }
             
             //  [APPDELEGATE hideLoadingView];
             NSLog(@"REGISTER RESPONSE --> %@",response);
         }];
        
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Internet", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    
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
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil)
    {
        struser_lati=[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.latitude];//[NSString stringWithFormat:@"%.8f",22.30];//
        struser_longi=[NSString stringWithFormat:@"%.8f",currentLocation.coordinate.longitude];//[NSString stringWithFormat:@"%.8f",70.78];//
    }
    
    
    // stop updating location in order to save battery power
    [locationManager stopUpdatingLocation];
    
    
    // Reverse Geocoding
    // NSLog(@"Resolving the Address");
    
    // “reverseGeocodeLocation” method to translate the locate data into a human-readable address.
    
    // The reason for using "completionHandler" ----
    //  Instead of using delegate to provide feedback, the CLGeocoder uses “block” to deal with the response. By using block, you do not need to write a separate method. Just provide the code inline to execute after the geocoding call completes.
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         // NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         if (error == nil && [placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks lastObject];
             
             // strAdd -> take bydefault value nil
             NSString *strAdd = nil;
             
             if ([placemark.subThoroughfare length] != 0)
                 strAdd = placemark.subThoroughfare;
             
             if ([placemark.thoroughfare length] != 0)
             {
                 // strAdd -> store value of current location
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark thoroughfare]];
                 else
                 {
                     // strAdd -> store only this value,which is not null
                     strAdd = placemark.thoroughfare;
                 }
             }
             
             if ([placemark.postalCode length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark postalCode]];
                 else
                     strAdd = placemark.postalCode;
             }
             
             if ([placemark.locality length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark locality]];
                 else
                     strAdd = placemark.locality;
             }
             
             if ([placemark.administrativeArea length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark administrativeArea]];
                 else
                     strAdd = placemark.administrativeArea;
             }
             
             if ([placemark.country length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark country]];
                 else
                     strAdd = placemark.country;
                 
             }
             
         }
     }];
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


- (IBAction)onClickRegister:(id)sender
{
    [self performSegueWithIdentifier:@"segueToRegister" sender:self];
}
-(IBAction)onClickOK:(id)sender
{
    [self.viewNote removeFromSuperview];
}


-(IBAction)onUnwindForLogout:(UIStoryboardSegue*)segueIdentifire
{
    [PREF removeObjectForKey:PARAM_REQUEST_ID];
    [PREF removeObjectForKey:PARAM_SOCIAL_ID];
    [PREF removeObjectForKey:PREF_EMAIL];
    [PREF removeObjectForKey:PREF_LOGIN_BY];
    [PREF removeObjectForKey:PREF_PASSWORD];
    [PREF removeObjectForKey:PREF_USER_ID];
    [PREF removeObjectForKey:PREF_USER_TOKEN];
    [PREF setBool:NO forKey:PREF_IS_LOGIN];
    [PREF setObject:@"" forKey:PREF_USER_ID];
    [PREF setObject:@"" forKey:PREF_USER_TOKEN];
    [PREF synchronize];
    
    FBSDKLoginManager *logout = [[FBSDKLoginManager alloc] init];
    [logout logOut];
}
@end
