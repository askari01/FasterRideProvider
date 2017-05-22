//
//  HistoryDetailVC.h
//  Rider Driver
//
//  Created by My Mac on 7/8/15.
//  Copyright (c) 2015 Elluminati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface HistoryDetailVC : BaseVC<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UITextField *txtSource;
    __weak IBOutlet UITextField *txtDestination;

    __weak IBOutlet UIView *viewForLocationInfo;
    
    __weak IBOutlet UILabel *lblMinutes;
    __weak IBOutlet UILabel *lblDistance;
    __weak IBOutlet UILabel *lblCost;
    
    __weak IBOutlet UITableView *tableForIssue;
    
    __weak IBOutlet UIImageView *mapImgView;
    
    NSString *strID;
    
}

@property (strong,nonatomic) NSDictionary *dictInfo;
@property (strong,nonatomic) IBOutlet UIButton *btnBack;

- (IBAction)btnNeedHelpPressed:(id)sender;
- (IBAction)btnBackPressed:(id)sender;
- (IBAction)btnSharePressed:(id)sender;

@end