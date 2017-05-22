//
//  LoginVC.m
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "LoginVC.h"
#import "UIImageView+Download.h"
#import "AppDelegate.h"
#import "GoogleUtility.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

static NSString *const kKeychainItemName = @"Google OAuth2 For gglplustest";
static NSString *const kClientID = GOOGLE_PLUS_CLIENT_ID;
//static NSString *const kClientSecret = @"";

@interface LoginVC ()
{
    AppDelegate *appDelegate;
    BOOL internet,isFacebookClicked;
    NSMutableArray *arrForCountry;
    NSMutableDictionary *dictparam;
    
    NSString * strEmail;
    NSString * strPassword;
    NSString * strLogin;
    NSString * strSocialId,*strForEmail;
    int reTrive;
}

@end

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark - View Life Cycle

@synthesize txtPassword,txtEmail;

- (void)viewDidLoad
{
    reTrive=0;
    [super viewDidLoad];
    isFacebookClicked=NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.btnSignIn setBackgroundColor:LightBtnColor];
	[self.btnBack setBackgroundColor:DarkBtnColor];
	[self.viewForSplashBG setBackgroundColor:ProfileViewColor];
    //[super setBackBarItem];
    //NSLog(@"fonts: %@", [UIFont familyNames]);
    
    //txtEmail.text=@"nirav.kotecha99@gmail.com";
    //txtPassword.text=@"123456";
    dictparam=[[NSMutableDictionary alloc]init];
    
    strEmail=[PREF objectForKey:PREF_EMAIL];
    strPassword=[PREF objectForKey:PREF_PASSWORD];
    strLogin=[PREF objectForKey:PREF_LOGIN_BY];
    strSocialId=[PREF objectForKey:PREF_SOCIAL_ID];
    
    internet=[APPDELEGATE connected];
    
    if(strEmail!=nil)
    {
        [self getSignIn];
    }
    
    [self customFont];
    
    [self.btnSignIn setTitle:NSLocalizedString(@"SIGN IN", nil) forState:UIControlStateNormal];
    [self.btnForgotPsw setTitle:NSLocalizedString(@"FORGOT_PASSWORD", nil) forState:UIControlStateNormal];
    //[self.btnSignUp setTitle:NSLocalizedString(@"SIGN_UP", nil) forState:UIControlStateNormal];
    self.txtEmail.placeholder = NSLocalizedString(@"ENTER_EMAIL", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"ENTER_PASSWORD", nil);
    self.lblSignInWih.text = NSLocalizedString(@"SIGN IN WITH", nil);
    self.lblUsername.text = NSLocalizedString(@"USERNAME", nil);
    self.lblPassword.text = NSLocalizedString(@"PASSWORD", nil);
    [self.btnDontHaveAccount setTitle:NSLocalizedString(@"don't account register", nil) forState:UIControlStateNormal];
    [self.btnDontHaveAccount setTitle:NSLocalizedString(@"don't account register", nil) forState:UIControlStateSelected];
    [self.btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
    [self.btnBack setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateSelected];

    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGestureLogin:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    //self.txtEmail.placeholder
    
    // Do any additional setup after loading the view.
    
    // Listen for keyboard appearances and disappearances
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    [self.scrLogin setContentSize:CGSizeMake(self.view.frame.size.width , self.view.frame.size.height)];
}

-(void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES];
    FBSDKLoginManager *logout = [[FBSDKLoginManager alloc] init];
    [logout logOut];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.btnSignUp setTitle:NSLocalizedString(@"SIGN UP", nil) forState:UIControlStateNormal];
}

-(void)handleSingleTapGestureLogin:(UITapGestureRecognizer *)tapGestureRecognizer;
{
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    
    CGPoint offset;
    offset=CGPointMake(0, 0);
    [self.scrLogin setContentOffset:offset animated:YES];
}

