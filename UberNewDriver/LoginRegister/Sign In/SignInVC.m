//
//  SignInVC.m
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "SignInVC.h"
#import "AppDelegate.h"
#import "UIImageView+Download.h"
#import "CarTypeCell.h"
#import "UtilityClass.h"
#import "UIView+Utils.h"
#import "GoogleUtility.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

static NSString *const kKeychainItemName = @"Google OAuth2 For gglplustest";
static NSString *const kClientID = GOOGLE_PLUS_CLIENT_ID;
//static NSString *const kClientSecret = @"";

@interface SignInVC ()
{
    AppDelegate *appDelegate;
    BOOL internet,isProPicAdded;
    NSMutableArray *arrForCountry;
    NSMutableDictionary *dictparam;
    NSMutableArray *arrType;
    NSMutableString *strTypeId;
    NSString *countryCode;
   
}

@end

@implementation SignInVC

@synthesize txtEmail,txtFirstName,txtLastName,txtPassword,txtAddress,txtBio,txtZipcode,txtNumber,imgType,txtType,pickTypeView,typePicker,typeCollectionView,txtTaxiNumber,txtTaxiModel,txtRePassword;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[super setBackBarItem];
	[self.btnRegister setBackgroundColor:DarkBtnColor];
	[self.viewForbg setBackgroundColor:ProfileViewColor];
	[self.btnSelectService setBackgroundColor:LightBtnColor];

    isProPicAdded=NO;
    internet=[APPDELEGATE connected];
    
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(0, 972)];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:singleTapGestureRecognizer];

    arrForCountry=[[NSMutableArray alloc]init];
    dictparam=[[NSMutableDictionary alloc]init];
    
    [self.btnCheck setBackgroundImage:[UIImage imageNamed:@"cb_glossy_off.png"] forState:UIControlStateNormal];
    self.btnRegister.enabled=FALSE;
    txtType.userInteractionEnabled=NO;
    [self customFont];
    
    [self.btnAgreeCondtion setTitle:NSLocalizedString(@"I agree to the terms and conditions", nil) forState:UIControlStateNormal];
    
    //[self.btnRegister setTitle:NSLocalizedString(@"REGISTER", nil) forState:UIControlStateNormal];
    
    [self.btnSelectService setTitle:NSLocalizedString(@"SELECT YOUR VEHICLE", nil) forState:UIControlStateNormal];

    [self localizeString];
    
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if (device_token==nil || [device_token isEqualToString:@""] || [device_token isKindOfClass:[NSNull class]] || device_token.length < 1)
    {
        device_token=@"11111";
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    arrType=[[NSMutableArray alloc]init];
    [self getType];
    pickTypeView.hidden=YES;
    self.viewForPicker.hidden=YES;
    [self.imgProPic applyRoundedCornersFull];
    [super viewWillAppear:animated];
    
    self.lblCarModelInfo.hidden=YES;
    self.imgCarModelInfo.hidden=YES;
    self.lblCarNumberInfo.hidden=YES;
    self.imgCarNumberInfo.hidden=YES;
    self.lblEmailInfo.hidden=YES;
    self.imgEmailInfo.hidden=YES;
    self.lblInfo.hidden=YES;
    self.imgInfo.hidden=YES;
    
    FBSDKLoginManager *logout = [[FBSDKLoginManager alloc] init];
    [logout logOut];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
    [self.btnNav_Register setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark-
#pragma mark- Custom Font

-(void)customFont
{
    //self.txtTaxiNumber.font=[UberStyleGuide fontRegular];
    
    self.txtFirstName.font=[UberStyleGuide fontRegular];
    self.txtLastName.font=[UberStyleGuide fontRegular];
    self.txtEmail.font=[UberStyleGuide fontRegular];
    self.txtPassword.font=[UberStyleGuide fontRegular];
    self.txtRePassword.font=[UberStyleGuide fontRegular];
    self.txtNumber.font = [UberStyleGuide fontRegular];
    self.txtAddress.font=[UberStyleGuide fontRegular];
    self.txtBio.font=[UberStyleGuide fontRegular];
    self.txtZipcode.font=[UberStyleGuide fontRegular];
    self.txtTaxiModel.font=[UberStyleGuide fontRegular];
    self.txtTaxiNumber.font=[UberStyleGuide fontRegular];
    
    //font color
//    self.txtFirstName.textColor=[UberStyleGuide fontColor];
//    self.txtLastName.textColor=[UberStyleGuide fontColor];
//    self.txtEmail.textColor=[UberStyleGuide fontColor];
//    self.txtPassword.textColor=[UberStyleGuide fontColor];
//    self.txtRePassword.textColor=[UberStyleGuide fontColor];
//    self.txtNumber.textColor=[UberStyleGuide fontColor];
//    self.txtAddress.textColor=[UberStyleGuide fontColor];
//    self.txtBio.textColor=[UberStyleGuide fontColor];
//    self.txtZipcode.textColor=[UberStyleGuide fontColor];
//    self.txtTaxiModel.textColor=[UberStyleGuide fontColor];
//    self.txtTaxiNumber.textColor=[UberStyleGuide fontColor];
    
   // UIColor *color = [UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
    
    UIFont *font = [UberStyleGuide fontRegularLight];
    //[self.txtEmail setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtEmail setValue:font forKeyPath:@"_placeholderLabel.font"];
   // [self.txtPassword setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPassword setValue:font forKeyPath:@"_placeholderLabel.font"];
   // [self.txtAddress setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtAddress setValue:font forKeyPath:@"_placeholderLabel.font"];
    //[self.txtBio setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtBio setValue:font forKeyPath:@"_placeholderLabel.font"];
    //[self.txtFirstName setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtFirstName setValue:font forKeyPath:@"_placeholderLabel.font"];
    //[self.txtLastName setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtLastName setValue:font forKeyPath:@"_placeholderLabel.font"];
   // [self.txtNumber setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtNumber setValue:font forKeyPath:@"_placeholderLabel.font"];
    //[self.txtTaxiModel setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtTaxiModel setValue:font forKeyPath:@"_placeholderLabel.font"];
    //[self.txtTaxiNumber setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtTaxiNumber setValue:font forKeyPath:@"_placeholderLabel.font"];
   // [self.txtType setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtType setValue:font forKeyPath:@"_placeholderLabel.font"];
   // [self.txtZipcode setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtZipcode setValue:font forKeyPath:@"_placeholderLabel.font"];
    
    self.btnNav_Register.titleLabel.font = [UberStyleGuide fontRegularLight];
    self.btnRegister.titleLabel.font = [UberStyleGuide fontRegularLight];
    self.btnSelectService.titleLabel.font=[UberStyleGuide fontRegularLight];
    /*
    self.btnNav_Register=[APPDELEGATE setBoldFontDiscriptor:self.btnNav_Register];
    self.btnRegister=[APPDELEGATE setBoldFontDiscriptor:self.btnRegister];
     */
}

-(void)localizeString
{
    self.txtEmail.placeholder = NSLocalizedString(@"EMAIL", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"PASSWORD", nil);
    self.txtRePassword.placeholder = NSLocalizedString(@"CONFIRM PASSWORD", nil);
    self.txtFirstName.placeholder = NSLocalizedString(@"FIRST NAME", nil);
    self.txtLastName.placeholder = NSLocalizedString(@"LAST NAME", nil);
    self.txtBio.placeholder = NSLocalizedString(@"BIO", nil);
    self.txtNumber.placeholder = NSLocalizedString(@"NUMBER", nil);
    self.txtType.placeholder = NSLocalizedString(@"TYPE", nil);
    self.txtZipcode.placeholder = NSLocalizedString(@"ZIPCODE", nil);
    self.txtAddress.placeholder = NSLocalizedString(@"ADDRESS", nil);
    self.txtTaxiModel.placeholder = NSLocalizedString(@"TAXI MODEL", nil);
    self.txtTaxiNumber.placeholder = NSLocalizedString(@"TAXI NUMBER", nil);
    [self.btnRegisterTitle setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [self.btnRegisterTitle setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateSelected];
    self.lblInfo.text = NSLocalizedString(@"INFO", nil);
    self.lblEmailInfo.text = NSLocalizedString(@"INFO_EMAIL", nil);
    self.lblCarNumberInfo.text = NSLocalizedString(@"INFO_TAXI_NUMBER", nil);
    self.lblCarModelInfo.text = NSLocalizedString(@"INFO_TAXI_MODEL", nil);

    self.lblRegisterWith.text = NSLocalizedString(@"Register With", nil);
    self.lblFirstName.text = NSLocalizedString(@"FIRST NAME", nil);
    self.lblLastName.text = NSLocalizedString(@"LAST NAME", nil);
    self.lblEmail.text = NSLocalizedString(@"EMAIL", nil);
    self.lblPassword.text = NSLocalizedString(@"PASSWORD", nil);
    self.lblNumber.text = NSLocalizedString(@"NUMBER", nil);
    self.lblUploadPictureFrom.text = NSLocalizedString(@"Upload Picture From", nil);
    self.lblAddress.text = NSLocalizedString(@"ADDRESS", nil);
    self.lblBio.text = NSLocalizedString(@"BIO", nil);
    self.lblZipcode.text = NSLocalizedString(@"ZIPCODE", nil);
    self.lblTaxiModel.text = NSLocalizedString(@"TAXI MODEL", nil);
    self.lblTaxiNumber.text = NSLocalizedString(@"TAXI NUMBER", nil);
}

#pragma mark -
#pragma mark - UIButton Action

- (IBAction)faceBookBtnPressed:(id)sender
{
	[[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"google"];

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
                     [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error) {
                         if (response) {
                             NSLog(@"%@",response);
                             self.txtEmail.text=[response valueForKey:@"email"];
                             NSArray *arr=[[response valueForKey:@"name"] componentsSeparatedByString:@" "];
                             txtPassword.userInteractionEnabled=NO;
                             txtRePassword.userInteractionEnabled=NO;
                             
                             self.txtFirstName.text=[arr objectAtIndex:0];
                             self.txtLastName.text=[arr objectAtIndex:1];
                             [dictparam setObject:@"facebook" forKey:PARAM_LOGIN_BY];
                             [dictparam setObject:[response valueForKey:@"id"] forKey:PARAM_SOCIAL_ID];
                             [self.imgProPic downloadFromURL:[response valueForKey:@"link"] withPlaceholder:nil];
                             NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [response objectForKey:@"id"]];
                             [self.imgProPic downloadFromURL:userImageURL withPlaceholder:nil];
                             isProPicAdded=YES;
                         }
                     }];
                 }
             }];
        }
        else{
            [APPDELEGATE hideLoadingView];
            NSLog(@"User Login Click");
            appDelegate = [UIApplication sharedApplication].delegate;
            [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error) {
                if (response) {
                    NSLog(@"%@",response);
                    self.txtEmail.text=[response valueForKey:@"email"];
                    NSArray *arr=[[response valueForKey:@"name"] componentsSeparatedByString:@" "];
                    self.txtFirstName.text=[arr objectAtIndex:0];
                    self.txtLastName.text=[arr objectAtIndex:1];
                    [self.imgProPic downloadFromURL:[response valueForKey:@"link"] withPlaceholder:nil];
                    NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [response objectForKey:@"id"]];
                    [self.imgProPic downloadFromURL:userImageURL withPlaceholder:nil];
                    isProPicAdded=YES;
                    
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
                          self.txtPassword.userInteractionEnabled=NO;
                          NSLog(@"FB Response ->%@",result);
                          [dictparam setObject:@"facebook" forKey:PARAM_LOGIN_BY];
                          [dictparam setObject:[result valueForKey:@"id"] forKey:PARAM_SOCIAL_ID];
                          self.txtEmail.text=[result valueForKey:@"email"];
                          NSArray *arr=[[result valueForKey:@"name"] componentsSeparatedByString:@" "];
                          self.txtFirstName.text=[arr objectAtIndex:0];
                          self.txtLastName.text=[arr objectAtIndex:1];

                          [self.imgProPic downloadFromURL:[result valueForKey:@"link"] withPlaceholder:nil];
                          self.viewWithoutPassword.frame = CGRectMake(self.viewWithoutPassword.frame.origin.x, self.viewForPassword.frame.origin.y, self.viewWithoutPassword.frame.size.width, self.viewWithoutPassword.frame.size.height);
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

- (IBAction)selectCountryBtnPressed:(id)sender
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countrycodes" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    arrForCountry = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    self.pickerView.tag=100;
    //typePicker.tag=0;
    [self.pickerView reloadAllComponents];
    self.viewForPicker.hidden=NO;
    pickTypeView.hidden=YES;
    [self handleSingleTapGesture:nil];

}

- (IBAction)googleBtnPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"google"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
    [[GoogleUtility sharedObject]signInGoogle:^(BOOL success, GIDGoogleUser* user, NSError* error)
     {
         if (success)
         {
             // self.navigationController.navigationBarHidden = NO;
             self.txtPassword.userInteractionEnabled=NO;
             [dictparam setObject:user.userID forKey:PARAM_SOCIAL_ID];
             
            //strForSocialId=user.userID;
             self.txtEmail.text=user.profile.email;
             NSArray *strname = [user.profile.name componentsSeparatedByString: @" "];
             self.txtFirstName.text=[strname objectAtIndex:0];
             self.txtLastName.text=[strname objectAtIndex:1];
             [dictparam setObject:@"google" forKey:PARAM_LOGIN_BY];
             //strForRegistrationType = @"google";
             //strForRegistrationType=GOOGLE;
             if (user.profile.hasImage)
             {
                 //self.imgProPic.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[user.profile imageURLWithDimension:100]]]?:[UIImage imageNamed:@"user"];
                 
                 NSString *strPicture = [user.profile imageURLWithDimension:100].absoluteString;
                 [self.imgProPic downloadFromURL:strPicture withPlaceholder:nil];
                 
                 
                 isProPicAdded= YES;
             }
             //  [[NSUserDefaults  standardUserDefaults] setBool:YES forKey:GOOGLE];
             
         }
         [APPDELEGATE hideLoadingView];
     } withParent:self];

}
- (IBAction)doneBtnPressed:(id)sender
{
    [self.btnCountryCode setTitle:countryCode forState:UIControlStateNormal];
    self.viewForPicker.hidden=YES;
}

