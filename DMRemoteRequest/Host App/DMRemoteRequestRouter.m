//
//  DMRemoteRequestCoordinator.m
//
//  Created by David Muzi on 2014-12-11.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import "DMRemoteRequestRouter.h"
#import "DMRemoteRequestPrivate.h"
#import <objc/runtime.h>

static NSString * const DMMethodNameKey = @"method";

@interface DMRemoteRequestRouter ()
@property (nonatomic, strong) NSMutableDictionary *classes;
@property (nonatomic, strong) NSMutableDictionary *blocks;

@property (nonatomic, strong) NSOperationQueue *opQueue;
@end

@implementation DMRemoteRequestRouter

+ (instancetype)sharedRouter {
    
    static dispatch_once_t once;
    static DMRemoteRequestRouter *instance;
    
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

#pragma mark - Registering

- (void)registerClass:(Class <DMRemoteRequestProtocol>)protocolClass forMethod:(NSString *)method {

    [self.classes setObject:protocolClass forKey:method];
    [self.blocks removeObjectForKey:method];
}

- (void)registerBlock:(DMRemoteRequestBlock)block forMethod:(NSString *)method {

    [self.blocks setObject:block forKey:method];
    [self.classes removeObjectForKey:method];
}

- (id)objectForKeyedSubscript:(id <NSCopying>)key {

    NSString *methodName = (NSString *)key;
    id object = nil;
    
    if ([self.classes.allKeys containsObject:methodName]) {
        
        id<DMRemoteRequestProtocol> theClass = [self.classes objectForKey:methodName];
        object = theClass;
    }
    else if ([self.blocks.allKeys containsObject:methodName]) {
        
        NSDictionary* (^block)(NSDictionary*) = [self.blocks objectForKey:methodName];
        object = block;
    }
    
    return object;
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    
    NSString *method = (NSString *)key;
    
    if ([obj isKindOfClass:NSClassFromString(@"NSBlock")]) {
        [self registerBlock:obj forMethod:method];
    }
    else if (class_isMetaClass(object_getClass(obj))) {
        [self registerClass:obj forMethod:method];
    }
}

#pragma mark - Route handling

- (BOOL)handleRequest:(NSDictionary *)request reply:(void (^)(NSDictionary *))reply {

    BOOL handled = NO;
    
    NSString *methodName = request[DMMethodNameKey];
    
    if ([self.classes.allKeys containsObject:methodName]) {
        
        id<DMRemoteRequestProtocol> theClass = self.classes[methodName];

        NSOperation *op = [theClass operationWithUserInfo:request completionHandler:reply];
        [self.opQueue addOperation:op];
        
        handled = YES;
    }
    else if ([self.blocks.allKeys containsObject:methodName]) {
        
        DMRemoteRequestBlock block = self.blocks[methodName];
        block(request, reply);
        
        handled = YES;
    }

    return handled;
}


- (void)notifyWatch {
    
    CFNotificationCenterRef const center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterPostNotification(center, (__bridge CFStringRef)DMPrivateNotificationKey, NULL, NULL, YES);
}

@end
