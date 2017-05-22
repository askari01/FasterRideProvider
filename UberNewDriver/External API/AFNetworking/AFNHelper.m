//
//  AFNHelper.m
//  Tinder
//
//  Created by Elluminati - macbook on 04/04/14.
//  Copyright (c) 2014 AppDupe. All rights reserved.
//

#import "AFNHelper.h"
#import "AFNetworking.h"

@implementation AFNHelper

@synthesize strReqMethod;

#pragma mark -
#pragma mark - Init

-(id)initWithRequestMethod:(NSString *)method
{
    if ((self = [super init])) {
        self.strReqMethod=method;
    }
    return self;
}

#pragma mark -
#pragma mark - Methods

-(void)getDataFromPath:(NSString *)path withParamData:(NSMutableDictionary *)dictParam withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    //[raw urlEncodeUsingEncoding:NSUTF8Encoding]
    
    NSRange match;
    match = [path rangeOfString: @"application"];
    NSRange match1;
    match1 = [path rangeOfString: @"request/path"];
    
    NSString * url =[[NSString stringWithFormat:@"%@%@",API_URL,path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if ([self.strReqMethod isEqualToString:POST_METHOD])
    {
        [manager POST:url parameters:dictParam progress:^(NSProgress * _Nonnull uploadProgress)
         {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             DLog(@"JSON: %@", responseObject);
             if (dataBlock)
             {
                 if(responseObject==nil)
                     dataBlock(task.response,nil);
                 else
                     dataBlock(responseObject,nil);
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             DLog(@"Error: %@", error);
             if (dataBlock) {
                 dataBlock(nil,error);
             }
         }];
    }
    else
    {
        [manager GET:url parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSLog(@"JSON: %@", responseObject);
             if(dataBlock)
             {
                 if(responseObject==nil)
                 {
                     dataBlock(task.response,nil);
                 }
                 else
                 {
                     dataBlock(responseObject,nil);
                 }
             }
         }
             failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
             DLog(@"Error: %@", error);
             if (dataBlock)
             {
                 dataBlock(nil,error);
             }
             
         }];
    }
}

#pragma mark -
#pragma mark - Post methods(multipart image)

-(void)getDataFromPath:(NSString *)path withParamDataImage:(NSMutableDictionary *)dictParam andImage:(UIImage *)image withBlock:(RequestCompletionBlock)block
{
    if (block) {
        dataBlock=[block copy];
    }
    NSData *imageToUpload = UIImageJPEGRepresentation(image, 1.0);//(uploadedImgView.image);
    if (imageToUpload)
    {
        NSString *url=[[NSString stringWithFormat:@"%@%@",API_URL,path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.requestSerializer.timeoutInterval=600;
        
        [manager POST:url parameters:dictParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
         {
             [formData appendPartWithFileData:imageToUpload name:PARAM_PICTURE fileName:@"temp.jpg" mimeType:@"image/jpg"];
         } progress:^(NSProgress * _Nonnull uploadProgress) {
             
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             DLog(@"JSON: %@", responseObject);
             if (dataBlock)
             {
                 if(responseObject==nil)
                     dataBlock(task.response,nil);
                 else
                     dataBlock(responseObject,nil);
             }
         }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             DLog(@"Error: %@", error);
             if (dataBlock) {
                 dataBlock(nil,error);
             }
         }];
    }
}

#pragma mark - get Error Messsage :

-(NSString *)getErrorMessage:(NSString *)str
{
    NSString *strs=[NSString stringWithFormat:@"%@",NSLocalizedString(str, nil)];
    return strs;
    
}

@end
