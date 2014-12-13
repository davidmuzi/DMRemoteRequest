//
//  DMRemoteCommandObserver.h
//
//  Created by David Muzi on 2014-12-12.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  The notification name originating from the host app
 */
static NSString * const DMRemoteCommandNotificationName;

/**
 *  Calls to application:handleWatchKitExtensionRequest:reply: should contain this key with the method name for the object
 */
static NSString * const DMMethodNameKey = @"method";


