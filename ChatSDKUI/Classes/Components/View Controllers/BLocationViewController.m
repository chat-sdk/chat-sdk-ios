//
//  BLocationViewController.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 16/04/2014.
//  Copyright (c) 2014 deluge. All rights reserved.
//

#import "BLocationViewController.h"
#import <ChatSDK/Core.h>
#import <ChatSDK/UI.h>

@interface BLocationViewController ()

@end

@implementation BLocationViewController

@synthesize region;
@synthesize annotation;

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:@"BLocationViewController" bundle:[NSBundle uiBundle]];
    if (self) {
        self.title = [NSBundle t:bLocation];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bBack] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSBundle t:bOpenInMaps] style:UIBarButtonItemStylePlain target:self action:@selector(openInGoogleMaps)];

}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _map = [BMapViewManager sharedManager].mapFromPool;
    [self.view addSubview:_map.mapView];
    
    _map.mapView.keepInsets.equal = 0;
    
    [_map.mapView setRegion:region animated:NO];
    [_map.mapView addAnnotation:annotation];
    [_map.mapView selectAnnotation:annotation animated:NO];
}

-(void) setLatitude: (double) latitude longitude: (double) longitude {
    self.region = [BCoreUtilities regionForLongitude:longitude latitude:latitude];
    self.annotation = [BCoreUtilities annotationForLongitude:longitude latitude:latitude];

}

-(void) viewWillDisappear:(BOOL)animated {
    [[BMapViewManager sharedManager] returnToPool:_map];
}

-(void) backButtonPressed {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void) openInGoogleMaps {
    NSString * location = [NSString stringWithFormat:@"https://maps.google.com/maps?q=%f,%f&%iz", region.center.latitude, region.center.longitude, 15];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:location]];
}

@end
