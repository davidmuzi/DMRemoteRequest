//
//  DMRemoteRequestCoordinator.m
//
//  Created by David Muzi on 2014-12-11.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import "DMRemoteRequestCoordinator.h"
#import "DMRemoteRequestPrivate.h"

static NSString * const DMMethodNameKey = @"method";


@interface DMRemoteRequestCoordinator ()
@property (nonatomic, strong) NSMutableDictionary *classes;
@property (nonatomic, strong) NSMutableDictionary *blocks;

@property (nonatomic, strong) NSOperationQueue *opQueue;
@end

@implementation DMRemoteRequestCoordinator

+ (instancetype)sharedInstance {
    
    static dispatch_once_t once;
    static DMRemoteRequestCoordinator *instance;
    
    dispatch_once(&once, ^{
        
        instance = [self new];
        instance.classes = [NSMutableDictionary new];
        instance.blocks = [NSMutableDictionary new];
        
        instance.opQueue = [[NSOperationQueue alloc] init];
        instance.opQueue.maxConcurrentOperationCount = 1;
        instance.opQueue.name = @"com.muzi.remoteCommand";
    });
    return instance;
}

+ (void)registerClass:(Class <DMRemoteRequestProtocol>)protocolClass {
    
    DMRemoteRequestCoordinator *commander = [self sharedInstance];

    NSString *msg = [NSString stringWithFormat:@"Class already registered for method %@", [protocolClass methodName]];
    NSAssert(![commander.classes objectForKey:[protocolClass methodName]], msg);
    
    [commander.classes setObject:protocolClass forKey:[protocolClass methodName]];
    
}

+ (void)registerBlockForMethod:(NSString *)method handler:(NSDictionary * (^)(NSDictionary *userInfo))handler {
    
    DMRemoteRequestCoordinator *commander = [self sharedInstance];

    [commander.blocks setObject:handler forKey:method];
}

+ (BOOL)handleCommand:(NSDictionary *)command reply:(void (^)(NSDictionary *))reply {

    BOOL handled = NO;
    
    DMRemoteRequestCoordinator *commander = [self sharedInstance];
    
    NSString *methodName = command[DMMethodNameKey];
    
    if ([commander.classes.allKeys containsObject:methodName]) {
        
        id<DMRemoteRequestProtocol> theClass = [commander.classes objectForKey:methodName];

        NSOperation *op = [theClass operationWithUserInfo:command completionHandler:reply];
        [commander.opQueue addOperation:op];
        
        handled = YES;
    }
    else if ([commander.blocks.allKeys containsObject:methodName]) {
        
        NSDictionary* (^block)(NSDictionary*) = [commander.blocks objectForKey:methodName];
        
        NSDictionary *response = block(command);
        reply(response);
        
        handled = YES;
    }

    return handled;
}


+ (void)notifyWatch {
    
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterPostNotification(center, (__bridge CFStringRef)DMPrivateNotificationKey, NULL, NULL, YES);
}

@end
