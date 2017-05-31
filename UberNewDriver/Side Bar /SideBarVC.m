//
//  SideBarVC.m
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "SideBarVC.h"
#import "SWRevealViewController.h"
#import "PickMeUpMapVC.h"
#import "CellSlider.h"
#import "UIView+Utils.h"
#import "UIImageView+Download.h"
#import "CustomAlert.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface SideBarVC ()
{
    NSMutableArray *arrImages,*arrListName,*arrIdentifire;
    NSMutableString *strUserId;
    NSMutableString *strUserToken;
}

@end

@implementation SideBarVC

@synthesize ViewObj;


#pragma mark - Init

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
    [self.view setBackgroundColor:[UIColor clearColor]];
    [super viewDidLoad];
    internet=[APPDELEGATE connected];
	[self.viewForMenu setBackgroundColor:MenuViewColor];
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self.view setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, 230, self.view.bounds.size.height)];
    

    strUserId=[PREF objectForKey:PREF_USER_ID];
    strUserToken=[PREF objectForKey:PREF_USER_TOKEN];
    
    [self.imgProfilePic applyRoundedCornersFullWithColor:[UIColor whiteColor]];
    [self.imgProfilePic downloadFromURL:[arrUser valueForKey:PREF_USER_PICTURE] withPlaceholder:nil];
    self.lblName.font=[UberStyleGuide fontRegularBold:18.0f];
    self.lblName.text=[NSString stringWithFormat:@"%@ %@",[arrUser valueForKey:@"first_name"],[arrUser valueForKey:@"last_name"]];
	
    arrListName=[[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"PROFILE",nil),NSLocalizedString(@"History",nil),NSLocalizedString(@"Share",nil),NSLocalizedString(@"HELP",nil),nil];
    
    arrIdentifire=[[NSMutableArray alloc] initWithObjects:SEGUE_PROFILE,SEGUE_HISTORY,SEGUE_SHARE,SEGUE_HELP, nil];
    
    arrImages=[[NSMutableArray alloc]initWithObjects:@"nav_profile",@"ub__nav_history",@"nav_referral",@"nav_share",nil,nil];
	
    NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
    NSMutableArray *arrImg=[[NSMutableArray alloc]init];
    for (int i=0; i<arrPage.count; i++)
    {
        NSMutableDictionary *temp1=[arrPage objectAtIndex:i];
        [arrTemp addObject:[temp1 valueForKey:@"title"]];
        [arrImg addObject:@"nav_support"];
    }
    
    [arrListName addObjectsFromArray:arrTemp];
    [arrIdentifire addObjectsFromArray:arrTemp];
    
    [arrImages addObjectsFromArray:arrImg];
    [arrListName addObject:NSLocalizedString(@"LOG OUT", nil)];
    [arrImages addObject:@"ub__nav_logout"];
    
    self.navigationItem.leftBarButtonItem=nil;
    
    self.tableView.backgroundView=nil;
    self.tableView.backgroundColor=[UIColor clearColor];
    
    NSString *strSoundStatus = [PREF objectForKey:@"SoundStatus"];
    
    if ([[PREF valueForKey:@"SOUND"] isEqualToString:@"on"])
    {
        [self.bntSound setImage:[UIImage imageNamed:@"soundOn"] forState:UIControlStateNormal];
        self.lblSoundStatus.text = NSLocalizedString(@"ON", nil);
    }
    else
    {
        [self.bntSound setImage:[UIImage imageNamed:@"soundOff"] forState:UIControlStateNormal];
        self.lblSoundStatus.text = NSLocalizedString(@"OFF", nil);
    }
    /*
    if ([strSoundStatus isEqualToString:NSLocalizedString(@"ON", nil)])
    {
        [self.bntSound setImage:[UIImage imageNamed:@"soundOff"] forState:UIControlStateNormal];
        self.lblSoundStatus.text = NSLocalizedString(@"OFF", nil);
    }
    else
    {
        [self.bntSound setImage:[UIImage imageNamed:@"soundOn"] forState:UIControlStateNormal];
        self.lblSoundStatus.text = NSLocalizedString(@"ON", nil);
        
    }
    */
}

