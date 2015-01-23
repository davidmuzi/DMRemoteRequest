DMRemoteRequest
===============

[![Circle CI](https://circleci.com/gh/davidmuzi/DMDiskStation.svg?style=svg)](https://circleci.com/gh/davidmuzi/DMDiskStation)

iOS library which structures the handling and routing of requests originating from an Watch


## Purpose

To easily facilitate communication to and from a watch application and its host app, and to keep your App Delegate clean


## Installation

To the host app add:
- DMRemoteRequestPrivate.h
- DMRemoteRequestRouter.h
- DMRemoteRequestRouter.m
- DMRemoteRequestProtocol.h

To the watch extension add:
- DMRemoteRequestPrivate.h
- DMRemoteRequestObserver.h
- DMRemoteRequestObserver.m

## Usage

### In Host App

In your AppDelegate pass the openApplication call to `DMRemoteRequest`

```obj-c
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply {
    
    [[]DMRemoteRequestRouter sharedRouter] handleCommand:userInfo reply:reply];
}
```

To handle a request from the watch, register a block or a class to handle it

```obj-c
    [self.router registerBlock:^(NSDictionary *userInfo, void (^callback)(NSDictionary *)) {
        callback(@{@"state": @"All systems go!"});
    } forMethod:@"state"];
```

With a class:

```obj-c
[self.router registerClass:TestOperation.class forMethod:@"date"];
```

Or, using a subscript:

```obj-c
self.router[@"date"] = TestOperation.class;
```

To send a notification to the watch, 

```obj-c
[self.router notifyWatch];
```

### In Watch Extension

To request data from the host application, in your watch extension use the `application:handleWatchKitExtensionRequest:reply:` method on WKInterfaceController, and include the key `DMMethodNameKey` with the method name for the object.

```obj-c
[WKInterfaceController openParentApplication:@{DMMethodNameKey: @"getState"} reply:^(NSDictionary *replyInfo, NSError *error) {
    NSLog(@"state: %@", replyInfo[@"state"]);
}];
```

To receive notifications from the host app, register an observer for the notification `DMRemoteCommandNotificationName`.  If you want to send data bi-directionally, [MMWormHole](https://github.com/mutualmobile/MMWormhole) can also be used in companion with DMRemoteRequest.

## Contributions

Are welcome, please submit issues and PRs!
  
