//
//  ViewController.m
//  DMRemoteRequest
//
//  Created by David Muzi on 2014-12-13.
//  Copyright (c) 2014 David Muzi. All rights reserved.
//

#import "ViewController.h"
#import "DMRemoteRequestRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[DMRemoteRequestRouter sharedRouter] registerBlock:^(NSDictionary *userInfo, void (^callback)(NSDictionary *)) {
        callback(@{@"name": [_segmentControl titleForSegmentAtIndex:_segmentControl.selectedSegmentIndex]});
    } forMethod:@"getState"];
    
    [DMRemoteRequestRouter sharedRouter][@"setSpin"] = ^NSDictionary *(NSDictionary *userInfo) {
        
        if ([userInfo[@"state"] boolValue]) {
            [_spinner startAnimating];
        }
        else {
            [_spinner stopAnimating];
        }
        
        return nil;
    };
}

- (IBAction)didTap:(id)sender {

    // notify the watch that something has updated on the host app
    [[DMRemoteRequestRouter sharedRouter] notifyWatch];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
