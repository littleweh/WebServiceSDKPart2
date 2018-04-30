//
//  ViewController.m
//  WebServiceSDKPart2
//
//  Created by Ada Kao on 26/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic, readwrite) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.imageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.imageView];

//    [[ASWebServiceSDKPart2 sharedInstance] setDelegate:self];
//
//    [[ASWebServiceSDKPart2 sharedInstance] fetchGetResponse];

//    [[ASWebServiceSDKPart2 sharedInstance] postCustomerName:@"KKBOX"];
//
//    [[ASWebServiceSDKPart2 sharedInstance] fetchImage];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)WebServiceSDKPart2:(ASWebServiceSDKPart2 *)httpBinSDK didFailedWithError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
}

- (void)WebServiceSDKPart2:(ASWebServiceSDKPart2 *)httpBinSDK didGetImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)WebServiceSDKPart2:(ASWebServiceSDKPart2 *)httpBinSDK didGetJSONObject:(NSDictionary *)rootObject {
    NSLog(@"got dictionary: %@", rootObject);
}

@end
