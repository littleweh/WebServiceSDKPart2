//
//  WebServiceSDKPart2Tests.m
//  WebServiceSDKPart2Tests
//
//  Created by Ada Kao on 26/04/2018.
//  Copyright © 2018 Ada Kao. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ASWebServiceSDKPart2.h"

@interface WebServiceSDKPart2Tests : XCTestCase<ASWebServiceSDKPart2Delegate>
@property (strong, nonatomic) NSDictionary * getJSONObject;
@property (strong, nonatomic) XCTestExpectation *expectation;
@property (strong, nonatomic) UIImage *image;

@end

@interface ASWebServiceSDKPart2 ()
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSMutableArray <NSURLSessionDataTask *> * dataTasks;
@end

@implementation WebServiceSDKPart2Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testFetchGetResponseWithoutPreviousTasks {
    self.expectation = [self expectationWithDescription:@"Get without previous tasks"];
    ASWebServiceSDKPart2 *sdk1 = [[ASWebServiceSDKPart2 alloc] init];
    [sdk1 setDelegate:self];
    [sdk1 fetchGetResponse];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
    NSDictionary *rootObject = self.getJSONObject;
    
    XCTAssert([rootObject objectForKey:@"body"] != nil, @"there is no object with key \"body\"");
    XCTAssert([rootObject objectForKey:@"id"] != nil, @"there is no object with key \"id\"");
    XCTAssert([rootObject objectForKey:@"title"] != nil, @"there is no object with key \"title\"");
    XCTAssert([rootObject objectForKey:@"userId"]!=nil, @"there is no object with key \"userId\"");
    
    XCTAssert([[rootObject objectForKey:@"body"] isKindOfClass:[NSString class]], @"body class: %@", NSStringFromClass([[rootObject objectForKey:@"body"] class]));
    XCTAssert([[rootObject objectForKey: @"id"] isKindOfClass:[NSNumber class]], @"id class: %@", NSStringFromClass([[rootObject objectForKey:@"id"] class]));
    XCTAssert([[rootObject objectForKey:@"title"] isKindOfClass:[NSString class]], @"title class: %@", NSStringFromClass([[rootObject objectForKey:@"title"] class]));
    XCTAssert([[rootObject objectForKey:@"userId"] isKindOfClass:[NSNumber class]], @"userId class: %@", NSStringFromClass([[rootObject objectForKey:@"userId"] class]));
    
}

-(void)testFetchGetResponseWithPreviousTasks {
    self.expectation = [self expectationWithDescription:@"Get with previous tasks"];
    ASWebServiceSDKPart2 *sdk2 = [[ASWebServiceSDKPart2 alloc] init];
    [sdk2 setDelegate:self];
    
    NSArray <NSString *> * urlStrings = [NSArray arrayWithObjects:
                                         [NSString stringWithFormat:@"http://placehold.it/100/3a0b95"],
                                         [NSString stringWithFormat:@"http://placehold.it/200/3a0b95"],
                                         [NSString stringWithFormat:@"http://placehold.it/300/3a0b95"],
                                         [NSString stringWithFormat:@"http://placehold.it/400/3a0b95"],
                                         nil];
    for (NSString * string in urlStrings) {
        NSURL *url = [NSURL URLWithString:string];
        NSURLSessionDataTask *dataTask = [sdk2.session dataTaskWithURL:url];
        [sdk2.dataTasks addObject:dataTask];
        [dataTask resume];
    }
    
    [sdk2 fetchGetResponse];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
    NSDictionary *rootObject = self.getJSONObject;
    
    XCTAssert([rootObject objectForKey:@"body"] != nil, @"there is no object with key \"body\"");
    XCTAssert([rootObject objectForKey:@"id"] != nil, @"there is no object with key \"id\"");
    XCTAssert([rootObject objectForKey:@"title"] != nil, @"there is no object with key \"title\"");
    XCTAssert([rootObject objectForKey:@"userId"]!=nil, @"there is no object with key \"userId\"");
    
    XCTAssert([[rootObject objectForKey:@"body"] isKindOfClass:[NSString class]], @"body class: %@", NSStringFromClass([[rootObject objectForKey:@"body"] class]));
    XCTAssert([[rootObject objectForKey: @"id"] isKindOfClass:[NSNumber class]], @"id class: %@", NSStringFromClass([[rootObject objectForKey:@"id"] class]));
    XCTAssert([[rootObject objectForKey:@"title"] isKindOfClass:[NSString class]], @"title class: %@", NSStringFromClass([[rootObject objectForKey:@"title"] class]));
    XCTAssert([[rootObject objectForKey:@"userId"] isKindOfClass:[NSNumber class]], @"userId class: %@", NSStringFromClass([[rootObject objectForKey:@"userId"] class]));
    
}

