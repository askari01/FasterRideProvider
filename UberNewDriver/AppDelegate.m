//
//  AppDelegate.m
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.

#import "AppDelegate.h"
#import "SignInVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleMaps/GoogleMaps.h>

@implementation AppDelegate
{
    MBProgressHUD *HUD;
}
@synthesize viewLoading;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[GMSServices provideAPIKey:GOOGLE_KEY];
	
	[self registerForRemoteNotifications];
	
    [[FBSDKApplicationDelegate sharedInstance] application:application
    didFinishLaunchingWithOptions:launchOptions];

    [GIDSignIn sharedInstance].clientID = GOOGLE_PLUS_CLIENT_ID;
    [GIDSignIn sharedInstance].delegate = self;

    // Override point for customization after application launch.
    //[[Mint sharedInstance] initAndStartSessionWithAPIKey:@"9aac4e2b"];
    
    return YES;
}

- (void)userLoggedIn
{
    // Set the button title as "Log out"
    
    SignInVC *obj=[[SignInVC alloc]init];
    UIButton *loginButton = obj.btnFacebook;
    [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
    
    // Welcome message
    // [self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
}
- (void)registerForRemoteNotifications
{
	if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
		UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
		center.delegate = self;
		[center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
			if(!error){
				[[UIApplication sharedApplication] registerForRemoteNotifications];
			}
		}];
	}
	else {
		if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
			{
				UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
																									 |UIRemoteNotificationTypeSound
																								 |UIRemoteNotificationTypeAlert) categories:nil];
			[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
			}
		else
			{
			//register to receive notifications
			UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
			[[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
			}
	}
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

//foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
	NSLog(@"User Info : %@",notification.request.content.userInfo);
	completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
	NSLog(@"User Info : %@",response.notification.request.content.userInfo);
	completionHandler();
}
#pragma mark -
#pragma mark - GPPDeepLinkDelegate


- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication annotation: (id)annotation
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"google"]==YES)
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }
    else
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options
{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"google"]==YES)
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    else
    {
        return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                              openURL:url
                                                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                           annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    UIApplication *app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier bgTask = 0;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
	if(viewLoading!=nil)
		{
		[viewLoading removeFromSuperview];
		viewLoading = nil;
		NSString *str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"LoadingTitle"]];
		[self hideLoadingView];
		[self showLoadingWithTitle:str];
		}
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark-
#pragma mark- AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==200)
    {
        if (buttonIndex==0)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:@"en"] forKey:@"AppleLanguages"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:@"es"] forKey:@"AppleLanguages"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        [APPDELEGATE showToastMessage:@"Please restart your application to change language"];
    }
    
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark - Directory Path Methods

- (NSString *)applicationCacheDirectoryString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return cacheDirectory;
}


#pragma mark-
#pragma mark- Handle Push Method

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

//For interactive notification only
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken: %@", deviceToken);
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    device_token=dt;

    if(dt==nil)
    {
        device_token=@"r11";
    }
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Token " message:dt delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
	//[alert show];
    NSLog(@"My token is: %@", dt);
    
    [PREF setObject:device_token forKey:PREF_DEVICE_TOKEN];
    [PREF synchronize];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"My token is error: %@", error);
    if (device_token==nil)
    {
        device_token=@"11111";
    }
    
    [PREF setObject:device_token forKey:PREF_DEVICE_TOKEN];
    [PREF synchronize];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSMutableDictionary *aps=[userInfo valueForKey:@"aps"];
    NSMutableDictionary *msg=[aps valueForKey:@"request_data"];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",msg] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
    //[alert show];
}
-(void)handleRemoteNitification:(UIApplication *)application userInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *aps=[userInfo valueForKey:@"aps"];
    NSMutableDictionary *msg=[aps valueForKey:@"request_data"];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",msg] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
    //[alert show];
}

#pragma mark-
#pragma mark- Indicator Delegate
-(void) showHUDLoadingView:(NSString *)strTitle
{
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:HUD];
    //HUD.delegate = self;
    //HUD.labelText = [strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    HUD.detailsLabelText=[strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    [HUD show:YES];
}

-(void) hideHUDLoadingView
{
    [HUD removeFromSuperview];
    [HUD setHidden:YES];
    [HUD show:NO];
}

-(void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window
                                              animated:YES];
    
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.detailsLabelText = message;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:0.5];
}

#pragma mark -
#pragma mark - Loading View

