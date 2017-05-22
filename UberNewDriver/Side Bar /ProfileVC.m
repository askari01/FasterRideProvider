//
//  ProfileVC.m
//  UberNewDriver
//
//  Created by My mac on 11/3/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "ProfileVC.h"
#import "UIImageView+Download.h"
#import "UIView+Utils.h"
#import "UtilityClass.h"
#import "PickMeUpMapVC.h"
#import "ArrivedMapVC.h"
#import "FeedBackVC.h"

@interface ProfileVC ()
{
    BOOL internet;
    NSMutableString *strUserId;
    NSMutableString *strUserToken;
    NSMutableString *strPassword;
}

@end

@implementation ProfileVC

@synthesize txtAddress,title,txtBio,txtEmail,txtLastName,txtName,txtNumber,txtZip,txtPassword,btnProPic,txtNewPassword,bgNewPwd,bgPwd,txtTaxiModel,txtTaxiNumber,txtReNewPassword,bgReNewPwd;

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
    //[super setBackBarItem];
	[self.viewForProfile setBackgroundColor:ProfileViewColor];
	
    [self.profileImage applyRoundedCornersFullWithColor:[UIColor whiteColor]];
    [self.ScrollProfile setScrollEnabled:YES];
	
	[self.ScrollProfile setContentSize:CGSizeMake(320, 818)];
	
    [self textDisable];
    [self localizeString];
    
    
    strUserId=[PREF objectForKey:PREF_USER_ID];
    strUserToken=[PREF objectForKey:PREF_USER_TOKEN];
    strPassword=[PREF objectForKey:PREF_PASSWORD];
    
    txtName.text=[arrUser valueForKey:@"first_name"];
    txtLastName.text=[arrUser valueForKey:@"last_name"];
    self.txtFullName.text=[NSString stringWithFormat:@"%@ %@",[arrUser valueForKey:@"first_name"],[arrUser valueForKey:@"last_name"]];
    self.lblFullName.text=[NSString stringWithFormat:@"%@ %@",[arrUser valueForKey:@"first_name"],[arrUser valueForKey:@"last_name"]];
    txtEmail.text=[arrUser valueForKey:@"email"];
    txtNumber.text=[arrUser valueForKey:@"phone"];
    txtAddress.text=[arrUser valueForKey:@"address"];
    txtZip.text=[arrUser valueForKey:@"zipcode"];
    txtBio.text=[arrUser valueForKey:@"bio"];
    txtTaxiModel.text=[arrUser valueForKey:@"car_model"];
    txtTaxiNumber.text=[arrUser valueForKey:@"car_number"];

    txtPassword.text=@"";
    txtNewPassword.text=@"";
    txtReNewPassword.text=@"";
    
    [self.profileImage downloadFromURL:[arrUser valueForKey:@"picture"] withPlaceholder:nil];
	
    [self.btnUpdate setHidden:YES];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.lblCarModelInfo.hidden=YES;
    self.imgCarModelInfo.hidden=YES;
    self.lblCarNumberInfo.hidden=YES;
    self.imgCarNumberInfo.hidden=YES;
    self.lblEmailInfo.hidden=YES;
    self.imgEmailInfo.hidden=YES;
    self.btnInfo1.tag=0;
    self.btnInfo2.tag=0;
    self.btnInfo3.tag=0;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.btnMenu setTitle:NSLocalizedString(@"PROFILE", nil) forState:UIControlStateNormal];
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
    self.txtName.font=[UberStyleGuide fontRegular];
    self.txtFullName.font=[UberStyleGuide fontRegular];
    self.txtLastName.font=[UberStyleGuide fontRegular];
    self.txtEmail.font=[UberStyleGuide fontRegular];
    self.txtAddress.font=[UberStyleGuide fontRegular];
    self.txtBio.font=[UberStyleGuide fontRegular];
    self.txtZip.font=[UberStyleGuide fontRegular];
    
    self.btnMenu.titleLabel.font=[UberStyleGuide fontRegularLight];
    self.btnMenu.titleLabel.textColor=[UberStyleGuide fontColorNevigation];
    self.btnEdit=[APPDELEGATE setBoldFontDiscriptor:self.btnEdit];
    self.btnUpdate=[APPDELEGATE setBoldFontDiscriptor:self.btnUpdate];
    
    
    //self.txtTaxiNumber.font=[UberStyleGuide fontRegular];
    
    self.txtFullName.font=[UberStyleGuide fontRegularLight];
    self.txtLastName.font=[UberStyleGuide fontRegularLight];
    self.txtEmail.font=[UberStyleGuide fontRegularLight];
    self.txtPassword.font=[UberStyleGuide fontRegularLight];
    self.txtNewPassword.font=[UberStyleGuide fontRegularLight];
    self.txtReNewPassword.font=[UberStyleGuide fontRegularLight];
    self.txtNumber.font = [UberStyleGuide fontRegularLight];
    self.txtAddress.font=[UberStyleGuide fontRegularLight];
    self.txtBio.font=[UberStyleGuide fontRegularLight];
    self.txtZip.font=[UberStyleGuide fontRegularLight];
    self.txtTaxiModel.font=[UberStyleGuide fontRegularLight];
    self.txtTaxiNumber.font=[UberStyleGuide fontRegularLight];
    
    
    UIColor *color = [UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
    
    UIFont *font = [UberStyleGuide fontRegularLight];
    [self.txtEmail setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtEmail setValue:font forKeyPath:@"_placeholderLabel.font"];
    [self.txtPassword setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtPassword setValue:font forKeyPath:@"_placeholderLabel.font"];
    [self.txtAddress setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtAddress setValue:font forKeyPath:@"_placeholderLabel.font"];
    [self.txtBio setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtBio setValue:font forKeyPath:@"_placeholderLabel.font"];
    [self.txtFullName setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtLastName setValue:font forKeyPath:@"_placeholderLabel.font"];
    [self.txtLastName setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtLastName setValue:font forKeyPath:@"_placeholderLabel.font"];
    [self.txtNumber setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtNumber setValue:font forKeyPath:@"_placeholderLabel.font"];
    [self.txtTaxiModel setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtTaxiModel setValue:font forKeyPath:@"_placeholderLabel.font"];
    [self.txtTaxiNumber setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtTaxiNumber setValue:font forKeyPath:@"_placeholderLabel.font"];
    [self.txtTaxiModel setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtTaxiNumber setValue:font forKeyPath:@"_placeholderLabel.font"];
    [self.txtZip setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    [self.txtZip setValue:font forKeyPath:@"_placeholderLabel.font"];
    
  
}

-(void)localizeString
{
    self.txtName.placeholder = NSLocalizedString(@"NAME", nil);
    self.txtLastName.placeholder = NSLocalizedString(@"LAST NAME", nil);
    self.txtEmail.placeholder = NSLocalizedString(@"EMAIL", nil);
    self.txtNumber.placeholder = NSLocalizedString(@"NUMBER", nil);
    self.txtAddress.placeholder = NSLocalizedString(@"ADDRESS", nil);
    self.txtBio.placeholder = NSLocalizedString(@"BIO", nil);
    self.txtPassword.placeholder = NSLocalizedString(@"CURRENT PASSWORD", nil);
    self.txtNewPassword.placeholder = NSLocalizedString(@"NEW PASSWORD", nil);
    self.txtReNewPassword.placeholder = NSLocalizedString(@"CONFIRM NEW PASSWORD", nil);
    self.txtZip.placeholder = NSLocalizedString(@"ZIPCODE", nil);
    self.txtTaxiModel.placeholder = NSLocalizedString(@"TAXI MODEL", nil);
    self.txtTaxiModel.placeholder = NSLocalizedString(@"TAXI NUMBER", nil);
    self.lblEmailInfo.text = NSLocalizedString(@"This field is not editable.", nil);
    self.lblCarNumberInfo.text = NSLocalizedString(@"This field is not editable.", nil);
    self.lblCarModelInfo.text = NSLocalizedString(@"This field is not editable.", nil);

    //[self.btnEdit setTitle:NSLocalizedString(@"Edit Profile", nil) forState:UIControlStateNormal];
    //[self.btnEdit setTitle:NSLocalizedString(@"Edit Profile", nil) forState:UIControlStateSelected];
    [self.btnEdit setImage:[UIImage imageNamed:@"btn_edit"] forState:UIControlStateNormal];
    
    //[self.btnUpdate setTitle:NSLocalizedString(@"Update Profile", nil) forState:UIControlStateNormal];
    //[self.btnUpdate setTitle:NSLocalizedString(@"Update Profile", nil) forState:UIControlStateSelected];
    self.lblName.text = NSLocalizedString(@"NAME", nil);
    self.lblEmail.text = NSLocalizedString(@"EMAIL", nil);
    self.lblPassword.text = NSLocalizedString(@"PASSWORD", nil);
    self.lblPhone.text = NSLocalizedString(@"PHONE", nil);
    self.lblAddress.text = NSLocalizedString(@"ADDRESS", nil);
    self.lblBio.text = NSLocalizedString(@"BIO", nil);
    self.lblZipcode.text = NSLocalizedString(@"ZIPCODE", nil);
    self.lblTaxiModel.text = NSLocalizedString(@"TAXI MODEL", nil);
    self.lblTaxiNumber.text = NSLocalizedString(@"TAXI NUMBER", nil);
    self.lblNewPassword.text = NSLocalizedString(@"NEW PASSWORD", nil);
    self.lblConfirmPassword.text = NSLocalizedString(@"CONFIRM PASSWORD", nil);
}

#pragma mak- 
#pragma mark- TextField Enable and Disable

-(void)textDisable
{
    txtName.enabled = NO;
    txtLastName.enabled = NO;
    self.txtFullName.enabled = NO;
    txtEmail.enabled = NO;
    txtNumber.enabled = NO;
    txtPassword.enabled = NO;
    txtAddress.enabled = NO;
    txtZip.enabled = NO;
    txtBio.enabled = NO;
    btnProPic.enabled=NO;
    
    txtPassword.hidden=YES;
    txtNewPassword.hidden=YES;
    txtReNewPassword.hidden=YES;
    bgPwd.hidden=YES;
    bgNewPwd.hidden=YES;
    bgReNewPwd.hidden=YES;
    //[self.ScrollProfile setScrollEnabled:NO];
    
    CGPoint offset;
    offset=CGPointMake(0, 0);
	
	if (![[arrUser valueForKey:@"login_by"]isEqualToString:@"manual"])
	{
			[self.viewForPassword setHidden:YES];
			[self.ScrollProfile setContentSize:CGSizeMake(320, 668)];
	}
	else
	{
			[self.ScrollProfile setContentSize:CGSizeMake(320, 867)];
	}
    [self.ScrollProfile setContentOffset:offset animated:YES];
}

-(void)textEnable
{
    txtName.enabled = YES;
    self.txtFullName.enabled = YES;
    txtLastName.enabled = YES;
    txtEmail.enabled = NO;
    txtNumber.enabled = YES;
    txtPassword.enabled = YES;
    txtAddress.enabled = YES;
    txtZip.enabled = YES;
    txtBio.enabled = YES;
    btnProPic.enabled=YES;
    
    txtPassword.hidden=NO;
    txtNewPassword.hidden=NO;
    txtReNewPassword.hidden=NO;
    bgPwd.hidden=NO;
    bgNewPwd.hidden=NO;
    bgReNewPwd.hidden=NO;
    [self.ScrollProfile setContentSize:CGSizeMake(320, 867)];
    //[self.ScrollProfile setScrollEnabled:YES];
}


-(void)updatePRofile
{
    NSLog(@"\n\n IN Update PRofile");
    
    [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"UPDATING_PROFILE", nil)];
    internet=[APPDELEGATE connected];
    
    if([APPDELEGATE connected])
    {
        NSMutableDictionary *dictparam;
        dictparam= [[NSMutableDictionary alloc]init];
   
        NSString *myString = [NSString stringWithFormat:@"%@",self.txtFullName.text];
        NSArray *myWords = [myString componentsSeparatedByString:@" "];
        if (myWords.count>1)
        {
            [dictparam setObject:[myWords objectAtIndex:0] forKey:PARAM_FIRST_NAME];
            [dictparam setObject:[myWords objectAtIndex:1] forKey:PARAM_LAST_NAME];
        }
        else
        {
            [dictparam setObject:[myWords objectAtIndex:0] forKey:PARAM_FIRST_NAME];
            [dictparam setObject:@"" forKey:PARAM_LAST_NAME];
        }
        
        [dictparam setObject:txtEmail.text forKey:PARAM_EMAIL];
        [dictparam setObject:txtNumber.text forKey:PARAM_PHONE];
        //[dictparam setObject:strPassword forKey:PARAM_PASSWORD];
        
        [dictparam setObject:txtPassword.text forKey:PARAM_OLDPASSWORD];
        [dictparam setObject:txtNewPassword.text forKey:PARAM_NEWPASSWORD];
        //[dictparam setObject:strPassword forKey:PARAM_PASSWORD];
        [dictparam setObject:txtAddress.text forKey:PARAM_ADDRESS];
        [dictparam setObject:txtBio.text forKey:PARAM_BIO];
        [dictparam setObject:txtZip.text forKey:PARAM_ZIPCODE];
        //[dictparam setObject:device_token forKey:PARAM_DEVICE_TOKEN];
        
        [dictparam setObject:strUserId forKey:PARAM_ID];
        [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
        [dictparam setObject:@"" forKey:PARAM_PICTURE];
        
        UIImage *imgUpload = [[UtilityClass sharedObject]scaleAndRotateImage:self.profileImage.image];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_UPDATE_PROFILE withParamDataImage:dictparam andImage:imgUpload withBlock:^(id response, NSError *error)
         {
             
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     arrUser=response;
                     [APPDELEGATE showToastMessage:NSLocalizedString(@"PROFILE_UPDATED", nil)];
                     txtName.text=[arrUser valueForKey:@"first_name"];
                     txtLastName.text=[arrUser valueForKey:@"last_name"];
                     self.txtFullName.text=[NSString stringWithFormat:@"%@ %@",[arrUser valueForKey:@"first_name"],[arrUser valueForKey:@"last_name"]];
                     self.lblFullName.text=[NSString stringWithFormat:@"%@ %@",[arrUser valueForKey:@"first_name"],[arrUser valueForKey:@"last_name"]];
                     txtEmail.text=[arrUser valueForKey:@"email"];
                     txtNumber.text=[arrUser valueForKey:@"phone"];
                     txtAddress.text=[arrUser valueForKey:@"address"];
                     txtZip.text=[arrUser valueForKey:@"zipcode"];
                     txtBio.text=[arrUser valueForKey:@"bio"];
                     [self.profileImage downloadFromURL:[arrUser valueForKey:@"picture"] withPlaceholder:nil];
				 [self.navigationController popViewControllerAnimated:YES];
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
                 }
                 [self.btnEdit setHidden:NO];
                 //[self.btnUpdate setHidden:YES];
                 [self textDisable];
                 [self.btnEdit setImage:[UIImage imageNamed:@"btn_edit"] forState:UIControlStateNormal];
             }
             
             [APPDELEGATE hideLoadingView];
             
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
#pragma mark- Button Method


- (IBAction)editBtnPressed:(id)sender
{
    UIButton *b = (UIButton *)sender;
    
    if ([b.imageView.image isEqual:[UIImage imageNamed:@"btn_edit"]])
    {
        [self textEnable];
        [APPDELEGATE showToastMessage:@"You Can Edit Your Profile"];
        [self.btnEdit setImage:[UIImage imageNamed:@"btn_edit_right"] forState:UIControlStateNormal];
        [self.btnEdit setHidden:NO];
        //[self.btnUpdate setHidden:NO];
         [self.txtFullName becomeFirstResponder];
        
    }
    else if ([b.imageView.image isEqual:[UIImage imageNamed:@"btn_edit_right"]])
    {
        [self updateBtnPressed:nil];
    }
}

- (IBAction)updateBtnPressed:(id)sender
{
    internet=[APPDELEGATE connected];
    if (self.txtNewPassword.text.length>=1 || self.txtReNewPassword.text.length>=1)
    {
        if ([txtNewPassword.text isEqualToString:txtReNewPassword.text])
        {
            [self updatePRofile];
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Profile Update Fail" message:NSLocalizedString(@"NOT_MATCH_RETYPE",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        [self updatePRofile];
    }
    
}

- (IBAction)backBtnPressed:(id)sender
{
    
    NSArray *currentControllers = self.navigationController.viewControllers;
    NSMutableArray *newControllers = [NSMutableArray
                                      arrayWithArray:currentControllers];
    UIViewController *obj=nil;
    
    for (int i=0; i<newControllers.count; i++)
    {
        UIViewController *vc=[self.navigationController.viewControllers objectAtIndex:i];
        if ([vc isKindOfClass:[FeedBackVC class]])
        {
            obj = (FeedBackVC *)vc;
        }
        else if ([vc isKindOfClass:[ArrivedMapVC class]])
        {
            obj = (ArrivedMapVC *)vc;
        }
        else if ([vc isKindOfClass:[PickMeUpMapVC class]])
        {
            obj = (PickMeUpMapVC *)vc;
        }
        
    }
    [self.navigationController popToViewController:obj animated:YES];
   // [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)imgPicBtnPressed:(id)sender
{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Select Image", nil];
    action.tag=10001;
    [action showInView:self.view];
    
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

- (IBAction)onClickTaxiModelInfo:(id)sender
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

- (IBAction)onClickTaxiNoInfo:(id)sender
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

#pragma mark -
#pragma mark - UIActionSheet delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self openCamera];
            break;
        case 1:
            [self chooseFromLibaray];
            break;
        case 2:
            break;
        case 3:
            break;
    }
}

-(void)openCamera
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

-(void)chooseFromLibaray
{
    // Set up the image picker controller and add it to the view

    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
   
    imagePickerController.delegate =self;
    
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
    self.profileImage.image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark-
#pragma mark- Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField     //Hide the keypad when we pressed return
{
    CGPoint offset;
    offset=CGPointMake(0, 0);
  //  [self.ScrollProfile setContentOffset:offset animated:YES];
    if (textField==txtName)
    {
        [self.txtLastName becomeFirstResponder];
    }
    if (textField==txtLastName)
    {
        [self.txtEmail becomeFirstResponder];
    }
    if (textField==self.txtFullName)
    {
        [self.txtNumber becomeFirstResponder];
    }
    if (textField==txtEmail)
    {
        [self.txtNumber becomeFirstResponder];
    }
    if (textField==txtNumber)
    {
        [self.txtAddress becomeFirstResponder];
    }
    if (textField==txtAddress)
    {
        [self.txtBio  becomeFirstResponder];
    }
    if (textField==txtBio)
    {
        [self.txtZip becomeFirstResponder];
    }
    if (textField==txtZip)
    {
        [self.txtPassword becomeFirstResponder];
    }
	if (![[arrUser valueForKey:@"login_by"]isEqualToString:@"manual"])
		{
		if (textField==txtPassword)
			{
			[self.txtNewPassword becomeFirstResponder];
			}
		if (textField==txtNewPassword)
			{
			[self.txtReNewPassword becomeFirstResponder];
			}
		}
	
   // [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint offset;
    int y=0;
    int jump=75;
    if(textField==self.txtEmail)
    {
        offset=CGPointMake(0, y);
        [self.ScrollProfile setContentOffset:offset animated:YES];
    }

    if(textField==self.txtNumber)
    {
        y=y+jump;
        offset=CGPointMake(0, 70);
        [self.ScrollProfile setContentOffset:offset animated:YES];
    }
    if(textField==self.txtAddress)
    {
        y=y+jump*2;
        offset=CGPointMake(0, 135);
        [self.ScrollProfile setContentOffset:offset animated:YES];
    }
    if(textField==self.txtBio)
    {
        y=y+jump*3;
        offset=CGPointMake(0, 200);
        [self.ScrollProfile setContentOffset:offset animated:YES];
	[textField resignFirstResponder];
    }
    if(textField==self.txtZip)
    {
        y=y+jump*4;
        offset=CGPointMake(0, 265);
        [self.ScrollProfile setContentOffset:offset animated:YES];
	
    }
	if ([[arrUser valueForKey:@"login_by"]isEqualToString:@"manual"])
	{
	if(textField==self.txtPassword)
		{
		y=y+jump*5;
		offset=CGPointMake(0, 440);
		[self.ScrollProfile setContentOffset:offset animated:YES];
		}
	if(textField==self.txtNewPassword)
		{
		y=y+jump*6;
		offset=CGPointMake(0, 505);
		[self.ScrollProfile setContentOffset:offset animated:YES];
		}
	if(textField==self.txtReNewPassword)
		{
		y=y+jump*7;
		offset=CGPointMake(0, 570);
		[self.ScrollProfile setContentOffset:offset animated:YES];
		}
	}
    /*
    if(textField == self.txtPassword)
    {
        UITextPosition *beginning = [self.txtPassword beginningOfDocument];
        [self.txtPassword setSelectedTextRange:[self.txtPassword textRangeFromPosition:beginning
                                                                            toPosition:beginning]];
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, -35, 320, 480);
            
        } completion:^(BOOL finished) { }];
    }
    if(textField == self.txtAddress)
    {
        UITextPosition *beginning = [self.txtAddress beginningOfDocument];
        [self.txtAddress setSelectedTextRange:[self.txtAddress textRangeFromPosition:beginning
                                                                          toPosition:beginning]];
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, -75, 320, 480);
            
        } completion:^(BOOL finished) { }];
    }
    if(textField == self.txtBio)
    {
        UITextPosition *beginning = [self.txtBio beginningOfDocument];
        [self.txtBio setSelectedTextRange:[self.txtBio textRangeFromPosition:beginning
                                                                  toPosition:beginning]];
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, -115, 320, 480);
            
        } completion:^(BOOL finished) { }];
    }
    else if(textField == self.txtZip)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.view.frame = CGRectMake(0, -128, 320, 480);
            
        } completion:^(BOOL finished) { }];
    }
     */
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
            else if(textField == self.txtAddress)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 568);
                    
                } completion:^(BOOL finished) { }];
            }
            else if(textField == self.txtBio)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 568);
                    
                } completion:^(BOOL finished) { }];
            }
            else if (textField == self.txtZip)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame = CGRectMake(0, 0, 320, 568);
                } completion:^(BOOL finished) {
				}];
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
            else if(textField == self.txtAddress)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 480);
                    
                } completion:^(BOOL finished) { }];
            }
            else if(textField == self.txtBio)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 480);
                    
                } completion:^(BOOL finished) { }];
            }
            else if (textField == self.txtZip)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 480);
                } completion:^(BOOL finished) {
				}];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.txtFullName])
    {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        [self updateTextLabelsWithText: newString];
    }
   
    
    return YES;
}

-(void)updateTextLabelsWithText:(NSString *)string
{
    [self.lblFullName setText:string];
}
- (IBAction)editingChange:(id)sender
{
    self.lblFullName.text=self.txtFullName.text;
}
@end