-(void)customFont
{
    UIColor *color = [UIColor whiteColor];
    
    self.txtEmail.font=[UberStyleGuide fontRegularLight];
    self.txtPassword.font=[UberStyleGuide fontRegularLight];
    self.lblOr.font=[UberStyleGuide fontRegularLight];
    self.lblSignInWih.font=[UberStyleGuide fontRegularLight];
    self.btnSignIn.titleLabel.font = [UberStyleGuide fontRegularLight];

    self.txtPassword.textColor = [UberStyleGuide fontColor];
    self.txtEmail.textColor = [UberStyleGuide fontColor];
    self.lblUsername.textColor = [UberStyleGuide fontColor];
    self.lblOr.textColor = [UberStyleGuide fontColor];
    self.lblSignInWih.textColor = [UberStyleGuide fontColor];
    
    [self.btnForgotPsw setTitleColor:[UberStyleGuide fontColor] forState:UIControlStateNormal];
    [self.btnSignIn setTitleColor:[UberStyleGuide fontColor] forState:UIControlStateNormal];
    [self.btnSignUp setTitleColor:[UberStyleGuide fontColor] forState:UIControlStateNormal];
    
    UIFont *font = [UberStyleGuide fontRegularLight];
    [self.txtEmail setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtEmail setValue:font forKeyPath:@"_placeholderLabel.font"];
    [self.txtPassword setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPassword setValue:font forKeyPath:@"_placeholderLabel.font"];
    
    self.btnForgotPsw.titleLabel.font = [UberStyleGuide fontRegularBold];
    /*self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Emaillll;" attributes:@{
     NSForegroundColorAttributeName: color,
     NSFontAttributeName : font
     }];
     */

    /*
     self.btnSignIn=[APPDELEGATE setBoldFontDiscriptor:self.btnSignIn];
     self.btnForgotPsw=[APPDELEGATE setBoldFontDiscriptor:self.btnForgotPsw];
     self.btnSignUp=[APPDELEGATE setBoldFontDiscriptor:self.btnSignUp];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - keyboard Did Show

- (void)keyboardDidShow: (NSNotification *) notif
{
    // Do something here
    
    //[self.scrLogin setFrame:CGRectMake(self.scrLogin.frame.origin.x,(self.view.frame.size.height-self.scrLogin.frame.size.height )-60, self.scrLogin.frame.size.width, self.scrLogin.frame.size.height)];
    
}

#pragma mark -
#pragma mark - keyboard Did Hide

- (void)keyboardDidHide: (NSNotification *) notif
{
    //[self.scrLogin setFrame:CGRectMake(self.scrLogin.frame.origin.x,(self.view.frame.size.height-self.scrLogin.frame.size.height ), self.scrLogin.frame.size.width, self.scrLogin.frame.size.height)];
    
    // Do something here
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
#pragma mark - Sign In

-(void)getSignIn
{
    if (device_token==nil || [device_token isEqualToString:@""] || [device_token isKindOfClass:[NSNull class]] || device_token.length < 1)
    {
        device_token=@"11111";
    }
    if (strEmail==nil)
    {
        strEmail=[PREF objectForKey:PREF_EMAIL];
        strPassword=[PREF objectForKey:PREF_PASSWORD];
        strLogin=[PREF objectForKey:PREF_LOGIN_BY];
        strSocialId=[PREF objectForKey:PREF_SOCIAL_ID];
    }
    if([APPDELEGATE connected] && self.txtEmail.text.length > 1)
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
        
        [dictparam setObject:device_token forKey:PARAM_DEVICE_TOKEN];
        [dictparam setObject:@"ios" forKey:PARAM_DEVICE_TYPE];
        [dictparam setObject:self.txtEmail.text forKey:PARAM_EMAIL];
        
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
                     [PREF setObject:[NSString stringWithFormat:@"%@",device_token] forKey:PREF_DEVICE_TOKEN];
                     
                     [PREF setObject:strEmail forKey:PREF_EMAIL];
                     [PREF setObject:txtPassword.text forKey:PREF_PASSWORD];
                    
                     [PREF setObject:strLogin forKey:PREF_LOGIN_BY];
                    
                     
                     [PREF setBool:YES forKey:PREF_IS_LOGIN];
                     
                     [PREF setObject:[response valueForKey:@"is_approved"] forKey:PREF_IS_APPROVED];
                     
                     [PREF synchronize];
                     
                     txtPassword.userInteractionEnabled=YES;
                     [APPDELEGATE hideLoadingView];
                     [APPDELEGATE showToastMessage:(NSLocalizedString(@"SIGING_SUCCESS", nil))];
                     isFacebookClicked = NO;
                     [self performSegueWithIdentifier:@"seguetopickme" sender:self];
                     //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"REGISTER_SUCCESS", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                     //            [alert show];
                 }
                 else
                 {
					[PREF setBool:NO forKey:PREF_IS_LOGIN];
					[PREF removeObjectForKey:PREF_EMAIL];
					[PREF removeObjectForKey:PREF_PASSWORD];
					[PREF removeObjectForKey:PREF_SOCIAL_ID];
					[PREF removeObjectForKey:PREF_LOGIN_BY];
					txtPassword.userInteractionEnabled=YES;
					txtEmail.userInteractionEnabled=YES;
				 
					txtEmail.text = @"";
					txtPassword.text = @"";
					strLogin=@"manual";
				 
                     if([[response valueForKey:@"error"] intValue]==12)
                     {
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Driver is not a registered." delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                         [alert show];
                     }
                     else
                     {
                     NSString *str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[afn getErrorMessage:str] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                     [alert show];
                     }
                 }
             }
             [APPDELEGATE hideLoadingView];
             NSLog(@"REGISTER RESPONSE --> %@",response);
         }];
    }
    else
    {
        if(self.txtEmail.text.length < 1)
        {
            if([strLogin isEqualToString:@"facebook"])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"We are unable to fetch Email ID, Please Enter Email ID" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:NSLocalizedString(@"PLEASE_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet" message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

#pragma mark -
#pragma mark - Button Action

- (IBAction)onClickSignIn:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    strEmail=self.txtEmail.text;
    strPassword=self.txtPassword.text;
    
    if ([strLogin isEqualToString:@"facebook"] || [strLogin isEqualToString:@"google"])
    {
        
    }
    else
    {
        strLogin = @"manual";
    }
    
    
   /* if(isFacebookClicked == YES)
        strLogin=@"facebook";
    else
        strLogin=@"manual";*/
    
    /* NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
     [pref setObject:txtEmail.text forKey:PREF_EMAIL];
     [pref setObject:txtPassword.text forKey:PREF_PASSWORD];
     [pref setObject:@"manual" forKey:PREF_LOGIN_BY];
     [pref setBool:YES forKey:PREF_IS_LOGIN];
     [pref synchronize];
     */
    [self getSignIn];
}