- (IBAction)cancelBtnPressed:(id)sender
{
     self.viewForPicker.hidden=YES;
}

- (IBAction)saveBtnPressed:(id)sender
{
    if([APPDELEGATE connected])
    {
        if(self.txtFirstName.text.length<1 || (![[UtilityClass sharedObject]isValidEmailAddress:self.txtEmail.text]) || self.txtLastName.text.length<1 || self.txtEmail.text.length<1 || self.txtNumber.text.length<1 || self.txtNumber.text.length<10 || strTypeId==nil || self.txtTaxiModel.text.length<1 || self.txtTaxiNumber.text.length<1)
        {
            
            if(self.txtFirstName.text.length<1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_FIRST_NAME", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else if (![[UtilityClass sharedObject]isValidEmailAddress:self.txtEmail.text])
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_VALID_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else if(self.txtLastName.text.length<1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_LAST_NAME", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else if(self.txtEmail.text.length<1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else if(self.txtNumber.text.length<1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_NUMBER", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else if(self.txtNumber.text.length<10)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_NUMBER_MIN", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
            else if(self.txtTaxiModel.text.length<1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_TAXI_MODEL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }

            else if(self.txtTaxiNumber.text.length<1)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_TAXI_NUMBER", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }

            
            else if(strTypeId==nil)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"Please Select Service Type", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:NSLocalizedString(@"Cancel", nil), nil];
                alert.tag=200;
                [alert show];
            }
        }
        else
        {
            if([[UtilityClass sharedObject]isValidEmailAddress:self.txtEmail.text])
            {
                NSString *strnumber=[NSString stringWithFormat:@"%@%@",self.btnCountryCode.titleLabel.text,txtNumber.text];
                
                [dictparam setObject:txtFirstName.text forKey:PARAM_FIRST_NAME];
                [dictparam setObject:txtLastName.text forKey:PARAM_LAST_NAME];
                [dictparam setObject:txtEmail.text forKey:PARAM_EMAIL];
                [dictparam setObject:strnumber forKey:PARAM_PHONE];
                [dictparam setObject:txtPassword.text forKey:PARAM_PASSWORD];
                [dictparam setObject:txtAddress.text forKey:PARAM_ADDRESS];
                [dictparam setObject:txtBio.text forKey:PARAM_BIO];
                [dictparam setObject:txtZipcode.text forKey:PARAM_ZIPCODE];
                [dictparam setObject:device_token forKey:PARAM_DEVICE_TOKEN];
                [dictparam setObject:@"ios" forKey:PARAM_DEVICE_TYPE];
                [dictparam setObject:strTypeId forKey:PARAM_WALKER_TYPE];
                [dictparam setObject:txtTaxiModel.text forKey:PARAM_TAXI_MODEL];
                [dictparam setObject:txtTaxiNumber.text forKey:PARAM_TAXI_NUMBER];
                
                [dictparam setObject:@"" forKey:PARAM_COUNTRY];
                [dictparam setObject:@"" forKey:PARAM_STATE];
                
                [dictparam setObject:@"" forKey:PARAM_PICTURE];
                
                if([dictparam valueForKey:PARAM_SOCIAL_ID]==nil)
                {
                    [dictparam setObject:@"manual" forKey:PARAM_LOGIN_BY];
                    [dictparam setObject:@"" forKey:PARAM_SOCIAL_ID];
                }
                [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"PLEASE_WAIT", nil)];
                UIImage *imgUpload = [[UtilityClass sharedObject]scaleAndRotateImage:self.imgProPic.image];
                
                NSLog(@"Registeration parameter :%@",dictparam);
                
                if (isProPicAdded==NO)
                {
                    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                    [afn getDataFromPath:FILE_REGISTER withParamData:dictparam withBlock:^(id response, NSError *error)
                     {
                         [APPDELEGATE hideLoadingView];
                         if (response)
                         {
                             if([[response valueForKey:@"success"] intValue]==1)
                             {
                                 txtPassword.userInteractionEnabled=YES;
                                 txtRePassword.userInteractionEnabled=YES;
                                 [APPDELEGATE showToastMessage:(NSLocalizedString(@"REGISTER_SUCCESS", nil))];
                                 arrUser=response;
                                 [self.navigationController popToRootViewControllerAnimated:YES];
                                 //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"REGISTER_SUCCESS", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                                 //            [alert show];
                             }
                             else
                             {
                              
                                 
                                 NSString *str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[afn getErrorMessage:str] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                                 [alert show];
                                 /*
                                 NSMutableArray *err=[[NSMutableArray alloc]init];
                                 err=[response valueForKey:@"error_messages"];
                                 if (err.count==0)
                                 {
                                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Fail" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                                     [alert show];
                                 }
                                 else
                                 {
                                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Fail" message:[NSString stringWithFormat:@"%@",[err objectAtIndex:0]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                                     [alert show];
                                 }*/
                                 
                                 
                             }
                         }
                         
                         NSLog(@"REGISTER RESPONSE --> %@",response);
                     }];
                }
                else
                {
                    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                    [afn getDataFromPath:FILE_REGISTER withParamDataImage:dictparam andImage:imgUpload withBlock:^(id response, NSError *error)
                     {
                         
                         [APPDELEGATE hideLoadingView];
                         if (response)
                         {
                             if([[response valueForKey:@"success"] intValue]==1)
                             {
                                 txtPassword.userInteractionEnabled=YES;
                                 txtRePassword.userInteractionEnabled=YES;
                                 [APPDELEGATE showToastMessage:(NSLocalizedString(@"REGISTER_SUCCESS", nil))];
                                 arrUser=response;
                                 [self.navigationController popToRootViewControllerAnimated:YES];
                                 //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"REGISTER_SUCCESS", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                                 //            [alert show];
                             }
                             else
                             {
                                 NSString *str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[afn getErrorMessage:str] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                                 [alert show];
                                 /*
                                 NSMutableArray *err=[[NSMutableArray alloc]init];
                                 err=[response valueForKey:@"error_messages"];
                                 if (err.count==0)
                                 {
                                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Fail" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                                     [alert show];
                                 }
                                 else
                                 {
                                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Fail" message:[NSString stringWithFormat:@"%@",[err objectAtIndex:0]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                                     [alert show];
                                 }*/
                                 
                                 
                             }
                         }
                         
                         NSLog(@"REGISTER RESPONSE --> %@",response);
                     }];
                }

            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Fail" message:NSLocalizedString(@"PLEASE_VALID_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"No Internet", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)imgPickBtnPressed:(id)sender
{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:Nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Take Photo", nil) ,NSLocalizedString(@"Select Image", nil) , nil];
    action.tag=10001;
    [action showInView:self.view];

}

- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)termsBtnPressed:(id)sender
{
    [self performSegueWithIdentifier:@"pushToTerms" sender:self];
}

- (IBAction)checkBtnPressed:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if(btn.tag == 0)
    {
        btn.tag=1;
        [btn setBackgroundImage:[UIImage imageNamed:@"cb_glossy_on.png"] forState:UIControlStateNormal];
        
        self.btnRegister.enabled=TRUE;
        
    }
    else
    {
        btn.tag=0;
        [btn setBackgroundImage:[UIImage imageNamed:@"cb_glossy_off.png"] forState:UIControlStateNormal];
        self.btnRegister.enabled=FALSE;
    }
}

