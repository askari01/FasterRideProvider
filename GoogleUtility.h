//
//  GoogleUtility.h
//  TaxiAnytimeAnywhereProvider
//
//  Created by Elluminati Mini Mac 5 on 22/08/16.
//  Copyright © 2016 Elluminati Mini Mac 5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>
//@import Firebase;

typedef void (^LoginCompletionBlock)(BOOL success,GIDGoogleUser *user,NSError *error);
@interface GoogleUtility : NSObject <GIDSignInDelegate,GIDSignInUIDelegate>
{
    NSString *strFirstName,*strLastName,*strSocialUniqueId,*strEmail;
    UIImage *imgProfilePic;
}
+ (GoogleUtility *)sharedObject;
-(void)signInGoogle:(LoginCompletionBlock)isLogin withParent:(UIViewController *)parent;

@property(strong,nonatomic)id parent;


@end
