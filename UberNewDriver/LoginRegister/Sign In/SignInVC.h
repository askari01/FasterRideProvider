//
//  SignInVC.h
//  UberNewDriver
//
//  Created by Elluminati on 27/09/14.
//  Copyright (c) 2014 Elluminati. All rights reserved.
//

#import "BaseVC.h"


@interface SignInVC : BaseVC <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnNav_Register;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *typeCollectionView;

@property (weak, nonatomic) IBOutlet UIView *viewForbg;
- (IBAction)faceBookBtnPressed:(id)sender;
- (IBAction)selectCountryBtnPressed:(id)sender;
- (IBAction)googleBtnPressed:(id)sender;
- (IBAction)doneBtnPressed:(id)sender;
- (IBAction)cancelBtnPressed:(id)sender;
- (IBAction)saveBtnPressed:(id)sender;
- (IBAction)imgPickBtnPressed:(id)sender;

- (IBAction)backBtnPressed:(id)sender;



@property (weak, nonatomic) IBOutlet UIView *viewForPicker;
@property (weak, nonatomic) IBOutlet UIButton *btnCountryCode;
@property (weak, nonatomic) IBOutlet UIButton *btnRegisterTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnFacebook;
@property (weak, nonatomic) IBOutlet UIImageView *imgProPic;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UITextField *txtRePassword;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtBio;
@property (weak, nonatomic) IBOutlet UITextField *txtZipcode;
@property (weak, nonatomic) IBOutlet UITextField *txtNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtType;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UITextField *txtTaxiModel;
@property (weak, nonatomic) IBOutlet UITextField *txtTaxiNumber;

@property (weak, nonatomic) IBOutlet UILabel *lblRegisterWith;
@property (weak, nonatomic) IBOutlet UILabel *lblUploadPictureFrom;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblBio;
@property (weak, nonatomic) IBOutlet UILabel *lblZipcode;
@property (weak, nonatomic) IBOutlet UILabel *lblTaxiModel;
@property (weak, nonatomic) IBOutlet UILabel *lblTaxiNumber;

- (IBAction)typeBtnPressed:(id)sender;
- (IBAction)pickDoneBtnPressed:(id)sender;
- (IBAction)pickCancelBtnPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *pickTypeView;
@property (weak, nonatomic) IBOutlet UIPickerView *typePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
- (IBAction)termsBtnPressed:(id)sender;
- (IBAction)checkBtnPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnTerms;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)selectServiceBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectService;
@property (weak, nonatomic) IBOutlet UIButton *btnAgreeCondtion;

- (IBAction)onClickCarModelInfo:(id)sender;
- (IBAction)onClickCarNumberInfo:(id)sender;

- (IBAction)onClickEmailInfo:(id)sender;
- (IBAction)onClickInfo:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imgInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;


@property (weak, nonatomic) IBOutlet UIImageView *imgCarModelInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblCarModelInfo;

@property (weak, nonatomic) IBOutlet UIImageView *imgCarNumberInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblCarNumberInfo;

@property (weak, nonatomic) IBOutlet UIImageView *imgEmailInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailInfo;

- (IBAction)clickCameraBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnCameraPress;
@property (strong, nonatomic) IBOutlet UIButton *btnPicturePress;
- (IBAction)clickPictureBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewForPassword;
@property (weak, nonatomic) IBOutlet UIView *viewWithoutPassword;

@end