- (IBAction)selectServiceBtnPressed:(id)sender
{
    UIDevice *thisDevice=[UIDevice currentDevice];
    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        float closeY=(iOSDeviceScreenSize.height-self.btnSelectService.frame.size.height-self.btnRegister.frame.size.height);
        
        float openY=closeY-(self.bottomView.frame.size.height-self.btnSelectService.frame.size.height-self.btnRegister.frame.size.height)-30.0f;
        if (self.bottomView.frame.origin.y==closeY)
        {
            [UIView animateWithDuration:0.5 animations:^{
                
                self.bottomView.frame=CGRectMake(0, openY, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                
            } completion:^(BOOL finished)
             {
             }];
        }
        else
        {
            [UIView animateWithDuration:0.5 animations:^{
                
                self.bottomView.frame=CGRectMake(0, closeY, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                
            } completion:^(BOOL finished)
             {
             }];
        }
        
    }
    
    
}

#pragma mark - Info Button Actions

- (IBAction)onClickCarModelInfo:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if (btn.tag==0)
    {
        btn.tag=1;
        self.lblCarModelInfo.hidden=NO;
        self.imgCarModelInfo.hidden=NO;
    }
    else
    {
        btn.tag=0;
        self.lblCarModelInfo.hidden=YES;
        self.imgCarModelInfo.hidden=YES;
    }
}

