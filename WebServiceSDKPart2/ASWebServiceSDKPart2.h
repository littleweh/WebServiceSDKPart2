//
//  WebServiceSDKUsingDelegate.h
//  WebServiceSDKPart2
//
//  Created by Ada Kao on 26/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ASWebServiceSDKPart2;

@protocol ASWebServiceSDKPart2Delegate <NSObject>
-(void) WebServiceSDKPart2: (ASWebServiceSDKPart2*) httpBinSDK didGetJSONObject: (NSDictionary *) rootObject;
-(void) WebServiceSDKPart2: (ASWebServiceSDKPart2*) httpBinSDK didGetImage: (UIImage *) image;
-(void) WebServiceSDKPart2: (ASWebServiceSDKPart2 *)httpBinSDK didFailedWithError:(NSError *)error;

@end

@interface ASWebServiceSDKPart2 : NSObject
@property (weak, nonatomic) id <ASWebServiceSDKPart2Delegate> delegate;
+(instancetype)sharedInstance;
-(void)fetchGetResponse;
-(void)postCustomerName:(NSString *)name;
-(void)fetchImage;
@end
