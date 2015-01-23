//
//  TestOperation.m
//  DMRemoteRequest
//
//  Created by David Muzi on 2015-01-22.
//  Copyright (c) 2015 David Muzi. All rights reserved.
//

#import "TestOperation.h"

@implementation TestOperation

+ (NSOperation *)operationWithUserInfo:(NSDictionary *)userInfo completionHandler:(void (^)(NSDictionary *))handler {
    
    return [NSBlockOperation blockOperationWithBlock:^{
        
        handler(@{@"response": NSDate.date});
        
    }];
}

@end