- (IBAction)googleBtnPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"google"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //[[GIDSignIn sharedInstance] signIn];
    [[GoogleUtility sharedObject]signInGoogle:^(BOOL success, GIDGoogleUser* user, NSError* error)
     {
         if (success)
         {
             //[dictparam setObject:user.userID forKey:PARAM_SOCIAL_ID];
             strLogin=@"google";
             strForEmail=user.profile.email;
             self.txtEmail.text = strForEmail;
             self.txtPassword.userInteractionEnabled = NO;
             strSocialId = [NSString stringWithFormat:@"%@",user.userID];
             [appDelegate showLoadingWithTitle:NSLocalizedString(@"ALREADY_LOGIN", nil)];
             [self onClickSignIn:nil];
         }
     }withParent:self];
    
}


- (IBAction)facebookBtnPressed:(id)sender
{
    /*[[FacebookUtility sharedObject] logOutFromFacebook];
    
    [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"PLEASE_WAIT", nil)];
    if([APPDELEGATE connected])
    {
        if (![[FacebookUtility sharedObject]isLogin])
        {
            [[FacebookUtility sharedObject]loginInFacebook:^(BOOL success, NSError *error)
             {
                 [APPDELEGATE hideLoadingView];
                 if (success)
                 {
                     NSLog(@"Success");
                     appDelegate = [UIApplication sharedApplication].delegate;
                     [appDelegate userLoggedIn];
                     [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error)
                      {
                          if (response)
                          {
                              isFacebookClicked=YES;
                              NSLog(@"%@",response);
                              self.txtEmail.text=[response valueForKey:@"email"];
                              txtPassword.userInteractionEnabled=NO;
                              txtPassword.text=@"";
                              [PREF setObject:[response valueForKey:@"email"] forKey:PREF_EMAIL];
                              [PREF setObject:@"facebook" forKey:PREF_LOGIN_BY];
                              [PREF setObject:[response valueForKey:@"id"] forKey:PREF_SOCIAL_ID];
                              [PREF setBool:YES forKey:PREF_IS_LOGIN];
                              [PREF synchronize];
                              [self getSignIn];
                          }
                      }];
                 }
             }];
        }
        else
        {
            NSLog(@"User Login Click");
            appDelegate = [UIApplication sharedApplication].delegate;
            [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error) {
                [APPDELEGATE hideLoadingView];
                
                if (response) {
                    NSLog(@"%@",response);
                    NSLog(@"%@",response);
                    self.txtEmail.text=[response valueForKey:@"email"];
                    txtPassword.userInteractionEnabled=NO;
                    
                    [PREF setObject:[response valueForKey:@"email"] forKey:PREF_EMAIL];
                    [PREF setObject:@"facebook" forKey:PREF_LOGIN_BY];
                    [PREF setObject:[response valueForKey:@"id"] forKey:PREF_SOCIAL_ID];
                    [PREF setBool:YES forKey:PREF_IS_LOGIN];
                    [PREF synchronize];
                    [self getSignIn];
                    
                }
            }];
            
            [appDelegate userLoggedIn];
            
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Internet", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }*/
	[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"google"];
	
    if ([APPDELEGATE connected])
    {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager
         logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled){
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 [APPDELEGATE showLoadingWithTitle:@"Please wait"];
                 
                 if ([FBSDKAccessToken currentAccessToken])
                 {
                     FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                   initWithGraphPath:@"me"
                                                   parameters:@{@"fields": @"first_name, last_name, picture.type(large), email, name, id, gender"}
                                                   HTTPMethod:@"GET"];
                     [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                           id result,
                                                           NSError *error)
                      {
                          // Handle the result
                          [APPDELEGATE hideLoadingView];
                          isFacebookClicked=YES;
                          self.txtPassword.userInteractionEnabled=NO;
                          NSLog(@"FB Response ->%@",result);
                          self.txtEmail.text=[result valueForKey:@"email"];
                          
                          strEmail = self.txtEmail.text;
                          strSocialId =[result valueForKey:@"id"];
                          strLogin =@"facebook";
                          
                        /*  [PREF setObject:[result valueForKey:@"email"] forKey:PREF_EMAIL];
                          [PREF setObject:@"facebook" forKey:PREF_LOGIN_BY];
                          [PREF setObject:[result valueForKey:@"id"] forKey:PREF_SOCIAL_ID];
                          [PREF setBool:YES forKey:PREF_IS_LOGIN];
                          [PREF synchronize];*/
                          [self getSignIn];
                      }];
                 }
             }
         }];
        
        [loginManager logOut];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"NO_INTERNET_TITLE", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

