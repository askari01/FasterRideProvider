//
//  UberStyleGuide.h
//  UberforXOwner
//
//  Created by Elluminati - macbook on 08/01/15.
//  Copyright (c) 2015 Elluminati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UberStyleGuide : NSObject

//Color
+(UIColor *)colorDefault;

//fonts
+ (UIFont *)fontRegularLight;
+ (UIFont *)fontRegularLight:(CGFloat)size;
+ (UIFont *)fontRegular;
+ (UIFont *)fontRegular:(CGFloat)size;
+ (UIFont *)fontRegularBold;
+ (UIFont *)fontRegularBold:(CGFloat)size;
+ (UIFont *)fontSemiBold;
+ (UIFont *)fontSemiBold:(CGFloat)size;
+ (UIFont *)fontButtonBold;
+ (UIFont *)fontLarge;
+ (UIFont *)fontAvenirLight65;
+ (UIFont *)fontAvenirLight65:(CGFloat)size;
+ (UIColor *)fontColor;
+ (UIColor *)fontColorNevigation;


@end
