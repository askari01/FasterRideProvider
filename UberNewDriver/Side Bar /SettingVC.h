//
//  SettingVC.h
//  UberforX Provider
//
//  Created by My Mac on 11/15/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"

@interface SettingVC : BaseVC
@property (weak, nonatomic) IBOutlet UISwitch *swAvailable;
@property (weak, nonatomic) IBOutlet UILabel *lblYes;
- (IBAction)backBtnPressed:(id)sender;
- (IBAction)setState:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblAvailable;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
- (IBAction)setSound:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *swSound;
@property (weak, nonatomic) IBOutlet UILabel *lblSound;
@property (weak, nonatomic) IBOutlet UILabel *lblSoundtext;
@property (strong, nonatomic) IBOutlet UIImageView *imgOnlineOffline;
@property (weak, nonatomic) IBOutlet UIImageView *imgBG;
@property (weak, nonatomic) IBOutlet UIView *viewForBG;


@property (strong, nonatomic) IBOutlet UIButton *btnGoOnline;
- (IBAction)clickGoOnline:(id)sender;

@end