- (IBAction)forgotBtnPressed:(id)sender
{
    
}

- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int y=60;
    if (textField==self.txtEmail)
    {
        y=60;
    }
    else if (textField==self.txtPassword){
        y=120;
    }
    [self.scrLogin setContentOffset:CGPointMake(0, y) animated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.txtEmail)
    {
        if(txtPassword.userInteractionEnabled==NO)
        {
            [textField resignFirstResponder];
            [self.scrLogin setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else
            [self.txtPassword becomeFirstResponder];
    }
    else if (textField==self.txtPassword){
        [textField resignFirstResponder];
        [self.scrLogin setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}

/*
 #pragma mark-
 #pragma mark- Text Field Delegate
 
 - (BOOL)textFieldShouldReturn:(UITextField *)textField     //Hide the keypad when we pressed return
 {
 if (textField==txtEmail)
 {
 [self.txtPassword becomeFirstResponder];
 }
 
 [textField resignFirstResponder];
 return YES;
 }
 
 - (void)textFieldDidBeginEditing:(UITextField *)textField
 
 {
 if(textField == self.txtPassword)
 {
 UITextPosition *beginning = [self.txtPassword beginningOfDocument];
 [self.txtPassword setSelectedTextRange:[self.txtPassword textRangeFromPosition:beginning
 toPosition:beginning]];
 [UIView animateWithDuration:0.3 animations:^{
 
 self.view.frame = CGRectMake(0, -35, 320, 480);
 
 } completion:^(BOOL finished) { }];
 }
 }
 - (void)textFieldDidEndEditing:(UITextField *)textField
 {
 UIDevice *thisDevice=[UIDevice currentDevice];
 if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
 {
 CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
 
 if (iOSDeviceScreenSize.height == 568)
 {
 if(textField == self.txtPassword)
 {
 [UIView animateWithDuration:0.3 animations:^{
 
 self.view.frame = CGRectMake(0, 0, 320, 568);
 
 } completion:^(BOOL finished) { }];
 }
 
 }
 else
 {
 
 if(textField == self.txtPassword)
 {
 [UIView animateWithDuration:0.3 animations:^{
 
 self.view.frame = CGRectMake(0, 0, 320, 480);
 
 } completion:^(BOOL finished) { }];
 }
 
 
 }
 }
 }
 */


@end
