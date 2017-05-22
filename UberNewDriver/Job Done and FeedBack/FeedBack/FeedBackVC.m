//
//  FeedBackVC.m
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//
#import "FeedBackVC.h"
#import "UIImageView+Download.h"
#import "UIView+Utils.h"

@interface FeedBackVC ()
{
    NSMutableString *strUserId;
    NSMutableString *strUserToken;
    NSMutableString *strRequsetId;
    
    NSString *strTime;
    NSString *strDistance;
    NSString *strProfilePic;
    NSString *strLastName;
    NSString *strFirstName;
    float rate;
    NSString *strForCurrency;
}

@end

@implementation FeedBackVC

@synthesize txtComment;

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
	
	[self.btnConfirm setBackgroundColor:LightBtnColor];
	[self.btnSubmit setBackgroundColor:DarkBtnColor];
	[self.lblBgInvoice setBackgroundColor:RefrelCodeColor];
	[self.lblBgGreenInvoice setBackgroundColor:RefrelCreditColor];
	[self.imgPaymentMode setBackgroundColor:ProfileViewColor];
    
    [self customFont];
    [self localizeString];
    
    strDistance=[PREF objectForKey:PREF_WALK_DISTANCE];
    strTime=[PREF objectForKey:PREF_WALK_TIME];
    strProfilePic=[PREF objectForKey:PREF_USER_PICTURE];
    strLastName=[PREF objectForKey:PREF_USER_NAME];

    strForCurrency = [dictBillInfo valueForKey:@"currency"];
    NSArray *myWords = [strLastName componentsSeparatedByString:@" "];
    
    self.lblFirstName.text=[myWords objectAtIndex:0];
    self.lblLastName.text=[NSString stringWithFormat:@"%@ %@",[myWords objectAtIndex:0],[myWords objectAtIndex:1]];
    [self.imgProfile applyRoundedCornersFullWithColor:[UIColor whiteColor]];
    
    self.lblDistance.text=[NSString stringWithFormat:@"%.2f %@",[[dictBillInfo valueForKey:@"distance"] floatValue],[dictBillInfo valueForKey:@"unit"]];
    self.lblTime.text=[NSString stringWithFormat:@"%.2f %@",[[dictBillInfo valueForKey:@"time" ] floatValue],NSLocalizedString(@"Mins", nil)];
 
    self.lblTask1.text=@"0";
    self.lblTask2.text=@"1";
    [self.imgProfile downloadFromURL:strProfilePic withPlaceholder:nil];
    
    [self.btnMenu addTarget:self.revealViewController action:@selector(revealToggle: ) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    self.viewForBill.hidden=NO;
    [self setPriceValue];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.btnMenu setTitle:NSLocalizedString(@"Invoice", nil) forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [APPDELEGATE hideLoadingView];
    [self.btnMenu setTitle:NSLocalizedString(@"Invoice", nil) forState:UIControlStateNormal];
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

-(void)giveFeedback
{
    strUserId=[PREF objectForKey:PREF_USER_ID];
    strUserToken=[PREF objectForKey:PREF_USER_TOKEN];
    strRequsetId=[PREF objectForKey:PREF_REQUEST_ID];
    
    if (strRequsetId!=nil)
    {
        NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
        
        [dictparam setObject:strRequsetId forKey:PARAM_REQUEST_ID];
        [dictparam setObject:strUserId forKey:PARAM_ID];
        [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
        
        [dictparam setObject:[NSString stringWithFormat:@"%f",rate] forKey:PARAM_RATING];
        
        NSString *commt=self.txtComment.text;
        if([commt isEqualToString:NSLocalizedString(@"COMMENTS", nil)])
        {
            [dictparam setObject:@"" forKey:PARAM_COMMENT];
        }
        else
        {
            [dictparam setObject:self.txtComment.text forKey:PARAM_COMMENT];
        }
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_RATING withParamData:dictparam withBlock:^(id response, NSError *error)
         {
             [APPDELEGATE hideLoadingView];
             if([[response valueForKey:@"success"] intValue]==1)
             {
                 [APPDELEGATE showToastMessage:NSLocalizedString(@"RATING_COMPLETED", nil)];
                 [PREF removeObjectForKey:PREF_REQUEST_ID];
                 [PREF removeObjectForKey:PREF_USER_NAME];
                 [PREF removeObjectForKey:PREF_USER_PHONE];
                 [PREF removeObjectForKey:PREF_USER_PICTURE];
                 [PREF removeObjectForKey:PREF_USER_RATING];
                 [PREF removeObjectForKey:PREF_START_TIME];
                 is_completed=0;
                 is_dog_rated=0;
                 is_started=0;
                 is_walker_arrived=0;
                 is_walker_started=0;
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
             else
             {
                 NSString *str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[afn getErrorMessage:str] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];
    }
}

#pragma mark-
#pragma mark-

-(void)customFont
{
    self.lblTime.font=[UberStyleGuide fontRegularLight:15.0f];
    self.lblDistance.font=[UberStyleGuide fontRegularLight:15.0f];
    self.btnSubmit=[APPDELEGATE setBoldFontDiscriptor:self.btnSubmit];
    self.lblBasePrice.font=[UberStyleGuide fontRegularLight:20.70f];
    self.lblDistCost.font=[UberStyleGuide fontRegularLight:20.70f];
    self.lblTimeCost.font=[UberStyleGuide fontRegularLight:20.70f];
    self.lblReferrel.font=[UberStyleGuide fontRegularLight:20.70f];
    self.lblPromo.font=[UberStyleGuide fontRegularLight:20.70f];
    self.lblPerDist.font=[UberStyleGuide fontRegularLight:10.30f];
    self.lblPerTime.font=[UberStyleGuide fontRegularLight:10.30f];
    self.lblTotal.font=[UberStyleGuide fontRegularLight:42.13f];
    self.lblFirstName.font=[UberStyleGuide fontRegularLight:20.0f];
    self.lblLastName.font=[UberStyleGuide fontRegularLight:20.0f];
    self.lblBase_Price.font=[UberStyleGuide fontRegularLight];
    self.lblDist_Cost.font=[UberStyleGuide fontRegularLight];
    self.lblTime_Cost.font=[UberStyleGuide fontRegularLight];
    self.lbl_Referrel.font=[UberStyleGuide fontRegularLight];
    self.lbl_Promo.font=[UberStyleGuide fontRegularLight];
    self.lblTotalDue.font=[UberStyleGuide fontRegularLight];
    
//    self.lblBasePrice.textColor=[UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
//    self.lblDistCost.textColor=[UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
//    self.lblPerDist.textColor=[UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
//    self.lblPerTime.textColor=[UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
//    self.lblTimeCost.textColor=[UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
//    self.lblTotal.textColor=[UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:38.0f/255.0f alpha:1.0f];

    self.btnMenu.titleLabel.font=[UberStyleGuide fontRegularLight];
    self.btnMenu.titleLabel.textColor = [UberStyleGuide fontColorNevigation];
}

-(void)localizeString
{
    self.lblInvoice.text = NSLocalizedString(@"Invoice", nil);
    self.lblTime_Cost.text = NSLocalizedString(@"TIME COST", nil);
    self.lblDist_Cost.text = NSLocalizedString(@"DISTANCE COST", nil);
    self.lblTotalDue.text = NSLocalizedString(@"Total Due", nil);
    self.lblBase_Price.text = NSLocalizedString(@"BASE PRICE", nil);
    self.lbl_Promo.text = NSLocalizedString(@"PROMO BOUNCE", nil);
    self.lbl_Referrel.text = NSLocalizedString(@"REFERRAL BOUNCE", nil);
    //[self.btnConfirm setTitle:NSLocalizedString(@"CONFIRM", nil) forState:UIControlStateNormal];
   // [self.btnSubmit setTitle:NSLocalizedString(@"SUBMIT", nil) forState:UIControlStateNormal];
    //[self.btnSubmit setTitle:NSLocalizedString(@"SUBMIT", nil) forState:UIControlStateSelected];
    self.lblComment.text = NSLocalizedString(@"COMMENT", nil);
    self.txtComment.text = NSLocalizedString(@"COMMENTS", nil);
    self.lblPaymentModeTitle.text = NSLocalizedString(@"Payment Mode", nil);
}

#pragma mark-
#pragma mark- Set Invoice Details

-(void)setPriceValue
{
    self.lblReferrel.text = [NSString stringWithFormat:@"%@ %.2f",strForCurrency,[[dictBillInfo valueForKey:@"referral_bonus"] floatValue]];
    self.lblPromo.text = [NSString stringWithFormat:@"%@ %.2f",strForCurrency,[[dictBillInfo valueForKey:@"promo_bonus"] floatValue]];
    self.lblBasePrice.text=[NSString stringWithFormat:@"%@ %.2f",strForCurrency,[[dictBillInfo valueForKey:@"base_price"] floatValue]];
    self.lblDistCost.text=[NSString stringWithFormat:@"%@ %.2f",strForCurrency,[[dictBillInfo valueForKey:@"distance_cost"] floatValue]];
    self.lblTimeCost.text=[NSString stringWithFormat:@"%@ %.2f",strForCurrency,[[dictBillInfo valueForKey:@"time_cost"] floatValue]];
    self.lblTotal.text=[NSString stringWithFormat:@"%@ %.2f",strForCurrency,[[dictBillInfo valueForKey:@"total"] floatValue]];
    if([[dictBillInfo valueForKey:@"payment_type"]intValue]==1)
    {
        self.lblPaymentMode.text = NSLocalizedString(@"Cash Payment", nil);
    }
    else
    {
        self.lblPaymentMode.text = NSLocalizedString(@"Card Payment", nil);
    }
    
    float totalDist=[[dictBillInfo valueForKey:@"distance_cost"] floatValue];
    float Dist=[[dictBillInfo valueForKey:@"distance"]floatValue];
    
    if ([[dictBillInfo valueForKey:@"unit"]isEqualToString:NSLocalizedString(@"kms", nil)])
    {
        totalDist=totalDist*0.621317;
        Dist=Dist*0.621371;
    }
    
    if(Dist!=0)
    {
        self.lblPerDist.text=[NSString stringWithFormat:@"%@%.2f %@",strForCurrency,(totalDist/Dist),NSLocalizedString(@"per mile", nil)];
    }
    else
    {
        self.lblPerDist.text=[NSString stringWithFormat:@"%@0 %@",strForCurrency,NSLocalizedString(@"per mile", nil)];
    }
    
    float totalTime=[[dictBillInfo valueForKey:@"time_cost"] floatValue];
    float Time=[[dictBillInfo valueForKey:@"time"]floatValue];
    if(Time!=0)
    {
        self.lblPerTime.text=[NSString stringWithFormat:@"%@%.2f %@",strForCurrency,(totalTime/Time),NSLocalizedString(@"per min", nil)];
    }
    else
    {
        self.lblPerTime.text=[NSString stringWithFormat:@"%@0 %@",strForCurrency,NSLocalizedString(@"per min", nil)];
    }
}

#pragma mark-
#pragma mark- Button Methods

- (IBAction)submitBtnPressed:(id)sender
{
    [self.txtComment resignFirstResponder];
    RBRatings rating=[ratingView getcurrentRatings];
    rate=rating/2.0;
    if (rating%2 != 0)
    {
        rate += 0.5;
    }
    if (rate==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_RATINGS", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:Nil, nil];
        [alert show];
    }
    else
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"WAITING_FOR_FEEDBACK", nil)];
        [txtComment resignFirstResponder];
        [self giveFeedback];
    }
}

- (IBAction)confirmBtnPressed:(id)sender
{
    self.viewForBill.hidden=YES;
    [self.btnMenu setTitle:NSLocalizedString(@"Feedback", nil) forState:UIControlStateNormal];
    ratingView=[[RatingBar alloc] initWithSize:CGSizeMake(150, 27) AndPosition:CGPointMake(85, 190)];
    ratingView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:ratingView];
}

