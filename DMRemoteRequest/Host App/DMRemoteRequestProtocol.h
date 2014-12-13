//
//  DMRemoteRequestProtocol.h
//
//  Created by David Muzi on 2014-12-11.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DMRemoteRequestProtocol <NSObject>

/**
 *  The method name which will handled by this class
 *
 *  @return method name
 */
+ (NSString *)methodName;

/**
 *  An operation to handle the command
 *
 *  @param userInfo command parameters
 *  @param handler  callback handler
 *
 *  @return an NSOperation instance
 */
+ (NSOperation *)operationWithUserInfo:(NSDictionary *)userInfo completionHandler:(void (^)(NSDictionary *results))handler;

@end
