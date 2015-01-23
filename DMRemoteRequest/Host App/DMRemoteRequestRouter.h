//
//  DMRemoteRequestRouter.h
//
//  Created by David Muzi on 2014-12-11.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMRemoteRequestProtocol.h"

/**
 *  Request bloack handler
 *
 *  @param userInfo input dictionary
 *  @param ^callback callback block to be called on completion
 */
typedef void (^DMRemoteRequestBlock)(NSDictionary *userInfo, void(^callback)(NSDictionary *results));

@interface DMRemoteRequestRouter : NSObject

/**
 *  Singleton reference
 *
 *  @return sharedRouter
 */
+ (instancetype)sharedRouter;

/**
 *  Registers a class to handle a command originating from the watch
 *
 *  @param protocolClass a class that will handle the command
 *  @param method method name
 */
- (void)registerClass:(Class <DMRemoteRequestProtocol>)protocolClass forMethod:(NSString *)method;

/**
 *  Registers a block which can perform an asyncronous task before calling its completion handler
 *
 *  @param method  the method to be handled
 *  @param block handler
 */
- (void)registerBlock:(DMRemoteRequestBlock)block forMethod:(NSString *)method;

/**
 *  Convenience method to set handler
 *
 *  @param obj protocol class or request block
 *  @param key method name
 */
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

/**
 *  Convenience method to get a registered handler
 *
 *  @param key method name
 *
 *  @return a protocol class or registered block
 */
- (id)objectForKeyedSubscript:(id <NSCopying>)key;

/**
 *  This should be called from application:handleWatchKitExtensionRequest:reply:
 *
 *  @param request the command parameters
 *  @param reply   the callback block
 *
 *  @return YES if the command was successfully handled
 */
- (BOOL)handleRequest:(NSDictionary *)request reply:(void (^)(NSDictionary *))reply;

/**
 *  Sends a notifcation to the watch signifying an event has occurred on the host app
 */
- (void)notifyWatch;


@end
