//
//  HistoryVC.m
//  UberforX Provider
//
//  Created by My Mac on 11/15/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "HistoryVC.h"
#import "HistoryCell.h"
#import "HistoryDetailVC.h"
#import "UIImageView+Download.h"
#import "UtilityClass.h"
#import "PickMeUpMapVC.h"
#import "ArrivedMapVC.h"
#import "FeedBackVC.h"

@interface HistoryVC ()
{
    NSMutableArray *arrHistory;
    NSMutableArray *arrForDate;
    NSMutableArray *arrForSection;
    
}

@end

@implementation HistoryVC

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark-
#pragma mark- View Delegate Method

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLocalization];
    arrHistory=[[NSMutableArray alloc]init];
    self.navigationItem.hidesBackButton=YES;
    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOADING_HISTORY", nil)];
    [self getHistory];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tableView.hidden=NO;
    self.imgNoDisplay.hidden=YES;
    self.navigationController.navigationBarHidden=NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.btnMenu setTitle:NSLocalizedString(@"History", nil) forState:UIControlStateNormal];
}

-(void)setLocalization
{
    self.lblTo.text = NSLocalizedString(@"to", nil);
    self.lblFrom.text = NSLocalizedString(@"from", nil);
    [self.btnTo setTitle:NSLocalizedString(@"Select date", nil) forState:UIControlStateNormal];
    [self.btnTo setTitle:NSLocalizedString(@"Select date", nil) forState:UIControlStateSelected];
    [self.btnFrom setTitle:NSLocalizedString(@"Select date", nil) forState:UIControlStateNormal];
    [self.btnFrom setTitle:NSLocalizedString(@"Select date", nil) forState:UIControlStateSelected];
}

#pragma mark-
#pragma mark- Get History API Method

-(void)getHistory
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        NSString * strForUserId=[PREF objectForKey:PREF_USER_ID];
        NSString * strForUserToken=[PREF objectForKey:PREF_USER_TOKEN];
        
        
        NSMutableString *pageUrl=[NSMutableString stringWithFormat:@"%@?%@=%@&%@=%@",FILE_HISTORY,PARAM_ID,strForUserId,PARAM_TOKEN,strForUserToken];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:pageUrl withParamData:nil withBlock:^(id response, NSError *error)
         {
             
             NSLog(@"History Data= %@",response);
             [APPDELEGATE hideLoadingView];
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     
                     arrHistory=[response valueForKey:@"requests"];
                     NSLog(@"History count = %lu",(unsigned long)arrHistory.count);
                     if (arrHistory.count==0 || arrHistory==nil)
                     {
                         self.tableView.hidden=YES;
                         self.imgNoDisplay.hidden=NO;
                     }
                     else
                     {
                         [self makeSection];
                         self.tableView.hidden=NO;
                         self.imgNoDisplay.hidden=YES;
                         [self.tableView reloadData];
                     }
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
             }
         }];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet" message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark
#pragma mark date selection

- (IBAction)btnFromDatePressed:(id)sender
{
    from = YES;
    
    NSDate *now = [NSDate date];
    [self.historyPicker setMaximumDate:now];
    
    if (![self.btnTo.titleLabel.text isEqualToString:@"Select date"])
    {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * date = [dateFormatter dateFromString:self.btnTo.titleLabel.text];
        self.historyPicker.maximumDate=date;
        self.historyPicker.minimumDate=nil;
    }
    [self.viewForDatePicker setHidden:NO];
    [self.lblBackground setHidden:NO];
}

- (IBAction)btnToDatePressed:(id)sender
{
    
    from = NO;
    
    NSDate *now = [NSDate date];
    [self.historyPicker setMaximumDate:now];
    
    if (![self.btnFrom.titleLabel.text isEqualToString:@"Select date"])
    {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate * date = [dateFormatter dateFromString:self.btnFrom.titleLabel.text];
        self.historyPicker.minimumDate=date;
    }
    
    [self.viewForDatePicker setHidden:NO];
    [self.lblBackground setHidden:NO];
    
}

