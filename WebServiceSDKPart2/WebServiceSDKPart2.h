//
//  WebServiceSDKUsingDelegate.h
//  WebServiceSDKPart2
//
//  Created by Ada Kao on 26/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class WebServiceSDKPart2;

@protocol WebServiceSDKPart2Delegate <NSObject>
-(void) WebServiceSDKPart2: (WebServiceSDKPart2*) httpBinSDK didGetJSONObject: (NSDictionary *) rootObject;
-(void) WebServiceSDKPart2: (WebServiceSDKPart2*) httpBinSDK didGetImage: (UIImage *) image;
-(void) WebServiceSDKPart2: (WebServiceSDKPart2 *)httpBinSDK didFailedWithError:(NSError *)error;

@end

@interface WebServiceSDKPart2 : NSObject
@property (weak, nonatomic, readwrite) id <WebServiceSDKPart2Delegate> delegate;

-(void)fetchGetResponse;
-(void)postCustomerName:(NSString *)name;
-(void)fetchImage;
@end