- (IBAction)onClickCarNumberInfo:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if (btn.tag==0)
    {
        btn.tag=1;
        self.lblCarNumberInfo.hidden=NO;
        self.imgCarNumberInfo.hidden=NO;
    }
    else
    {
        btn.tag=0;
        self.lblCarNumberInfo.hidden=YES;
        self.imgCarNumberInfo.hidden=YES;
    }

}

- (IBAction)onClickEmailInfo:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if (btn.tag==0)
    {
        btn.tag=1;
        self.lblEmailInfo.hidden=NO;
        self.imgEmailInfo.hidden=NO;
    }
    else
    {
        btn.tag=0;
        self.lblEmailInfo.hidden=YES;
        self.imgEmailInfo.hidden=YES;
    }

}

- (IBAction)onClickInfo:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if (btn.tag==0)
    {
        btn.tag=1;
        self.lblInfo.hidden=NO;
        self.imgInfo.hidden=NO;
    }
    else
    {
        btn.tag=0;
        self.lblInfo.hidden=YES;
        self.imgInfo.hidden=YES;
    }

}

#pragma mark -
#pragma mark - UIActionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
            
            break;
        case 2:
            break;
        case 3:
            break;
    }
}



-(void)chooseFromLibaray
{
    // Set up the image picker controller and add it to the view
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing=YES;
    imagePickerController.view.tag = 102;
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:^{
    }];
}

