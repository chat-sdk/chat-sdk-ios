//
//  BLocationPickerController.m
//  ChatSDK
//
//  Created by Pepe Becker on 24.04.18.
//

#import "BLocationPickerController.h"
@import Mapbox;

@interface BLocationPickerController() <MGLMapViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) MGLMapView * mapView;
@property (nonatomic) MGLPointAnnotation * annotation;

@end

@implementation BLocationPickerController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action: @selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action: @selector(done)];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    self.mapView = [[MGLMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.mapView];
    self.mapView.delegate = self;

    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MGLUserTrackingModeFollow animated:YES];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTab:)];
    tapRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)didRecognizeTab:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];

    if (self.annotation) {
        [self.mapView removeAnnotation:self.annotation];
    }

    self.annotation = [MGLPointAnnotation alloc];
    self.annotation.coordinate = coordinate;
    [self.mapView addAnnotation:self.annotation];
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)cancel {
    [delegate locationPickerControllerDidCancel:self];
    [self dismiss];
}

- (void)done {
    CLLocationCoordinate2D coords = self.annotation.coordinate;
    CLLocation * location = [[CLLocation alloc] initWithLatitude:coords.latitude longitude:coords.longitude];
    [delegate locationPickerController:self didSelectLocation:location];
    [self dismiss];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
