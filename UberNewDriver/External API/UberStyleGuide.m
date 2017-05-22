//
//  UberStyleGuide.m
//  UberforXOwner
//
//  Created by Elluminati - macbook on 08/01/15.
//  Copyright (c) 2015 Elluminati. All rights reserved.
//

#import "UberStyleGuide.h"

@implementation UberStyleGuide

#pragma mark- Color


+(UIColor *)colorDefault

{
    UIColor *regularColor= [UIColor colorWithRed:(255.0f/255.0f) green:(156.0f/255.0f) blue:(62.0f/255.0f) alpha:1.0];
    return regularColor;
}

#pragma mark - Fonts

/*
 2015-09-03 16:07:34.936 TaxiNow Driver[2963:103853] Font  Avenir LT Std: (
 "AvenirLTStd-Oblique",
 "AvenirLTStd-Medium",
 "AvenirLTStd-Book",
 "AvenirLTStd-Roman",
 "AvenirLTStd-Light",
 "AvenirLTStd-MediumOblique",
 "AvenirLTStd-LightOblique",
 "AvenirLTStd-BookOblique"
 )
 */

+ (UIFont *)fontRegularLight
{
    return [UIFont fontWithName:@"AvenirLTStd-Light" size:15.43f];
//    return [UIFont fontWithName:@"OpenSans-Light" size:17.5f];
}

+ (UIFont *)fontRegular
{
    //return [UIFont fontWithName:@"OpenSans-Regular" size:14.0f];
    return [UIFont fontWithName:@"AvenirLTStd-Black" size:13.0f];
}

+ (UIFont *)fontRegular:(CGFloat)size
{
    return [UIFont fontWithName:@"AvenirLTStd-Medium" size:size];
}

+ (UIFont *)fontRegularBold
{
    
    return [UIFont fontWithName:@"AvenirLTStd-Roman" size:13.0f];
}

+ (UIFont *)fontSemiBold
{
    
    return [UIFont fontWithName:@"AvenirLTStd-Book" size:13.0f];
}

+ (UIFont *)fontSemiBold:(CGFloat)size
{
    return [UIFont fontWithName:@"AvenirLTStd-Book" size:size];
}


+ (UIFont *)fontRegularBold:(CGFloat)size
{
    return [UIFont fontWithName:@"AvenirLTStd-Roman" size:size];
}

+ (UIFont *)fontButtonBold {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
}

+ (UIFont *)fontLarge {
    return [UIFont fontWithName:@"HelveticaNeue" size:21.0f];
}

+ (UIFont *)fontRegularLight:(CGFloat)size
{
    return [UIFont fontWithName:@"OpenSans-Light" size:size];
}


+ (UIFont *)fontAvenirLight65
{
    return [UIFont fontWithName:@"AvenirLTStd-Medium" size:10.30f];
}

+ (UIFont *)fontAvenirLight65:(CGFloat)size
{
    return [UIFont fontWithName:@"AvenirLTStd-Medium" size:size];
}

+(UIColor *)fontColor
{
    
     return [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

+(UIColor *)fontColorNevigation
{
   // return [UIColor colorWithRed:112.0f/255.0f green:112.0f/255.0f blue:112.0f/255.0f alpha:1.0f];
    return [UIColor colorWithRed:29.0f/255.0f green:29.0f/255.0f blue:29.0f/255.0f alpha:1.0f];
}



@end