#pragma mark -
#pragma mark - UIImagePickerController Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.imgProPic.contentMode = UIViewContentModeScaleAspectFill;
    self.imgProPic.clipsToBounds = YES;
    isProPicAdded=YES;
    self.imgProPic.image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark - UIPickerView Delegate and Datasource

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.pickerView.tag==100)
    {
        countryCode=[[arrForCountry objectAtIndex:row] valueForKey:@"phone-code"];
        //[self.btnCountryCode setTitle:[[arrForCountry objectAtIndex:row] valueForKey:@"phone-code"] forState:UIControlStateNormal];
    }
    else if (typePicker.tag==101)
    {
        NSMutableDictionary *typeDict=[arrType objectAtIndex:row];
        txtType.text=[typeDict valueForKey:@"name"];
        [self.imgType downloadFromURL:[typeDict valueForKey:@"icon"] withPlaceholder:nil];
        strTypeId=[NSMutableString stringWithFormat:@"%@",[typeDict valueForKey:@"id"]];
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerView.tag==100)
    {
        return arrForCountry.count;
    }
    else if (typePicker.tag==101)
    {
        return arrType.count;
    }
    else
    {
        return  0;
    }
    
}
/*
 - (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
 NSString *strForTitle=[NSString stringWithFormat:@"%@  %@",[[arrForCountry objectAtIndex:row] valueForKey:@"phone-code"],[[arrForCountry objectAtIndex:row] valueForKey:@"name"]];
 return strForTitle;
 }*/

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *viewTitle=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    
    if (self.pickerView.tag==100)
    {
        NSString *strForTitle=[NSString stringWithFormat:@"%@  %@",[[arrForCountry objectAtIndex:row] valueForKey:@"phone-code"],[[arrForCountry objectAtIndex:row] valueForKey:@"name"]];
        
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(25, 0, 250, 40)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text=strForTitle;
        
        UIImageView *imggv=[[UIImageView alloc]initWithFrame:CGRectMake(25, 5, 30, 30)];
        
        imggv.image=[UIImage imageNamed:@"Flag_of_India.png"];
        
        [viewTitle addSubview:lbl];
       // [viewTitle addSubview:imggv];
    }
    if(typePicker.tag==101)
    {
        NSMutableDictionary *dictType=[arrType objectAtIndex:row];
        
        UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(60, 0, 250, 40)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text=[dictType valueForKey:@"name"];;
        
        UIImageView *imggv=[[UIImageView alloc]initWithFrame:CGRectMake(25, 5, 30, 30)];
        [imggv downloadFromURL:[dictType valueForKey:@"icon"] withPlaceholder:nil];
        
        
        [viewTitle addSubview:lbl];
        [viewTitle addSubview:imggv];
        
    }
    
    
    
    
    return viewTitle;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

