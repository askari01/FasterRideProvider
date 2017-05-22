//
//  SideBarVC.h
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"
#import "SWRevealViewController.h"
#import "PickMeUpMapVC.h"
#import "CustomAlert.h"

//@protocol timerProtocol <NSObject>
//
//-(void)invalidateTimer;
//
//@end

@interface SideBarVC : BaseVC <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,CustomAlertDelegate>
{
    BOOL internet;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) PickMeUpMapVC *ViewObj;
@property (nonatomic, weak) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblSoundStatus;
@property (weak, nonatomic) IBOutlet UIView *viewForMenu;
@property (strong, nonatomic) IBOutlet UIButton *bntSound;
- (IBAction)pressSoundBtn:(id)sender;
//@property (strong,nonatomic) id <timerProtocol> delegate;
@end
