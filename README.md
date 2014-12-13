DMRemoteRequest
===============

iOS library which structures the handling of requests originating from an Watch


## Purpose

To easily facilitate communication to and from a watch application and its host app, and to keep your App Delegate clean


## Installation

To the host app add:
- DMRemoteRequestPrivate.h
- DMRemoteRequestCoordinator.h
- DMRemoteRequestCoordinator.m
- DMRemoteRequestProtocol.h

To the watch extension add:
- DMRemoteRequestPrivate.h
- DMRemoteRequestObserver.h
- DMRemoteRequestObserver.m

## Usage

### In host app

In your AppDelegate pass the openApplication call to `DMRemoteRequest`

```obj-c
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply {
    
    [DMRemoteRequestCoordinator handleCommand:userInfo reply:reply];
}
```

To handle a request from the watch, register a block or a class to handle it

```obj-c
[DMRemoteRequestCoordinator registerBlockForMethod:@"getState" handler:^NSDictionary *(NSDictionary *userInfo) {
    return @{@"state": @"some data"};
}];
```

To send a notification to the watch, 

```obj-c
[DMRemoteRequestCoordinator notifyWatch];
```

### In watch extension

To request data from the host application, in your watch extension use the `application:handleWatchKitExtensionRequest:reply:` method on WKInterfaceController, and include the key `DMMethodNameKey` with the method name for the object.

To receive notifications from the host app, register an observer for the notification `DMRemoteCommandNotificationName`.  If you want to send data bi-directionally, [MMWormHole](https://github.com/mutualmobile/MMWormhole) can also be used in companion with DMRemoteRequest.

## Contributions

Are welcome, please submit issues and PRs!
  