//
//  GoogleUtility.m
//  TaxiAnytimeAnywhereProvider
//
//  Created by Elluminati Mini Mac 5 on 22/08/16.
//  Copyright © 2016 Elluminati Mini Mac 5. All rights reserved.
//

#import "GoogleUtility.h"
#import "AppDelegate.h"
//#import "NSObject+Constants.h"
@implementation GoogleUtility
{
    LoginCompletionBlock _operationWhenLoginFinished; // instance variable
}
-(id) init{
    if((self = [super init]))
    {
        [GIDSignIn sharedInstance].uiDelegate = self;
        [GIDSignIn sharedInstance].delegate = self;
    }
    return self;
}
-(void)dealloc
{
    [GIDSignIn sharedInstance].uiDelegate = nil;
    [GIDSignIn sharedInstance].delegate = nil;
}
+ (GoogleUtility *)sharedObject
{
    static GoogleUtility *objUtility = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objUtility = [[GoogleUtility alloc] init];
    });
    return objUtility;
}

-(void)signInGoogle:(LoginCompletionBlock)isLogin withParent:(UIViewController *)parent
{
    _parent=parent;
    [[GIDSignIn sharedInstance] signIn];
    [self waitAndPerformOperation:isLogin];
}
-(void)waitAndPerformOperation:(LoginCompletionBlock)operation
{
    if(_operationWhenLoginFinished != nil)
    {
        operation=_operationWhenLoginFinished;
        _operationWhenLoginFinished = nil;
    }
    else
    {
        _operationWhenLoginFinished = operation;
    }
}

#pragma mark-GOOGLE DELEGATE


- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    
}
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [APPDELEGATE hideLoadingView];
    [_parent presentViewController:viewController animated:YES completion:nil];
}
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [_parent dismissViewControllerAnimated:YES completion:nil];
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error
{
    /*if(_operationWhenLoginFinished != nil)
    {
        [self waitAndPerformOperation:_operationWhenLoginFinished];
       
    }
    else
    {
    */
        if (error == nil)
            _operationWhenLoginFinished(TRUE,user,nil);
    
        else
            _operationWhenLoginFinished(FALSE,nil,error);
    
    /*}*/
    
}

@end
