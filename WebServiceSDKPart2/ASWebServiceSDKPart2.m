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

@interface ASWebServiceSDKPart2 ()
@property (strong, nonatomic) NSMutableData * buffer;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray <NSURLSessionDataTask *> * dataTasks;
@end

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
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 60.0;
        configuration.timeoutIntervalForResource = 60.0;
        _session = [NSURLSession sessionWithConfiguration: configuration
                                                     delegate: self
                                                delegateQueue: [[NSOperationQueue alloc] init]
                        ];
    }
    return _session;
}

-(NSMutableData *) buffer {
    if (!_buffer) {
        _buffer = [[NSMutableData  alloc]init];
    }
    return _buffer;
}

-(NSMutableArray <NSURLSessionDataTask *> *) dataTasks {
    if (!_dataTasks) {
        NSMutableArray * array = [NSMutableArray<NSURLSessionDataTask *> array];
        _dataTasks = array;
    }
    return _dataTasks;
}

#pragma mark - NSURLSessionDataDelegate methods

-(void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    NSLog(@"task identifier: %lu", (unsigned long)dataTask.taskIdentifier);
    NSLog(@"didReceiveResponse");
    NSLog(@"dataTask state: %ld", (long)dataTask.state);
    NSLog(@"response: %@", response);

    if ([response respondsToSelector:@selector(statusCode)]) {
        NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
        switch (statusCode) {
            case 500:
                NSLog(@"statuscode: %ld", (long) statusCode);
                NSLog(@"dataTask state: %ld", (long)dataTask.state);
                completionHandler(NSURLSessionResponseCancel);
                return;
                break;
            case 400 ... 499:
            case 300 ... 399:
                NSLog(@"statuscode: %ld", (long) statusCode);
                completionHandler(NSURLSessionResponseCancel);
                return;
                break;
            case 200 ... 299:
                completionHandler(NSURLSessionResponseAllow);
                break;
            default:
                break;
        }
    }
}


-(void) URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"task identifier: %lu", (unsigned long)dataTask.taskIdentifier);
    NSLog(@"didReceiveData");
    NSLog(@"dataTask state: %ld", (long)dataTask.state);

    [self.buffer appendData:data];
    
}

-(void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"task identifier: %lu", (unsigned long)task.taskIdentifier);
    NSLog(@"didCompleteWithError");
    NSLog(@"task state: %ld", (long)task.state);

    if (error) {
        [self.delegate WebServiceSDKPart2:self didFailedWithError:error];
        return;
    }
    
    NSString *type = [task response].MIMEType;
    if ([type isEqualToString:@"image/png"]) {
        UIImage *image = [UIImage imageWithData:self.buffer];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate WebServiceSDKPart2:self didGetImage: image];
        });
    } else if ([type isEqualToString:@"application/json"]) {
        NSError *parseJSONError = nil;
        NSDictionary * rootObject = [NSJSONSerialization JSONObjectWithData:self.buffer options:NSJSONReadingMutableContainers error:&parseJSONError];
        if (parseJSONError) {
            [self.delegate WebServiceSDKPart2:self didFailedWithError:parseJSONError];
            return;
        }
        [self.delegate WebServiceSDKPart2:self didGetJSONObject:rootObject];
    }

}

#pragma mark - get, post, fetch image method

-(void) cancelExistedTasks {
    for (NSURLSessionDataTask *task in self.dataTasks) {
        switch (task.state) {
            case 0:
            case 1:
                [task cancel];
                break;
            case 2:
            case 3:
                break;
        }
    }
}

-(void)fetchGetResponse {
//    NSString *getURLString = [NSString stringWithFormat:@"%@%@", httpBinDomain, endPointGet];
    
    // since the httpbin connection is not stable, use jsonplaceholder to test
    NSString *getURLString = [NSString stringWithFormat:@"https://jsonplaceholder.typicode.com/posts/1"];

    NSURL *url = [NSURL URLWithString:getURLString];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url];
    dataTask.taskDescription = [NSString stringWithFormat:@"Get from httpBin"];
    
    [self cancelExistedTasks];
    [self.dataTasks addObject:dataTask];

    [dataTask resume];
}

-(void)postCustomerName:(NSString *)name {
//    NSString *postString = [NSString stringWithFormat:@"%@%@", httpBinDomain, endPointPost];
    
    // since the httpbin connection is not stable, use jsonplaceholder to test
    NSString *postString = [NSString stringWithFormat:@"https://jsonplaceholder.typicode.com/posts"];

    NSURL *postURL = [NSURL URLWithString:postString];
    
    NSString *postCustomerName = [NSString stringWithFormat:@"custname=%@", name];
    NSData *postData = [postCustomerName dataUsingEncoding:NSASCIIStringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:postURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];

    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    dataTask.taskDescription = @"Post customer name to httpbin";
    
    [self cancelExistedTasks];
    [self.dataTasks addObject:dataTask];
    
    [dataTask resume];
    
}

-(void)fetchImage {
//    NSString *imageURLString = [NSString stringWithFormat:@"%@%@", httpBinDomain, endPointImagePNG];
    
    // since the httpbin connection is not stable, use jsonplaceholder to test
    NSString *imageURLString = [NSString stringWithFormat:@"http://placehold.it/300/d32776"];
    NSURL *fetchImageURL = [NSURL URLWithString:imageURLString];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:fetchImageURL];
    dataTask.taskDescription = [NSString stringWithFormat:@"Get png image file form httpBin"];
    
    [self cancelExistedTasks];
    [self.dataTasks addObject:dataTask];
    [dataTask resume];
    
}
@synthesize delegate;
@end
