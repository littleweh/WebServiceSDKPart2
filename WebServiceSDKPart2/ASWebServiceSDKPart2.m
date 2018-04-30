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
static NSString *const endPointImagePNG = @"image/png";

@implementation ASWebServiceSDKPart2
#pragma mark - singleton
+(instancetype) sharedInstance {
    static ASWebServiceSDKPart2 *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ASWebServiceSDKPart2 alloc]init];
    });
    return instance;
}

#pragma mark - lazy property
-(NSURLSession *) session {
    if (!self.session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration: configuration
                                                     delegate: self
                                                delegateQueue: [[NSOperationQueue alloc] init]
                        ];
    }
    return self.session;
}

-(void)fetchGetResponse {
    NSString *getURLString = [NSString stringWithFormat:@"%@%@", httpBinDomain, endPointGet];
    NSURL *url = [NSURL URLWithString:getURLString];
    

    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
        if (parseJSONError) {
            [self.delegate WebServiceSDKPart2:self didFailedWithError:parseJSONError];
        }
        [self.delegate WebServiceSDKPart2:self didGetJSONObject:rootObject];

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
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
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
        if (parseJSONError) {
            [self.delegate WebServiceSDKPart2:self didFailedWithError:parseJSONError];
        }
        [self.delegate WebServiceSDKPart2:self didGetJSONObject:rootObject];
    }];
    
    [dataTask resume];
}

-(void)fetchImage {
    NSString *imageURLString = [NSString stringWithFormat:@"%@%@", httpBinDomain, endPointImagePNG];
    NSURL *fetchImageURL = [NSURL URLWithString:imageURLString];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:fetchImageURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ([response respondsToSelector:@selector(statusCode)]) {
            NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
            if (statusCode == 500) return;
            // ToDo: response statuscode error handling
        }
        if (error) {
            [self.delegate WebServiceSDKPart2:self didFailedWithError:error];
        }
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate WebServiceSDKPart2:self didGetImage:image];
        });
    
    }];
    [dataTask resume];
    
}
@synthesize delegate;
@end