-(void)showLoadingWithTitle:(NSString *)title{
    if (viewLoading==nil)
{
	[[NSUserDefaults standardUserDefaults]setValue:title forKey:@"LoadingTitle"];
        viewLoading=[[UIView alloc]initWithFrame:self.window.bounds];
        viewLoading.backgroundColor = [UIColor clearColor];
        UIImageView *imgs=[[UIImageView alloc] initWithFrame:self.window.bounds];
        //mgs.image=[UIImage imageNamed:@"bg_loding"];
		[imgs setBackgroundColor:ProfileViewColor];
        imgs.alpha=0.90;
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((viewLoading.frame.size.width/2)-(viewLoading.frame.size.width/4),(viewLoading.frame.size.height/2)-(viewLoading.frame.size.height/4),(viewLoading.frame.size.width/3),(viewLoading.frame.size.height/3))];
        
        UIImageView *imgCar = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Car_loading"]];
        
        imgCar.center=viewLoading.center;
        img.center=viewLoading.center;
        img.backgroundColor=[UIColor clearColor];
        img.contentMode=UIViewContentModeCenter;
        img.image=[UIImage imageNamed:@"loading_ring"];
        img.animationDuration = 1.0f;
        img.animationRepeatCount = 0;
        [viewLoading addSubview:imgs];
        [viewLoading addSubview:img];
        [viewLoading addSubview:imgCar];
        [img startAnimating];
        UITextView *txt=[[UITextView alloc]initWithFrame:CGRectMake(viewLoading.frame.origin.x+20, (viewLoading.frame.origin.y+viewLoading.frame.size.height - 170), viewLoading.frame.size.width-40, 60)];
        txt.textAlignment=NSTextAlignmentCenter;
        txt.backgroundColor=[UIColor clearColor];
        txt.text=[title uppercaseString];
        txt.font=[UIFont fontWithName:@"Arial" size:17];
        txt.alpha=0.9;
        txt.userInteractionEnabled=FALSE;
        txt.scrollEnabled=FALSE;
        txt.textColor=[UIColor whiteColor];
        [viewLoading addSubview:txt];
        img.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
        [UIView animateWithDuration:0.6 delay:0 options: UIViewAnimationOptionAutoreverse| UIViewAnimationOptionRepeat| UIViewAnimationOptionCurveEaseOut animations:^{
            // animate it to the identity transform (100% scale)
            
            CGAffineTransform scaleTrans = CGAffineTransformMakeScale(1.0f, 1.0f);
            img.transform = scaleTrans;
        } completion:^(BOOL finished){
            
        }];
    }
    
    [self.window addSubview:viewLoading];
    [self.window bringSubviewToFront:viewLoading];
}
-(void)hideLoadingView
{
    if (viewLoading) {
        [viewLoading removeFromSuperview];
        viewLoading=nil;
    }
}

#pragma mark-
#pragma mark- Test Internet

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return (networkStatus != NotReachable);
}

#pragma mark -
#pragma mark - sharedAppDelegate

+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark-
#pragma mark- Font Descriptor

-(id)setBoldFontDiscriptor:(id)objc
{
    if([objc isKindOfClass:[UIButton class]])
    {
        UIButton *button=objc;
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return button;
    }
    else if([objc isKindOfClass:[UITextField class]])
    {
        UITextField *textField=objc;
        textField.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return textField;
    }
    else if([objc isKindOfClass:[UILabel class]])
    {
        UILabel *lable=objc;
        lable.font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0f];
        return lable;
    }
    return objc;
}

@end
/*
 -(id)setBoldFontDiscriptor:(id)objc
 {
 if([objc isKindOfClass:[UIButton class]])
 {
 UIButton *button=objc;
 button.titleLabel.font=[UberStyleGuide fontRegularBold:13.0f];
 UIFontDescriptor * fontD = [button.font.fontDescriptor
 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold
 ];
 button.font = [UIFont fontWithDescriptor:fontD size:10.0f];
 return button;
 }
 else if([objc isKindOfClass:[UITextField class]])
 {
 UITextField *textField=objc;
 textField.font=[UberStyleGuide fontRegularBold];
 UIFontDescriptor * fontD = [textField.font.fontDescriptor
 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold
 ];
 textField.font = [UIFont fontWithDescriptor:fontD size:0];
 return textField;
  }
 else if([objc isKindOfClass:[UILabel class]])
 {
 UILabel *lable=objc;
 lable.font=[UberStyleGuide fontRegularBold];
 UIFontDescriptor * fontD = [lable.font.fontDescriptor
 fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold
 ];
 lable.font = [UIFont fontWithDescriptor:fontD size:0];
 return lable;
 
 
 }
 return objc;
 }
 */
