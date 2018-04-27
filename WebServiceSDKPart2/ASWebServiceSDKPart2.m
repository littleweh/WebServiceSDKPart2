//
//  WebServiceSDKUsingDelegate.m
//  WebServiceSDKPart2
//
//  Created by Ada Kao on 26/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import "ASWebServiceSDKPart2.h"
static NSString *const httpBinDomain = @"http://httpbin.org/";
static NSString *const endPointGet = @"get";
static NSString *const endPointPost = @"post";
static NSString *const endPointImagePNG = @"image/png/";

@implementation ASWebServiceSDKPart2
+(instancetype) sharedInstance {
    static ASWebServiceSDKPart2 *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ASWebServiceSDKPart2 alloc]init];
    });
    return instance;
}

-(void)fetchGetResponse {
    NSString *getURLString = [NSString stringWithFormat:@"%@%@", httpBinDomain, endPointGet];
    NSURL *url = [NSURL URLWithString:getURLString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([response respondsToSelector:@selector(statusCode)]) {
            NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
            if (statusCode == 500) return;
            else {
                
            }
            // ToDo: response statuscode check
            
        }
        if (error) {
            [self.delegate WebServiceSDKPart2:self didFailedWithError:error];
        }
        
        NSError *parseJSONError = nil;
        NSDictionary * rootObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseJSONError];
        if (!parseJSONError) {
            [self.delegate WebServiceSDKPart2:self didGetJSONObject:rootObject];
        }
        [self.delegate WebServiceSDKPart2:self didFailedWithError:parseJSONError];
    }];
    
    [dataTask resume];
    
}

-(void)postCustomerName:(NSString *)name {
    NSString *postString = [NSString stringWithFormat:@"%@%@", httpBinDomain, endPointPost];
    NSURL *postURL = [NSURL URLWithString:postString];
    
    NSString *postCustomerName = [NSString stringWithFormat:@"custname=%@", name];
    NSData *postData = [postCustomerName dataUsingEncoding:NSASCIIStringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([response respondsToSelector:@selector(statusCode)]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode == 500) {
                return;
            }
            // ToDo: response statuscode error handling
        }
        
        if (error != nil) {
            [self.delegate WebServiceSDKPart2:self didFailedWithError:error];
        }
        
        NSError *parseJSONError = nil;
        NSDictionary *rootObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseJSONError];
        if (!parseJSONError) {
            [self.delegate WebServiceSDKPart2:self didGetJSONObject:rootObject];
        }
        [self.delegate WebServiceSDKPart2:self didFailedWithError:parseJSONError];
    }];
    
    [dataTask resume];
}

-(void)fetchImage {
    
}
@synthesize delegate;
@end
