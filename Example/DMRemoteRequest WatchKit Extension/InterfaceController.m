//
//  InterfaceController.m
//  DMRemoteRequest WatchKit Extension
//
//  Created by David Muzi on 2014-12-13.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import "InterfaceController.h"
#import "DMRemoteRequestObserver.h"

@interface InterfaceController()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    NSLog(@"%@ awakeWithContext", self);
    
    [self updateLabel];
    
    [WKInterfaceController openParentApplication:@{DMMethodNameKey: @"getDate"} reply:^(NSDictionary *replyInfo, NSError *error) {
        NSLog(@"date: %@", replyInfo[@"date"]);
    }];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    NSLog(@"%@ will activate", self);
    
    // observe update notifications originating from the host app
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel) name:DMRemoteCommandNotificationName object:nil];
}

- (IBAction)switchTapped:(BOOL)value {
    
    [WKInterfaceController openParentApplication:@{DMMethodNameKey: @"setSpin", @"state": @(value)} reply:^(NSDictionary *replyInfo, NSError *error) {
        
    }];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    NSLog(@"%@ did deactivate", self);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateLabel {
    // Request information from the host app
    [WKInterfaceController openParentApplication:@{DMMethodNameKey: @"getState"} reply:^(NSDictionary *replyInfo, NSError *error) {
        
        [self.nameLabel setText:replyInfo[@"name"]];
        
    }];
}

@end



