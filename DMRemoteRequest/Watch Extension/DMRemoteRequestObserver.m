//
//  DMRemoteRequestObserver.m
//
//  Created by David Muzi on 2014-12-12.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import "DMRemoteRequestObserver.h"
#import "DMRemoteRequestPrivate.h"

static NSString * const DMRemoteCommandNotificationName = @"DMRemoteCommandNotificationName";

@interface DMRemoteRequestObserver : NSObject
@end

@implementation DMRemoteRequestObserver

+ (void)load {
    DMRemoteRequestObserver *commander = [self sharedInstance];
    [commander registerForDarwinNotifications];
}

+ (instancetype)sharedInstance {
    
    static dispatch_once_t once;
    static DMRemoteRequestObserver *instance;
    
    dispatch_once(&once, ^{
        
        instance = [self new];
    });
    
    return instance;
}

- (void)dealloc {
    [self unregisterForDarwinNotifications];
}

#pragma mark - Watch

- (void)registerForDarwinNotifications {
    
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef str = (__bridge CFStringRef)DMPrivateNotificationKey;
    CFNotificationCenterAddObserver(center,
                                    (__bridge const void *)(self),
                                    notificationCallback,
                                    str,
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
}

- (void)unregisterForDarwinNotifications {
    
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFStringRef str = (__bridge CFStringRef)DMPrivateNotificationKey;
    CFNotificationCenterRemoveObserver(center,
                                       (__bridge const void *)(self),
                                       str,
                                       NULL);
}

void notificationCallback(CFNotificationCenterRef center,
                          void * observer,
                          CFStringRef name,
                          void const * object,
                          CFDictionaryRef userInfo) {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DMRemoteCommandNotificationName
                                                        object:nil
                                                      userInfo:nil];
}

@end
