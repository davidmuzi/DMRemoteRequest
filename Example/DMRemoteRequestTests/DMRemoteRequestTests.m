//
//  DMRemoteRequestTests.m
//  DMRemoteRequestTests
//
//  Created by David Muzi on 2014-12-13.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DMRemoteRequestRouter.h"
#import "DMRemoteRequestObserver.h"
#import "TestOperation.h"

@interface DMRemoteRequestTests : XCTestCase
@property (nonatomic, strong) DMRemoteRequestRouter *router;
@end

@implementation DMRemoteRequestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.s
    
    self.router = [DMRemoteRequestRouter sharedRouter];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRegisterBlockWithSubscript {
    
    self.router[@"hello"] = ^(NSDictionary *userInfo, void (^callback)(NSDictionary *)) {
        callback(@{@"response": @"world"});
    };
    
    id block = self.router[@"hello"];
    
    XCTAssertNotNil(block, @"block not returned");
}

- (void)testRegisterBlockWithMethod {
    
    [self.router registerBlock:^(NSDictionary *userInfo, void (^callback)(NSDictionary *)) {
        callback(@{@"response": @"world"});
    } forMethod:@"hello"];
    
    id block = self.router[@"hello"];
    
    XCTAssertNotNil(block, @"block not returned");
}

- (void)testRegisterClass {
    
    [self.router registerClass:TestOperation.class forMethod:@"date"];
    
    id classs = self.router[@"date"];
    XCTAssertNotNil(classs, @"block not returned");
}

- (void)testRegisterClassWithSubscript {

    self.router[@"date"] = TestOperation.class;
    
    id classs = self.router[@"date"];
    XCTAssertNotNil(classs, @"block not returned");
}

- (void)testPerformClass {
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"class test"];
    
    self.router[@"date"] = TestOperation.class;
    
    [self.router handleRequest:@{DMMethodNameKey: @"date"} reply:^(NSDictionary *reply) {

        XCTAssertTrue([reply[@"response"] isKindOfClass:NSDate.class], @"Expecting date");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError *error) {
        if (error) NSLog(@"error: %@", error.localizedDescription);
    }];
}

- (void)testPerformBlock {
    
    XCTestExpectation *expectation =
    [self expectationWithDescription:@"block test"];
    
    [self.router registerBlock:^(NSDictionary *userInfo, void (^callback)(NSDictionary *)) {
        callback(@{@"response": @"world"});
    } forMethod:@"hello"];
    
    [self.router handleRequest:@{DMMethodNameKey: @"hello"} reply:^(NSDictionary *reply) {
        XCTAssertEqual(reply[@"response"], @"world", @"response not equal");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1.0 handler:^(NSError *error) {
        if (error) NSLog(@"error: %@", error.localizedDescription);
    }];
}

@end
