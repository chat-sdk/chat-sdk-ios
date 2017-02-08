//
//  BLocation.m
//  Chat SDK
//
//  Created by Benjamin Smiley-andrews on 27/09/2013.
//  Copyright (c) 2013 chatsdk.co All rights reserved. The Chat SDK is issued under the MIT liceense and is available for free at http://github.com/chat-sdk
//

#import "BLocationCell.h"

#import <ChatSDK/BCoreUtilities.h>
#import <ChatSDK/PMessage.h>

@implementation BLocationCell

@synthesize mapView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        mapView = [[MKMapView alloc] init];
        mapView.layer.cornerRadius = 10;
        mapView.userInteractionEnabled = NO;
        
        [self.bubbleImageView addSubview:mapView];
        
    }
    return self;
}

-(void) setMessage: (id<PMessage, PMessageLayout>) message withColorWeight:(float)colorWeight {
    [super setMessage:message withColorWeight:colorWeight];
    
    self.bubbleImageView.image = Nil;
    
    float longitude = [[self.message textAsDictionary][bMessageLongitude] floatValue];
    float latitude = [[self.message textAsDictionary][bMessageLatitude] floatValue];

    CLLocationCoordinate2D coord;
    coord.longitude = longitude;
    coord.latitude = latitude;
    
    // Set the location and display the controller
    MKCoordinateRegion region = [BCoreUtilities regionForLongitude:coord.longitude latitude:coord.latitude];
    MKPointAnnotation * annotation = [BCoreUtilities annotationForLongitude:coord.longitude latitude:coord.latitude];
    
    [mapView setRegion:region animated:NO];
    [mapView addAnnotation:annotation];
    [mapView selectAnnotation:annotation animated:NO];
    
}

-(void) willDisplayCell {
    [super willDisplayCell];
}

-(UIView *) cellContentView {
    return mapView;
}

@end
