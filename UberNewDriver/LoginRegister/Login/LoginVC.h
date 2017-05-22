//
//  LoginVC.h
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"

@interface LoginVC : BaseVC <UITextFieldDelegate,UIScrollViewDelegate>

- (IBAction)onClickSignIn:(id)sender;
- (IBAction)googleBtnPressed:(id)sender;
- (IBAction)facebookBtnPressed:(id)sender;
- (IBAction)forgotBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property(nonatomic,weak)IBOutlet UIScrollView *scrLogin;

@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UILabel *lblPassword;
@property (strong, nonatomic) IBOutlet UILabel *lblUsername;
@property (strong, nonatomic) IBOutlet UIButton *btnDontHaveAccount;
@property (strong, nonatomic) IBOutlet UILabel *lblSignInWih;
@property (strong, nonatomic) IBOutlet UILabel *lblOr;
@property (weak, nonatomic) IBOutlet UIView *viewForSplashBG;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@end
