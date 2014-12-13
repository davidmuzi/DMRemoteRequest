//
//  DMRemoteRequestCoordinator.h
//
//  Created by David Muzi on 2014-12-11.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMRemoteRequestProtocol.h"

@interface DMRemoteRequestCoordinator : NSObject

/**
 *  Registers a class to handle a command originating from the watch
 *
 *  @param protocolClass a class that will handle the command
 */
+ (void)registerClass:(Class <DMRemoteRequestProtocol>)protocolClass NS_EXTENSION_UNAVAILABLE_IOS("");

/**
 *  Registers a block of code to handle a command originating from the watch
 *
 *  @param method  the method that will be handled
 *  @param handler block to handle the command
 */
+ (void)registerBlockForMethod:(NSString *)method handler:(NSDictionary * (^)(NSDictionary *userInfo))handler;

/**
 *  This should be called from application:handleWatchKitExtensionRequest:reply:
 *
 *  @param command the command parameters
 *  @param reply   the callback block
 *
 *  @return YES if the command was successfully handled
 */
+ (BOOL)handleCommand:(NSDictionary *)command reply:(void (^)(NSDictionary *))reply;

/**
 *  Sends a notifcation to the watch signifying an event has occurred on the host app
 */
+ (void)notifyWatch;


@end