#pragma mark-
#pragma mark- Text Field Delegate

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtComment resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField     //Hide the keypad when we pressed return
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.txtComment.text=@"";
    UIDevice *thisDevice=[UIDevice currentDevice];
    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 568)
        {
            if(textView == self.txtComment)
            {
                UITextPosition *beginning = [self.txtComment beginningOfDocument];
                [self.txtComment setSelectedTextRange:[self.txtComment textRangeFromPosition:beginning
                                                                                  toPosition:beginning]];
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, -210, 320, 568);
                    
                } completion:^(BOOL finished) { }];
            }
        }
        else
        {
            if(textView == self.txtComment)
            {
                UITextPosition *beginning = [self.txtComment beginningOfDocument];
                [self.txtComment setSelectedTextRange:[self.txtComment textRangeFromPosition:beginning
                                                                                  toPosition:beginning]];
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, -210, 320, 480);
                    
                } completion:^(BOOL finished) { }];
            }
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    UIDevice *thisDevice=[UIDevice currentDevice];
    if(thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 568)
        {
            if(textView == self.txtComment)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 568);
                    
                } completion:^(BOOL finished) { }];
            }
        }
        else
        {
            if(textView == self.txtComment)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    self.view.frame = CGRectMake(0, 0, 320, 480);
                    
                } completion:^(BOOL finished) { }];
            }
        }
    }
    if ([txtComment.text isEqualToString:@""])
    {
        txtComment.text=NSLocalizedString(@"COMMENTS", nil);;
    }
}

/*- (void)textFieldDidBeginEditing:(UITextField *)textField
 
 {
 if(textField == self.txtComment)
 {
 UITextPosition *beginning = [self.txtComment beginningOfDocument];
 [self.txtComment setSelectedTextRange:[self.txtComment textRangeFromPosition:beginning
 toPosition:beginning]];
 [UIView animateWithDuration:0.3 animations:^{
 
 self.view.frame = CGRectMake(0, -120, 320, 480);
 
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
 if(textField == self.txtComment)
 {
 [UIView animateWithDuration:0.3 animations:^{
 
 self.view.frame = CGRectMake(0, 0, 320, 568);
 
 } completion:^(BOOL finished) { }];
 }
 }
 else
 {
 if(textField == self.txtComment)
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
