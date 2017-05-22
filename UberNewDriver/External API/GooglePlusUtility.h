//
//  GooglePlusUtility.h
//  JTravel
//
//  Created by Elluminati - macbook on 07/07/14.
//  Copyright (c) 2014 innoways. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlus/GooglePlus.h>

#define kClientId @"64484691710-fat2dldip8mnij276j4fnolrfhk9nofa.apps.googleusercontent.com"


typedef void (^LoginGoogleCompletionBlock)(id response, NSError *error);

@interface GooglePlusUtility : NSObject<GPPSignInDelegate>
{
    LoginGoogleCompletionBlock complateLogin;
}
@property(nonatomic,strong)UIViewController *vcBase;

+ (GooglePlusUtility *)sharedObject;
-(BOOL)isLogin;
-(void)loginWithBlock:(LoginGoogleCompletionBlock)block;
-(void)shareImage:(UIImage *)img;

@end