#pragma mark - TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrListName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellSlider *cell=(CellSlider *)[tableView dequeueReusableCellWithIdentifier:@"CellSlider"];
    if (cell==nil) {
        cell=[[CellSlider alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellSlider"];
    }
    cell.lblName.font=[UberStyleGuide fontRegular:15.43f];
    cell.lblName.text=[arrListName objectAtIndex:indexPath.row];
    cell.imgIcon.image=[UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
    
    //[cell setCellData:[arrSlider objectAtIndex:indexPath.row] withParent:self];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([[arrListName objectAtIndex:indexPath.row]isEqualToString:NSLocalizedString(@"LOG OUT", nil)])
    {
        /*
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"LOG OUT", nil)  message:NSLocalizedString(@"Are Sure You want to log Out", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"NO", nil) otherButtonTitles:NSLocalizedString(@"YES", nil), nil];
        alert.tag=100;
        [alert show];
        */
        CustomAlert *alert = [[CustomAlert alloc] initWithTitle:NSLocalizedString(@"LOG OUT", nil) message:NSLocalizedString(@"Are Sure You want to log Out", nil) delegate:self cancelButtonTitle:@"" otherButtonTitle:@""];
       // alert.tag=100;
       // [self.view setUserInteractionEnabled:FALSE];
        //[alert showInView:self.view];
        
        [APPDELEGATE.window addSubview:alert];
        [APPDELEGATE.window bringSubviewToFront:alert];
        [self.revealViewController rightRevealToggle:self];
        
        return;
    }
    if ([[arrListName objectAtIndex:indexPath.row]isEqualToString:NSLocalizedString(@"Share", nil)])
    {
        NSLog(@"shareButton pressed");
        
        NSString *texttoshare = @"https://itunes.apple.com/us/app/cabanytimeprovider/id1166187336?ls=1&mt=8"; //this is your text string to share
        //UIImage *imagetoshare = @""; //this is your image to share
        NSArray *activityItems = @[texttoshare];
        
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
        [self presentViewController:activityVC animated:TRUE completion:nil];

        return;
    }
    if ([[arrListName objectAtIndex:indexPath.row]isEqualToString:NSLocalizedString(@"help", nil)])
    {
        NSLog(@"helpButton pressed");
        return;
    }
    
    if ((indexPath.row >3)&&(indexPath.row<(arrListName.count-1)))
    {
        [self.revealViewController rightRevealToggle:self];
        
        UINavigationController *nav=(UINavigationController *)self.revealViewController.frontViewController;
        
        ViewObj=(PickMeUpMapVC *)[nav.childViewControllers objectAtIndex:0];
        

        NSDictionary *dictTemp=[arrPage objectAtIndex:indexPath.row-3];
              
        [ViewObj performSegueWithIdentifier:@"contact us" sender:dictTemp];
        return;
    }
    [self.revealViewController rightRevealToggle:self];
    
    UINavigationController *nav=(UINavigationController *)self.revealViewController.frontViewController;
    
    ViewObj=(PickMeUpMapVC *)[nav.childViewControllers objectAtIndex:0];
    
    if(ViewObj!=nil)
    {
        [ViewObj performSegueWithIdentifier:[arrIdentifire objectAtIndex:indexPath.row] sender:self];
    }
        //[ViewObj goToSetting:[[arrListName objectAtIndex:indexPath.row] lowercaseString]];
}

#pragma mark - Alert Button Clicked Event


- (void)customAlertView:(CustomAlert*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.view setUserInteractionEnabled:YES];
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"WAITING_LOGOUT", nil)];
        
        
        if([APPDELEGATE connected])
        {
            NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
            [dictparam setObject:strUserId forKey:PARAM_ID];
            [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_LOGOUT withParamData:dictparam withBlock:^(id response, NSError *error)
             {
                 NSLog(@"Log Out= %@",response);
                 [APPDELEGATE hideLoadingView];
                 if (response)
                 {
                     if([[response valueForKey:@"success"] intValue]==1)
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
                         
                         //                                 if ([self.delegate respondsToSelector:@selector(invalidateTimer)])
                         //                                 {
                         //                                     [self.delegate invalidateTimer];
                         //                                 }
                         
                         
                         [self.navigationController   popToRootViewControllerAnimated:YES];
                         [APPDELEGATE showToastMessage:NSLocalizedString(@"LOGED_OUT", nil)];
                         [alertView removeFromSuperview];
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
    else if (buttonIndex == 1)
    {
        [self.view setUserInteractionEnabled:YES];
        //[alertView removeFromSuperview];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 100)
    {
    }
    if (buttonIndex == 1)
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"WAITING_LOGOUT", nil)];
        
        
        if([APPDELEGATE connected])
        {
            
            NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
            
            [dictparam setObject:strUserId forKey:PARAM_ID];
            [dictparam setObject:strUserToken forKey:PARAM_TOKEN];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_LOGOUT withParamData:dictparam withBlock:^(id response, NSError *error)
             {
                 
                 NSLog(@"Log Out= %@",response);
                 [APPDELEGATE hideLoadingView];
                 if (response)
                 {
                     if([[response valueForKey:@"success"] intValue]==1)
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
                         
                         [self.navigationController popToRootViewControllerAnimated:YES];
                         [APPDELEGATE showToastMessage:NSLocalizedString(@"LOGED_OUT", nil)];
                         
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

}

#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

#pragma mark 
#pragma mark - sound button click event

- (IBAction)pressSoundBtn:(id)sender
{
    
    NSString *strSoundStatus = [PREF objectForKey:@"SoundStatus"];
    
    if ([strSoundStatus isEqualToString:NSLocalizedString(@"ON", nil)])
    {
        [self.bntSound setImage:[UIImage imageNamed:@"soundOff"] forState:UIControlStateNormal];
        self.lblSoundStatus.text = NSLocalizedString(@"OFF", nil);
        [PREF setObject:@"off" forKey:@"SOUND"];
        [PREF synchronize];
    }
    else
    {
        [self.bntSound setImage:[UIImage imageNamed:@"soundOn"] forState:UIControlStateNormal];
        self.lblSoundStatus.text = NSLocalizedString(@"ON", nil);
        [PREF setObject:@"on" forKey:@"SOUND"];
        [PREF synchronize];
        
    }
    [PREF setObject:self.lblSoundStatus.text forKey:@"SoundStatus"];
    [PREF synchronize];
}
@end
