//
//  ForgotPasswordVC.m
//  UberforX Provider
//
//  Created by My Mac on 11/15/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "UberStyleGuide.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "Constant.h"

@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC

#pragma mark - ViewLife Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setBackBarItem];
	[self.btnSend setBackgroundColor:DarkBtnColor];

    //self.btnSend=[APPDELEGATE setBoldFontDiscriptor:self.btnSend];
    self.btnSend.titleLabel.font=[UberStyleGuide fontRegularBold];
    self.txtEmail.font=[UberStyleGuide fontRegularBold];
    
    [self.btnSend setTitle:NSLocalizedString(@"SEND PASSWORD",nil) forState:UIControlStateNormal];
    self.txtEmail.placeholder = NSLocalizedString(@"EMAIL", nil);
    
    self.navigationController.navigationBarHidden = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.btnForget setTitle:NSLocalizedString(@"FORGOT_PASSWORD", nil) forState:UIControlStateNormal];
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}
-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark-
#pragma mark- Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField     //Hide the keypad when we pressed return
{
    [self.txtEmail resignFirstResponder];
    return YES;
}

- (IBAction)forgotBtnPressed:(id)sender
{
    if(self.txtEmail.text.length < 1)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if([[UtilityClass sharedObject]isValidEmailAddress:self.txtEmail.text])
        {
            if([[AppDelegate sharedAppDelegate]connected])
            {
                [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"SENDING MAIL", nil)];
                
                NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                [dictParam setValue:self.txtEmail.text forKey:PARAM_EMAIL];
                [dictParam setValue:@"1" forKey:@"type"];
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_FORGOT_PASSWORD withParamData:dictParam withBlock:^(id response, NSError *error)
                 {
                     [[AppDelegate sharedAppDelegate]hideLoadingView];
                     if (response)
                     {
                         if([[response valueForKey:@"success"] boolValue])
                         {
                             [APPDELEGATE showToastMessage:NSLocalizedString(@"PASSWORD_SENT_SUCCESS", nil)];
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                         else
                         {
                             NSString *str=[NSString stringWithFormat:@"%@",[response valueForKey:@"error"]];
                             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[afn getErrorMessage:str] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                             [alert show];
                         }
                     }
                 }];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status" message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_VALID_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
