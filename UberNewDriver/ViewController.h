//
//  ViewController.h
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : BaseVC <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblCopyrights;
@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
@property (strong, nonatomic) IBOutlet UIButton *btnRegister;

@property (weak, nonatomic) IBOutlet UIImageView *testImage;
- (IBAction)onClickRegister:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewForSplashBG;

// view note
@property (weak, nonatomic) IBOutlet UIView *viewNote;
@property (weak, nonatomic) IBOutlet UILabel *lblImpNote;
@property (weak, nonatomic) IBOutlet UITextView *txtNote;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;
-(IBAction)onClickOK:(id)sender;

-(IBAction)onUnwindForLogout:(UIStoryboardSegue*)segueIdentifire;

@end