- (IBAction)btnDonePressed:(id)sender {
    
    [self.lblBackground setHidden:YES];
    
    [self.viewForDatePicker setHidden:YES];
    
    NSString *date = [NSString stringWithFormat:@"%@",[[UtilityClass sharedObject] DateToString:self.historyPicker.date withFormate:@"yyyy-MM-dd"]];
    
    
    if (from)
    {
        [self.btnFrom setTitle:date forState:UIControlStateNormal];
    }
    
    else
    {
        [self.btnTo setTitle:date forState:UIControlStateNormal];
    }
}

- (IBAction)btnSearchHistoryPressed:(id)sender {
    
    if (![self.btnFrom.titleLabel.text isEqualToString:@"Select date"] && ![self.btnTo.titleLabel.text isEqualToString:@"Select date"])
    {
        if([[AppDelegate sharedAppDelegate]connected])
        {
            [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING_HISTORY", nil)];
            [self.tableView setHidden:YES];
            
            NSString * strForUserId=[PREF objectForKey:PREF_USER_ID];
            NSString * strForUserToken=[PREF objectForKey:PREF_USER_TOKEN];
            
            
            NSMutableString *pageUrl=[NSMutableString stringWithFormat:@"%@?%@=%@&%@=%@&from_date=%@&to_date=%@",FILE_HISTORY,PARAM_ID,strForUserId,PARAM_TOKEN,strForUserToken,self.btnFrom.titleLabel.text,self.btnTo.titleLabel.text];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
            [afn getDataFromPath:pageUrl withParamData:nil withBlock:^(id response, NSError *error)
             {
                 
                 NSLog(@"History Data= %@",response);
                 [APPDELEGATE hideLoadingView];
                 if (response)
                 {
                     if([[response valueForKey:@"success"] intValue]==1)
                     {
                         arrHistory=[response valueForKey:@"requests"];
                         NSLog(@"History count = %lu",(unsigned long)arrHistory.count);
                         if (arrHistory.count==0 || arrHistory==nil)
                         {
                             self.tableView.hidden=YES;
                             self.imgNoDisplay.hidden=NO;
                         }
                         else
                         {
                             self.tableView.hidden=NO;
                             self.imgNoDisplay.hidden=YES;
                             [self makeSection];
                             [self.tableView reloadData];
                             
                         }
                         
                     }else
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
                 }
                 
             }];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No Internet" message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
}


- (IBAction)btnNavBackPressed:(id)sender
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
}

#pragma mark-
#pragma mark - Table view data source

-(void)makeSection
{
    arrForDate=[[NSMutableArray alloc]init];
    arrForSection=[[NSMutableArray alloc]init];
    NSMutableArray *arrtemp=[[NSMutableArray alloc]init];
    [arrtemp addObjectsFromArray:arrHistory];
    NSSortDescriptor *distanceSortDiscriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO
                                                                              selector:@selector(localizedStandardCompare:)];
    
    [arrtemp sortUsingDescriptors:@[distanceSortDiscriptor]];
    
    for (int i=0; i<arrtemp.count; i++)
    {
        NSMutableDictionary *dictDate=[[NSMutableDictionary alloc]init];
        dictDate=[arrtemp objectAtIndex:i];
        
        NSString *temp=[dictDate valueForKey:@"date"];
        NSArray *arrDate=[temp componentsSeparatedByString:@" "];
        NSString *strdate=[arrDate objectAtIndex:0];
        if(![arrForDate containsObject:strdate])
        {
            [arrForDate addObject:strdate];
        }
        
    }
    
    for (int j=0; j<arrForDate.count; j++)
    {
        NSMutableArray *a=[[NSMutableArray alloc]init];
        [arrForSection addObject:a];
    }
    for (int j=0; j<arrForDate.count; j++)
    {
        NSString *strTempDate=[arrForDate objectAtIndex:j];
        
        for (int i=0; i<arrtemp.count; i++)
        {
            NSMutableDictionary *dictSection=[[NSMutableDictionary alloc]init];
            dictSection=[arrtemp objectAtIndex:i];
            NSArray *arrDate=[[dictSection valueForKey:@"date"] componentsSeparatedByString:@" "];
            NSString *strdate=[arrDate objectAtIndex:0];
            if ([strdate isEqualToString:strTempDate])
            {
                [[arrForSection objectAtIndex:j] addObject:dictSection];
                
            }
        }
        
    }
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return arrForSection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[arrForSection objectAtIndex:section] count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section/
//{
//    return 0.0;
//≥≥}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
    UILabel *lblDate=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 15)];
    lblDate.font=[UberStyleGuide fontRegular:13.0f];
    // lblDate.textColor=[UberStyleGuide colorDefault];
    NSString *strDate=[arrForDate objectAtIndex:section];
    NSString *current=[[UtilityClass sharedObject] DateToString:[NSDate date] withFormate:@"yyyy-MM-dd"];
    
    
    ///   YesterDay Date Calulation
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -1;
    NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                   toDate:[NSDate date]
                                                  options:0];
    NSString *strYesterday=[[UtilityClass sharedObject] DateToString:yesterday withFormate:@"yyyy-MM-dd"];
    
    
    if([strDate isEqualToString:current])
    {
        lblDate.text=@"Today";
        // headerView.backgroundColor=[UberStyleGuide colorDefault];
        lblDate.textColor=[UIColor blackColor];
    }
    else if ([strDate isEqualToString:strYesterday])
    {
        lblDate.text=@"Yesterday";
    }
    else
    {
        NSDate *date=[[UtilityClass sharedObject]stringToDate:strDate withFormate:@"yyyy-MM-dd"];
        NSString *text=[[UtilityClass sharedObject]DateToString:date withFormate:@"dd MMMM yyyy"];//2nd Jan 2015
        lblDate.text=text;
    }
    
    [headerView addSubview:lblDate];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    return headerView;
}