#pragma mark-
#pragma mark- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrType.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cartype" forIndexPath:indexPath];
    
    NSMutableDictionary *dictType=[arrType objectAtIndex:indexPath.row];
    
//    if (strTypeId==nil)
//    {
//        if ([[dictType valueForKey:@"is_default"]intValue]==1)
//        {
//            strTypeId=[NSString stringWithFormat:@"%@",[dictType valueForKey:@"id"]];
//        }
//    }
    if ([strTypeId intValue]==[[dictType valueForKey:@"id"]intValue])
    {
        cell.imgCheck.hidden=NO;
    }
    else
    {
        cell.imgCheck.hidden=YES;
    }


    cell.lblTitle.text=[dictType valueForKey:@"name"];
    [cell.imgType downloadFromURL:[dictType valueForKey:@"icon"] withPlaceholder:nil];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CarTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cartype" forIndexPath:indexPath];

    NSMutableDictionary *dictType=[arrType objectAtIndex:indexPath.row];
    strTypeId=[NSMutableString stringWithFormat:@"%@",[dictType valueForKey:@"id"]];
    [self.typeCollectionView reloadData];
}

/*- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row==arrType.count-1)
        return CGSizeMake(45, 60);
    
    return CGSizeMake(104, 60);
}
*/
#pragma mark-
#pragma mark- Text Field Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==self.txtNumber  || textField==self.txtZipcode)
    {
        NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
    }
    return YES;
}





