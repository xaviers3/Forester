//
//  ExistingTripViewController.h
//  Forester
//
//  Created by CS4704 on 12/14/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "InfoViewController.h"


@interface ExistingTripViewController : UIViewController<MKMapViewDelegate, MKAnnotation, InfoViewControllerDelegate>

//MapView and related map variables
@property (strong, nonatomic) IBOutlet MKMapView    *mapView;
@property (nonatomic, strong) MKPolyline            *tripTrack;
@property (nonatomic, strong) MKPolylineView        *tripTrackView;
@property (nonatomic, strong) NSMutableArray        *mapAnnotations;
@property (nonatomic, assign) MKMapRect             trackBoundingBox;



//Trip data passed from upstream view controller
@property(strong, nonatomic) NSMutableDictionary* selectedTrip;
@property(strong, nonatomic) NSString* selectedTripName;

//Annotation data passed to downstream view controller
@property (strong, nonatomic) NSString* titleOfAnnotation;
@property (strong, nonatomic) NSString* subtitleOfAnnotation;
@property  CLLocationCoordinate2D coord;

//Methods dictating view type switches upon pressed
- (IBAction)StandardBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)SatelliteBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)HybridBarButtonPressed:(UIBarButtonItem *)sender;

@end//----------------------------------------------------------------------------------------------------

