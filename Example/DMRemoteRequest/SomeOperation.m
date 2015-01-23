//
//  SomeOperation.m
//  DMRemoteRequest
//
//  Created by David Muzi on 2014-12-13.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import "SomeOperation.h"

@implementation SomeOperation

+ (void)load {
    [[DMRemoteRequestRouter sharedRouter] registerClass:self forMethod:@"getDate"];
}

+ (NSOperation *)operationWithUserInfo:(NSDictionary *)userInfo completionHandler:(void (^)(NSDictionary *results))handler {
    
    return [NSBlockOperation blockOperationWithBlock:^{
        
        handler(@{@"date": @"NSDate.date"});
        
    }];
}

@end