-(void)testPostCustomerNameWithoutPreviousTasks {
    self.expectation = [self expectationWithDescription:@"post customer name without previous tasks"];
    ASWebServiceSDKPart2 *sdk3 = [[ASWebServiceSDKPart2 alloc]init];
    [sdk3 setDelegate:self];
    [sdk3 postCustomerName:@"testWithoutPreviousTasks"];
    
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
    NSDictionary * rootObject = self.getJSONObject;
    XCTAssert([rootObject objectForKey:@"custname"] != nil, @"there is no object with key \"custname\"");
    XCTAssert([rootObject objectForKey:@"id"] != nil, @"there is no object with key \"id\"");
    
    XCTAssert([[rootObject objectForKey:@"custname"] isKindOfClass:[NSString class]], @"object class: %@", [[rootObject objectForKey:@"custname"] class]);
    XCTAssert([[rootObject objectForKey:@"id"] isKindOfClass:[NSNumber class]], @"object class:%@", [[rootObject objectForKey:@"id"] class]);
}

-(void)testPostCustomerNameWithPreviousTasks {
    self.expectation = [self expectationWithDescription:@"post customer name with previous tasks"];
    ASWebServiceSDKPart2 *sdk3 = [[ASWebServiceSDKPart2 alloc]init];
    [sdk3 setDelegate:self];
    
    NSArray <NSString *> * urlStrings = [NSArray arrayWithObjects:
                                         [NSString stringWithFormat:@"http://placehold.it/100/8e973b"],
                                         [NSString stringWithFormat:@"http://placehold.it/200/8e973b"],
                                         [NSString stringWithFormat:@"http://placehold.it/300/8e973b"],
                                         [NSString stringWithFormat:@"http://placehold.it/400/8e973b"],
                                         nil];
    for (NSString * string in urlStrings) {
        NSURL *url = [NSURL URLWithString:string];
        NSURLSessionDataTask *dataTask = [sdk3.session dataTaskWithURL:url];
        [sdk3.dataTasks addObject:dataTask];
        [dataTask resume];
    }

    [sdk3 postCustomerName:@"testWithoutPreviousTasks"];
    
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
    NSDictionary * rootObject = self.getJSONObject;
    XCTAssert([rootObject objectForKey:@"custname"] != nil, @"there is no object with key \"custname\"");
    XCTAssert([rootObject objectForKey:@"id"] != nil, @"there is no object with key \"id\"");
    
    XCTAssert([[rootObject objectForKey:@"custname"] isKindOfClass:[NSString class]], @"object class: %@", [[rootObject objectForKey:@"custname"] class]);
    XCTAssert([[rootObject objectForKey:@"id"] isKindOfClass:[NSNumber class]], @"object class:%@", [[rootObject objectForKey:@"id"] class]);
}

-(void) testFetchImageWithoutPreviousTasks {
    
    self.expectation = [self expectationWithDescription:@"get image without previous tasks"];
    ASWebServiceSDKPart2 *sdkSingleton = [ASWebServiceSDKPart2 sharedInstance];
    [sdkSingleton setDelegate: self];
    
    [sdkSingleton fetchImage];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
    XCTAssert(self.image != nil, @"image file doesn't exist");
    XCTAssert([self.image isKindOfClass:[UIImage class]], @"image type is: %@", [self.image class]);
}

-(void) testFetchImageWithPreviousCompletedTasks {
    self.expectation = [self expectationWithDescription:@"get image with previous tasks"];
    ASWebServiceSDKPart2 *sdkSingleton = [ASWebServiceSDKPart2 sharedInstance];
    [sdkSingleton setDelegate:self];
    
    [sdkSingleton fetchImage];
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    
    XCTAssert(self.image != nil, @"image file doesn't exist");
    XCTAssert([self.image isKindOfClass:[UIImage class]], @"image type is: %@", [self.image class]);
}

-(void) WebServiceSDKPart2:(ASWebServiceSDKPart2 *)httpBinSDK didGetJSONObject:(NSDictionary *)rootObject {
    self.getJSONObject = rootObject;
    [self.expectation fulfill];
}

-(void) WebServiceSDKPart2:(ASWebServiceSDKPart2 *)httpBinSDK didFailedWithError:(NSError *)error {
    NSLog(@"Error: %@", error.localizedDescription);
}

-(void) WebServiceSDKPart2:(ASWebServiceSDKPart2 *)httpBinSDK didGetImage:(UIImage *)image {
    self.image = image;
    [self.expectation fulfill];
}



@end
