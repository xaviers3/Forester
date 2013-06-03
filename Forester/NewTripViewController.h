//
//  NewTripViewController.h
//  Forester
//
//  Created by CS4704 on 12/14/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "InfoViewController.h"
#import "MapAnnotation.h"
#import <CoreLocation/CoreLocation.h>


/*
 We use the Delegation Design Pattern for the communication between the
 AddCityViewController object and the RootViewController Object.
 We define a protocol here and the RootViewController adopts it.
 */
@protocol NewTripViewControllerDelegate;//-------------------------------------------------------------------

@interface NewTripViewController : UIViewController<MKMapViewDelegate, MKAnnotation, InfoViewControllerDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

//Delegate variables and methods
@property (nonatomic, assign) id <NewTripViewControllerDelegate> delegate;
-(void)save:(id)sender;

//Save Button Pressed. Show Textfield
@property (strong, nonatomic) UITextField* textField;

//Objects on screen
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
- (IBAction)playPauseButtonPressed:(UIButton *)sender;
- (IBAction)sampleRateChanged:(UISlider *)sender;

//Related Map Variables
@property (nonatomic, strong) MKPolyline            *tripTrack;
@property (nonatomic, strong) MKPolylineView        *tripTrackView;
@property (nonatomic, strong) NSMutableArray        *mapAnnotations;
@property (nonatomic, assign) MKMapRect             trackBoundingBox;

//Location Manager
@property (strong, nonatomic) CLLocationManager*  locationManager;

//Annotation data passed to downstream view controller
@property (strong, nonatomic) NSString* titleOfAnnotation;
@property (strong, nonatomic) NSString* subtitleOfAnnotation;
@property  CLLocationCoordinate2D coord;

//Trip data being built------------------------------------------------------------
//Represents the entire trip: Date, Annotations, Trip
@property(strong, nonatomic) NSMutableDictionary* tripData;

//Date of the current trip. Format: 2011-07-18
@property(strong, nonatomic) NSString* dateString;

//Represents the annotations tied to this trip. Format:
//[annotationData objectAtIndex:0] --> Title
//[annotationData objectAtIndex:1] --> SubTitle
//[annotationData objectAtIndex:2] --> longitude
//[annotationData objectAtIndex:3] --> latitude

//Final format: CSV string of the form:
//Title, Subtitle, longitude, latitude
@property(strong, nonatomic) NSMutableArray* annotationsArray;

//Represents the trip data tied to this trip. Format: CSV string of the form:
// Date Time, longitude, latitude
//EX: 07/18/2011 08:50:00 AM,-76.314873,37.002787
@property(strong, nonatomic) NSMutableArray* tripArray;

//---------------------------------------------------------------------------------


//Methods dictating view type switches upon pressed
- (IBAction)StandardBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)SatelliteBarButtonPressed:(UIBarButtonItem *)sender;
- (IBAction)HybridBarButtonPressed:(UIBarButtonItem *)sender;
@end//-------------------------------------------------------------------------------------------------------

/*
 The Protocol must be specified after the Interface specification is ended.
 Guidelines:
 - Create a protocol name as ClassNameDelegate as we did above.
 - Create a protocol method name starting with the name of the class defining the protocol.
 - Make the first method parameter to be the object reference of the caller as we did below.
 */
@protocol NewTripViewControllerDelegate

- (void)newTripViewController:(NewTripViewController *)controller didFinishWithSave:(BOOL)save;
@end

