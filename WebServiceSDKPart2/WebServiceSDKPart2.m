//
//  WebServiceSDKUsingDelegate.m
//  WebServiceSDKPart2
//
//  Created by Ada Kao on 26/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import "WebServiceSDKPart2.h"

@interface WebServiceSDKPart2()
@property (strong, nonatomic, readwrite) NSString * httpBinDomain;
@property (strong, nonatomic, readwrite) NSString * endPointGet;
@property (strong, nonatomic, readwrite) NSString * endPointPost;
@property (strong, nonatomic, readwrite) NSString * endPointImagePNG;
@end

@implementation WebServiceSDKPart2
-(NSString *) httpBinDomain {
    return [NSString stringWithFormat:@"http://httpbin.org/"];
}

-(NSString *)endPointGet {
    return [NSString stringWithFormat:@"get"];
}

-(NSString *)endPointPost {
    return [NSString stringWithFormat:@"post"];
}

-(NSString *)endPointImagePNG {
    return [NSString stringWithFormat:@"image/png/"];
}


-(void)fetchGetResponse {
    NSString *getURLString = [NSString stringWithFormat:@"%@%@", self.httpBinDomain, self.endPointGet];
    NSURL *url = [NSURL URLWithString:getURLString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
    }];
    
}

-(void)postCustomerName:(NSString *)name {
    
}

-(void)fetchImage {
    
}
@end
