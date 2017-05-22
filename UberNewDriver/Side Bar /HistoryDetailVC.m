//
//  HistoryDetailVC.m
//  Rider Driver
//
//  Created by My Mac on 7/8/15.
//  Copyright (c) 2015 Elluminati. All rights reserved.
//

#import "HistoryDetailVC.h"
#import "AFNHelper.h"

#import "UIImageView+Download.h"


@interface HistoryDetailVC ()

@end

@implementation HistoryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOADING_HISTORY", nil)];
    self.navigationItem.hidesBackButton = YES;
       // [self downloadCover];
    [self setTripDetails];
    [self.btnBack setTitle:NSLocalizedString(@"History", nil) forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTripDetails
{
    [lblCost setText:[NSString stringWithFormat:@"%@ %.2f",[self.dictInfo valueForKey:@"currency"],[[self.dictInfo objectForKey:@"total"] floatValue]]];
    [lblMinutes setText:[NSString stringWithFormat:@"%.2f mins",[[self.dictInfo objectForKey:@"time"] floatValue]]];
    [lblDistance setText:[NSString stringWithFormat:@"%.2f kms",[[self.dictInfo objectForKey:@"distance"] floatValue]]];
    
    [txtSource setText:[NSString stringWithFormat:@"%@",[self.dictInfo objectForKey:@"src_address"]]];
    [txtDestination setText:[NSString stringWithFormat:@"%@",[self.dictInfo objectForKey:@"dest_address"]]];
    
    [mapImgView downloadFromURL:[self.dictInfo objectForKey:@"map_url"] withPlaceholder:[UIImage imageNamed:@"no_items_display"]];
    [APPDELEGATE hideLoadingView];
   // [mapImgView downloadFromURL:[self.dictInfo objectForKey:@"map_url"] withPlaceholder:nil];
   // [mapImgView  setImageWithURL:[self.dictInfo objectForKey:@"map_url"] placeholderImage:[UIImage imageNamed:@"no_items_display"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

//-(void)downloadCover
//{
//    NSString *imageFile = [self.dictInfo objectForKey:@"map_url"];
//
//    [self.actIndicator startAnimating];
//    if ([imageFile rangeOfString:@"/Library/"].location != NSNotFound)
//    {
//        [self.actIndicator stopAnimating];
//        NSData *imageData=[NSData dataWithContentsOfFile:imageFile];
//        UIImage* image = [[UIImage alloc] initWithData:imageData];
//        if (image) {
//            [mapImgView setImage:image];
//            imageData = nil;
//        }
//        
//        return;
//    }
//    
//    NSString *strImgName = [[[imageFile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] componentsSeparatedByString:@"/"] lastObject];
//    AppDelegate *app=[[UIApplication sharedApplication]delegate];
//    
//    [app applicationCacheDirectoryString];
//    
//    // NSString *imagePath = [NSString stringWithFormat:@"%@%@",[[AppDelegate sharedObject]applicationCacheDirectoryString],strImgName];
//    
//    
//    NSString *imagePath = [NSString stringWithFormat:@"%@%@",[app applicationCacheDirectoryString],strImgName];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    NSString *aURL=[imageFile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    if([strImgName isEqualToString:@"picture?type=large"])
//    {
//        [fileManager removeItemAtPath:imagePath error:nil];
//    }
//    if ([fileManager fileExistsAtPath:imagePath]==NO)
//    {
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//        dispatch_async(queue, ^(void) {
//            
//            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:aURL]];
//            //[imageData writeToFile:imagePath atomically:YES];
//            
//            UIImage* image = [[UIImage alloc] initWithData:imageData];
//            UIImage *imgUpload = [[UtilityClass sharedObject]scaleAndRotateImage:image];
//            NSData *dataS = UIImagePNGRepresentation(imgUpload);
//            [dataS writeToFile:imagePath atomically:YES];
//            
//            imageData = nil;
//            if (imgUpload) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.actIndicator stopAnimating];
//                    [mapImgView setImage:image];
//                });
//            }
//            else
//            {
//                [self.actIndicator stopAnimating];
//            }
//        });
//    }
//    else{
//        [self.actIndicator stopAnimating];
//        NSData *imageData=[NSData dataWithContentsOfFile:imagePath];
//        UIImage* image = [[UIImage alloc] initWithData:imageData];
//        if (image) {
//            [mapImgView setImage:image];
//        }
//        imageData = nil;
//    }
//}



- (IBAction)btnBackPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