/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 return [arrForDate objectAtIndex:section];
 }*/

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIImageView *imgFooter=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rectangle2"]];
//    return imgFooter;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"historycell";
    
    HistoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell==nil)
    {
        cell=[[HistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSMutableDictionary *pastDict=[[arrForSection objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSMutableDictionary *dictOwner=[pastDict valueForKey:@"owner"];
    
    cell.lblName.text=[NSString stringWithFormat:@"%@ %@",[dictOwner valueForKey:@"first_name"],[dictOwner valueForKey:@"last_name"]];
    cell.lblType.text=[NSString stringWithFormat:@"%@",[dictOwner valueForKey:@"phone"]];
    cell.lblPrice.text=[NSString stringWithFormat:@"%@%.2f",[pastDict valueForKey:@"currency"],[[pastDict valueForKey:@"total"] floatValue]];
    
    NSDate *dateTemp=[[UtilityClass sharedObject]stringToDate:[pastDict valueForKey:@"date"]];
    NSString *strDate=[[UtilityClass sharedObject]DateToString:dateTemp withFormate:@"hh:mm a"];
    
    cell.lblTime.text=[NSString stringWithFormat:@"%@",strDate];
    
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mapbox"]];
    
    NSString *imagePath = [NSString stringWithFormat:@"%@",[pastDict valueForKey:@"map_url"]];
    
    [cell.imageView downloadFromURL:imagePath withPlaceholder:[UIImage imageNamed:@"no_items_display"]] ;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    passHistory =[[arrForSection objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    
    NSLog(@"Payment Detail:- %@",passHistory);
    
    [self performSegueWithIdentifier:@"segueToHistoryDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToHistoryDetail"])
    {
        HistoryDetailVC *history = [segue destinationViewController];
        history.dictInfo = passHistory;
    }
}

@end