-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint offset;
    if(textField==self.txtFirstName)
    {
        offset=CGPointMake(0, 90);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    if(textField==self.txtLastName)
    {
        offset=CGPointMake(0, 120);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    if(textField==self.txtEmail)
    {
        offset=CGPointMake(0, 160);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    if(textField==self.txtNumber)
    {
        offset=CGPointMake(0, 250);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    if(textField==self.txtPassword)
    {
        offset=CGPointMake(0, 210);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else if(textField==self.txtAddress)
    {
        offset=CGPointMake(0, 310);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else if(textField==self.txtBio)
    {
        offset=CGPointMake(0, 370);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else if(textField==self.txtZipcode)
    {
        offset=CGPointMake(0, 430);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else if(textField==self.txtTaxiModel)
    {
        offset=CGPointMake(0, 490);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    
    else if(textField==self.txtTaxiNumber)
    {
        offset=CGPointMake(0, 550);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    
    self.lblInfo.hidden=YES;
    self.lblEmailInfo.hidden=YES;
    self.lblCarNumberInfo.hidden=YES;
    self.lblCarModelInfo.hidden=YES;
    self.imgInfo.hidden=YES;
    self.imgEmailInfo.hidden=YES;
    self.imgCarModelInfo.hidden=YES;
    self.imgCarNumberInfo.hidden=YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CGPoint offset;
    offset=CGPointMake(0, 0);
    [self.scrollView setContentOffset:offset animated:YES];
    
    if(textField==self.txtFirstName)
        [self.txtLastName becomeFirstResponder];
    else if(textField==self.txtLastName)
        [self.txtEmail becomeFirstResponder];
    else if(textField==self.txtEmail)
        [self.txtPassword becomeFirstResponder];
    else if(textField==self.txtNumber)
        [self.txtAddress becomeFirstResponder];
    else if(textField==self.txtPassword)
        [self.txtNumber becomeFirstResponder];
    else if(textField==self.txtAddress)
        [self.txtBio becomeFirstResponder];
    else if(textField==self.txtBio)
        [self.txtZipcode becomeFirstResponder];
    else if(textField==self.txtZipcode)
        [self.txtTaxiModel becomeFirstResponder];
    else if(textField==self.txtTaxiModel)
        [self.txtTaxiNumber becomeFirstResponder];
    
    [textField resignFirstResponder];
    return YES;
}

//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (textField==self.txtFirstName || textField==self.txtLastName )
//    {
//        NSString *text = [textField text];
//        NSString *capitalized = [[[text substringToIndex:1] uppercaseString]stringByAppendingString:[text substringFromIndex:1]];
//        
//        textField.text=capitalized;
//        //NSLog(@"%@ uppercased is %@", text, capitalized);
//
//    }
//    
//}
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
{
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtRePassword resignFirstResponder];
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtBio resignFirstResponder];
    [self.txtNumber resignFirstResponder];
    [self.txtType resignFirstResponder];
    [self.txtZipcode resignFirstResponder];
    [self.txtAddress resignFirstResponder];
    [self.txtTaxiModel resignFirstResponder];
    [self.txtTaxiModel resignFirstResponder];
    CGPoint offset;
    offset=CGPointMake(0, 0);
    [self.scrollView setContentOffset:offset animated:YES];
    
    self.lblInfo.hidden=YES;
    self.lblEmailInfo.hidden=YES;
    self.lblCarNumberInfo.hidden=YES;
    self.lblCarModelInfo.hidden=YES;
    self.imgInfo.hidden=YES;
    self.imgEmailInfo.hidden=YES;
    self.imgCarModelInfo.hidden=YES;
    self.imgCarNumberInfo.hidden=YES;
}


#pragma mark-
#pragma mark- Get WalerType Method


-(void)getType
{
    if([APPDELEGATE connected])
    {
       AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:FILE_WALKER_TYPE withParamData:nil withBlock:^(id response, NSError *error)
         {
             
             NSLog(@"Check Request= %@",response);
             if (response) {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     arrType=[response valueForKey:@"types"];
                     [typeCollectionView reloadData];
                     self.pickerView.tag=0;
                     typePicker.tag=101;
                     [typePicker reloadAllComponents];
                 }
             }
             
         }];
    }
}

- (IBAction)typeBtnPressed:(id)sender
{
    if(pickTypeView.hidden==YES)
    {
        typePicker.tag=101;
        self.pickerView.tag=0;
        [typePicker reloadAllComponents];
        pickTypeView.hidden=NO;
    }
    else
    {
        pickTypeView.hidden=YES;
    }
}

- (IBAction)pickDoneBtnPressed:(id)sender
{
     self.pickTypeView.hidden=YES;
}

- (IBAction)pickCancelBtnPressed:(id)sender
{
     self.pickTypeView.hidden=YES;
}


#pragma mark - Alert Button Clicked Event

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 200)
    {
        if (buttonIndex == 0)
        {
            UIDevice *thisDevice=[UIDevice currentDevice];
            if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
            {
                CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
                float closeY=(iOSDeviceScreenSize.height-self.btnSelectService.frame.size.height-self.btnRegister.frame.size.height);
                
                float openY=closeY-(self.bottomView.frame.size.height-self.btnSelectService.frame.size.height-self.btnRegister.frame.size.height)-30.0f;
                if (self.bottomView.frame.origin.y==closeY)
                {
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        self.bottomView.frame=CGRectMake(0, openY, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                        
                    } completion:^(BOOL finished)
                     {
                     }];
                }
                else
                {
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        self.bottomView.frame=CGRectMake(0, closeY, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
                        
                    } completion:^(BOOL finished)
                     {
                     }];
                }
                
            }

        }
    }
}
#pragma -mark
#pragma mark Camera Btn Press Event Method
- (IBAction)clickCameraBtn:(id)sender
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate =self;
        imagePickerController.allowsEditing=YES;
        imagePickerController.view.tag = 102;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
    else
    {
        UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"CAM_NOT_AVAILABLE", nil)delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alt show];
    }
}

#pragma -mark
#pragma mark Picture Btn Press Event Method

- (IBAction)clickPictureBtn:(id)sender
{
    [self chooseFromLibaray];
}
@end
