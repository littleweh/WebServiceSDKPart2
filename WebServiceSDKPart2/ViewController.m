//
//  ViewController.m
//  WebServiceSDKPart2
//
//  Created by Ada Kao on 26/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ASWebServiceSDKPart2 sharedInstance] setDelegate:self];
    
//    [[ASWebServiceSDKPart2 sharedInstance] fetchGetResponse];
    [[ASWebServiceSDKPart2 sharedInstance] postCustomerName:@"KKBOX"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)WebServiceSDKPart2:(ASWebServiceSDKPart2 *)httpBinSDK didFailedWithError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
}

- (void)WebServiceSDKPart2:(ASWebServiceSDKPart2 *)httpBinSDK didGetImage:(UIImage *)image {
    NSLog(@"got image");
}

- (void)WebServiceSDKPart2:(ASWebServiceSDKPart2 *)httpBinSDK didGetJSONObject:(NSDictionary *)rootObject {
    NSLog(@"got dictionary: %@", rootObject);
}



@end
