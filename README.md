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
- DMRemoteRequestObserver.h
- DMRemoteRequestObserver.m

## Usage

To request data from the host application, in your watch extension use the `application:handleWatchKitExtensionRequest:reply:` method on WKInterfaceController, and include the key `DMMethodNameKey` with the method name for the object.

To handle a request from a watch in the host application, register a block or a class to handle it

```obj-c
[DMRemoteRequestCoordinator registerBlockForMethod:@"getState" handler:^NSDictionary *(NSDictionary *userInfo) {
    return @{@"state": @"some data"};
}];
```

To send a notification from the host application, 

```obj-c
[DMRemoteRequestCoordinator notifyWatch];
```

And on the watch side, register an observer for the notification `DMRemoteCommandNotificationName`.  If you want to send data bi-directionally, [MMWormHole](https://github.com/mutualmobile/MMWormhole) can also be used in companion with DMRemoteRequest.

## Contributions

Are welcome, please submit issues and PRs!
  