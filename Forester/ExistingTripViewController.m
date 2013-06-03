//
//  ExistingTripViewController.m
//  Forester
//
//  Created by CS4704 on 12/14/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import "ExistingTripViewController.h"

@interface ExistingTripViewController ()

@end

@implementation ExistingTripViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationItem.title = self.selectedTripName;
    
    self.navigationItem.leftBarButtonItem.title = @"Recent";

    // Set the map type to hybrid view
    self.mapView.mapType = MKMapTypeHybrid;
    self.mapAnnotations = [[NSMutableArray alloc] init];
    
       
    // Create the trip track overlay
    [self createTripTrack];
    
    if (self.tripTrack != nil) {
        
        // Add the created trip track overlay to the map
        [self.mapView addOverlay:self.tripTrack];
        
        // Zoom in to the level of the track bounding box
        [self.mapView setVisibleMapRect:self.trackBoundingBox];
        
        // Add the annotations to the map
        [self.mapView addAnnotations:self.mapAnnotations];
    }
    
    
    
    /**************************************************************************************************
     *  Long Press is a continuous gesture, which                                                     *
     *                                                                                                *
     *   (a) begins when the user presses down one or more fingers (numberOfTouchesRequired)          *
     *       for more than a given number of seconds (minimumPressDuration)                           *
     *       within a maximum movement area (allowableMovement), and                                  *
     *   (b) ends when all fingers are lifted.                                                        *
     *                                                                                                *
     *  Long-press gesture has the following 3 states:                                                *
     *                                                                                                *
     *  UIGestureRecognizerStateBegan                                 UIGestureRecognizerStateEnded   *
     *              |                                                                |                *
     *              |                UIGestureRecognizerStateChanged                 |                *
     *              V                                                                V                *
     *  time --------------------------------------------------------------------------------------   *
     *         touch begins                                                     touch ends            *
     *************************************************************************************************/
    
    // Create Long Press Gesture Recognizer for the Image View
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(handleLongPress:)];
    
    // Number of fingers (touches) that must be pressed on the Image View for the gesture to be recognized.
    longPressRecognizer.numberOfTouchesRequired = 1;
    
    // Minimum number of seconds fingers must press on the Image View for the gesture to be recognized.
    longPressRecognizer.minimumPressDuration = 1;
    
    // Maximum movement (in pixels) of the fingers on the Image View before the gesture fails.
    longPressRecognizer.allowableMovement = 15;
    
    // Add Long Press Gesture Recognizer to the Image View
    [self.mapView addGestureRecognizer:longPressRecognizer];
    
}


#pragma mark - mapType selector methods
//Switch the map type to standard
- (IBAction)StandardBarButtonPressed:(UIBarButtonItem *)sender {
    self.mapView.mapType = MKMapTypeStandard;
}

//Switch the map type to satellite
- (IBAction)SatelliteBarButtonPressed:(UIBarButtonItem *)sender {
    self.mapView.mapType = MKMapTypeSatellite;
}

//Switch the map type to hybrid
- (IBAction)HybridBarButtonPressed:(UIBarButtonItem *)sender {
    self.mapView.mapType = MKMapTypeHybrid;
}


#pragma mark - Creation of a Polyline Overlay

// Creates the trip track as an MKPolyline overlay
-(void) createTripTrack
{
    //LOAD USING PLIST IN MAINBUNDLE
    

        NSMutableDictionary* selected = [self.selectedTrip objectForKey:self.selectedTripName];
    
        //Each waypoint is set up as follows:
        NSArray *waypoints = [selected objectForKey:@"Trip"];
        /*
         The TrackData.csv file consists of lines formed by the newline "\n" characters.
        Each line represents the following data for a waypoint: Date Time Speed Direction, Longitude, Latitude, Altitude
         A waypoint is a reference point in physical space used for navigation purposes.
         Kth element of the waypoints array contains the Kth line of the track data file, where K=0,1,2,3, ..., 643
         */
    
    ////////////////////////////////
    
    
    
    // *** Local Variables ***
    
    MKMapPoint upperRightCorner;    // upper right corner map point of the box to bound all of the tracks
    MKMapPoint lowerLeftCorner;     // lower left corner map point of the box to bound all of the tracks
    
    NSUInteger numberOfWaypoints = waypoints.count;
    
    // Create an array in C programming language to hold numberOfWaypoints times the size of a MKMapPoint struct
    MKMapPoint *arrayOfMapPoints = malloc(sizeof(MKMapPoint) * numberOfWaypoints);
    
    
    
    //Create Points
    for(int waypointNo = 0; waypointNo < numberOfWaypoints; waypointNo++)
    {
        
        // Obtain the current waypoint string corresponding to a line in the track data file
        NSString *waypoint = [waypoints objectAtIndex:waypointNo];
        
        // Store the comma-separated components of the waypoint string into the array waypointData
        NSArray *waypointData = [waypoint componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        
        /*
         [waypointData objectAtIndex:0] --> date, time
         [waypointData objectAtIndex:1] --> longitude
         [waypointData objectAtIndex:2] --> latitude
         [waypointData objectAtIndex:3] --> altitude
         */
        
        CLLocationDegrees longitude = [[waypointData objectAtIndex:1] doubleValue];
        CLLocationDegrees latitude  = [[waypointData objectAtIndex:2] doubleValue];
        
        // A map coordinate is a latitude and longitude on the spherical representation of the Earth.
        // Create a map coordinate using latitude and longitude values
        CLLocationCoordinate2D mapCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
        
        // A map point is an x and y value on the Mercator map projection.
        // Convert the map coordinate to a map point, which is a Struct with mapPoint.x and mapPoint.y
        MKMapPoint mapPoint = MKMapPointForCoordinate(mapCoordinate);
        
        
        // Compute the current values of upperRightCorner and lowerLeftCorner of the bounding box
        if (waypointNo == 0) {
            upperRightCorner = mapPoint;
            lowerLeftCorner = mapPoint;
        }
        else {
            if (mapPoint.x > upperRightCorner.x) upperRightCorner.x = mapPoint.x;
            if (mapPoint.y > upperRightCorner.y) upperRightCorner.y = mapPoint.y;
            if (mapPoint.x < lowerLeftCorner.x) lowerLeftCorner.x = mapPoint.x;
            if (mapPoint.y < lowerLeftCorner.y) lowerLeftCorner.y = mapPoint.y;
        }
        
        // Add the new mapPoint into the C array arrayOfMapPoints
        arrayOfMapPoints[waypointNo] = mapPoint;
    }
    
    // Create the tripTrack as a polyline using the arrayOfMapPoints
    self.tripTrack = [MKPolyline polylineWithPoints:arrayOfMapPoints count:numberOfWaypoints];
    
    // We compute a box to bound all of the tracks so that we can zoom in on it
    // Track bounding box --> (boxOrigin.x, boxOrigin.y, boxWidth, boxHeight)
    
    self.trackBoundingBox = MKMapRectMake(lowerLeftCorner.x, lowerLeftCorner.y,
                                          upperRightCorner.x - lowerLeftCorner.x,
                                          upperRightCorner.y - lowerLeftCorner.y);
    
    [self loadMapAnnotations];
}


#pragma mark - Helper Methods

-(void)loadMapAnnotations{
    
    NSMutableDictionary* selected = [self.selectedTrip objectForKey:self.selectedTripName];
    //Obtain a list of Annotation Objects
    NSArray *annotations = [selected objectForKey:@"Annotations"];
    
    //Create Annotation Objects
    for(int i = 0; i< [annotations count]; i++){
    
        NSString *annotation = [annotations objectAtIndex:i];
        
         NSArray *annotationData = [annotation componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        /*
         [annotationData objectAtIndex:0] --> Title
         [annotationData objectAtIndex:1] --> SubTitle
         [annotationData objectAtIndex:2] --> longitude
         [annotationData objectAtIndex:3] --> latitude
         */
    
        double longitude = [[annotationData objectAtIndex:2] doubleValue];
        double latitude  = [[annotationData objectAtIndex:3] doubleValue];
    
        // A map coordinate is a latitude and longitude on the spherical representation of the Earth.
        // Create a map coordinate using latitude and longitude values
        CLLocationCoordinate2D mapCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
        MapAnnotation *mapAnnotation = [[MapAnnotation alloc]
                                        initWithMapCoordinate:mapCoordinate
                                        annotationTitle:[annotationData objectAtIndex:0]
                                        annotationSubtitle:[annotationData objectAtIndex:1]];
    
        [self.mapAnnotations addObject:mapAnnotation];
    }

}

/*********************************************************
 *  Handle Long Press Gesture for the Image View         *
 ********************************************************/
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    
    // Drop a new pin and add the pin to our annotations list
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        //New Title and subtitle
        NSString* title = @"Title Goes Here";
        NSString* subtitle  = @"Subtitle Goes Here";
        
        //Create a CLLocationCoordinate2D at the touch point
        CGPoint touchPoint = [recognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        MapAnnotation *annotation = [[MapAnnotation alloc]
                                     initWithMapCoordinate:touchMapCoordinate
                                     annotationTitle:title
                                     annotationSubtitle:subtitle];
        annotation.coordinate = touchMapCoordinate;
        [self.mapView addAnnotation:annotation];
        [self.mapAnnotations addObject: annotation];
        
        
        
        //Add Annotation object to trip data
        /*
         [annotationData objectAtIndex:0] --> Title
         [annotationData objectAtIndex:1] --> SubTitle
         [annotationData objectAtIndex:2] --> longitude
         [annotationData objectAtIndex:3] --> latitude
         */
        NSMutableDictionary* tripData = [self.selectedTrip objectForKey:self.selectedTripName];
        //Obtain a list of Annotation Objects
        NSMutableArray *annotations = [tripData objectForKey:@"Annotations"];
        
        //Construct a annotations string object
        double longitude;
        longitude = touchMapCoordinate.longitude;
        double latitude;
        latitude = touchMapCoordinate.latitude;
        
        NSString* annotationString = [[NSString alloc] initWithFormat:@"%@,%@,%f,%f", title, subtitle, longitude, latitude];
        
        printf("\nlat lon of created pin: %f, %f", latitude, longitude);
        
        
        [annotations addObject:annotationString];
        //Overwrite annotations in trip data
        [tripData setObject:annotations forKey:@"Annotations"];
        
        //Overwrite trip data in selectedtrip
        [self.selectedTrip setObject:tripData forKey:self.selectedTripName];
    }
}


#pragma mark - MKMapViewDelegate Protocol Methods

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView *overlayView = nil;
    
    if(overlay == self.tripTrack)
    {
        // If not already created, create a view for overlay
        if(self.tripTrackView == nil)
        {
            self.tripTrackView = [[MKPolylineView alloc] initWithPolyline:self.tripTrack];
            self.tripTrackView.fillColor = [UIColor greenColor];
            self.tripTrackView.strokeColor = [UIColor greenColor];
            self.tripTrackView.lineWidth = 3;
        }
        overlayView = self.tripTrackView;
    }
    
    return overlayView;
}



// This MKMapViewDelegate protocol method is invoked by the system every time the addAnnotation
// or addAnnotations method is called.
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if (annotation == mapView.userLocation) {
		return nil;
	}
    MKPinAnnotationView *pinAnnotationView = [[MKPinAnnotationView alloc]
                                              initWithAnnotation:annotation
                                              reuseIdentifier:@"WaypointInfo"];
    
    // Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.frame = CGRectMake(0, 0, 23, 23);
    pinAnnotationView.rightCalloutAccessoryView = button;

    
    pinAnnotationView.animatesDrop = YES;
    pinAnnotationView.canShowCallout = YES;
    pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
    
    return pinAnnotationView;
}

//Load information to be passed to downstream controller
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    self.titleOfAnnotation = [view.annotation title];
    self.subtitleOfAnnotation = [view.annotation subtitle];
    
    self.coord= [view.annotation coordinate];
    //printf("longitude:%f, latitude:%f", self.coord.longitude, self.coord.latitude);
    [self performSegueWithIdentifier:@"ToInfo" sender:(self)];
}



- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    // Show the animated activity indicator in the status bar while the map is being loaded
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    // Hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    // Hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Compose the error message
    NSString *errorMessage = [NSString stringWithFormat:
                              @"Problem Description: %@", error.localizedDescription];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unable to Load Map"
                                                        message:errorMessage
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Delegate InfoViewController save method

//annotation information saved
-(void)infoViewController:(InfoViewController *)controller didFinishWithSave:(BOOL)save{
    
    //New Title and subtitle
    NSString* title = controller.titleTextField.text;
    NSString* subtitle = controller.subtitleTextField.text;
    printf("lat lon of controller: %f, %f", controller.coord.latitude, controller.coord.longitude);
    
    title = [title stringByReplacingOccurrencesOfString:@"," withString:@""];
    subtitle = [subtitle stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    //Retrieve Annotations array from trip data dictionary
    //Tripdata represents the dictionary object housing the trips information:
    // Date : string
    // Annotations: Array
    // Trip : Array
    NSMutableDictionary* tripData = [self.selectedTrip objectForKey:self.selectedTripName];
    //Obtain a list of Annotation Objects
    NSMutableArray *annotations = [tripData objectForKey:@"Annotations"];
    
    //retain location and information of matching annotation data
    NSArray* annotationData;
    int index;
    
    //Locate Annotation object to modify (retrieve index number)
    for(index = 0; index < [annotations count]; index++){
        
        NSString *annotation = [annotations objectAtIndex:index];
        annotationData = [annotation componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        /*
         [annotationData objectAtIndex:0] --> Title
         [annotationData objectAtIndex:1] --> SubTitle
         [annotationData objectAtIndex:2] --> longitude
         [annotationData objectAtIndex:3] --> latitude
         */
        double longitude = [[annotationData objectAtIndex:2] doubleValue];
        double latitude  = [[annotationData objectAtIndex:3] doubleValue];
        double cLongitude = controller.coord.longitude;
        double cLatitude = controller.coord.latitude;
        
        printf("\nlat lon item at index %d: %f, %f",index, latitude, longitude);
        printf ("\ndifference: %f, %f", fabs(longitude - cLongitude), fabs(latitude - cLatitude) );
        
        //Check for a match. If found break, We have our index value
        if(fabs(longitude - cLongitude) <= 0.000001 && fabs(latitude - cLatitude) < 0.000001){
            //printf("index: %d", index);
            break;
        }
    }
    
    //Overwrite information in annotations
    NSString* newAnnotation = [[NSString alloc] initWithFormat:@"%@,%@,%f,%f", title, subtitle, controller.coord.longitude, controller.coord.latitude];
    [annotations replaceObjectAtIndex:index withObject:newAnnotation];
    
    //Overwrite annotations in trip data
    [tripData setObject:annotations forKey:@"Annotations"];
    
    //Overwrite trip data in selectedtrip
    [self.selectedTrip setObject:tripData forKey:self.selectedTripName];
    
    //Reload Data
    [self.mapView removeAnnotations:self.mapAnnotations];
     self.mapAnnotations = [[NSMutableArray alloc] init];
    [self loadMapAnnotations];
    [self.mapView addAnnotations:self.mapAnnotations];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    //SAVE IMAGE IF ONE WAS USED
    //-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    
    if(controller.selectedImage != nil){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectoryPath = [paths objectAtIndex:0];
        NSString *imagePath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%d.%@",controller.tripName, index, @"jpg"]];
         NSFileManager *manager = [[NSFileManager alloc] init];
        
        NSString* directoryPath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", controller.tripName]];
        
        //If the path exists, write the image to it
        if([manager fileExistsAtPath:directoryPath]){
            [UIImageJPEGRepresentation(controller.selectedImage, 1.0) writeToFile:imagePath options:NSDataWritingAtomic error:nil];
        }else{ //Otherwise, create the path and write the file to it
            if(  [manager createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil]){
                [UIImageJPEGRepresentation(controller.selectedImage, 1.0) writeToFile:imagePath options:NSDataWritingAtomic error:nil];
            }
            else
            {
                NSLog(@"[%@] ERROR: attempting to %@ directory", [self class], controller.tripName);
                NSAssert( FALSE, @"Failed to create directory. Possibly out of disk space");
            }
        }
    }
}



#pragma mark - Prepare for Segue

//load downstream view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString* segueIdentifier = [segue identifier];
    
    //accesory button pressed. self.selectedTrip loaded with info of selected cell
    if([segueIdentifier isEqualToString:@"ToInfo"]){
        
        InfoViewController* infoViewController = [segue destinationViewController];
        [infoViewController setDelegate:self];
        [infoViewController setTitleOfAnnotation:self.titleOfAnnotation];
        [infoViewController setSubtitleOfAnnotation:self.subtitleOfAnnotation];
        [infoViewController setCoord:self.coord];
        
        //Send trip name over in file format: spaces replaced by _
        NSString* tripName = [self.selectedTripName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [infoViewController setTripName:tripName];
        //Setup annotations pass
        NSMutableDictionary* tripData = [self.selectedTrip objectForKey:self.selectedTripName];
        //Obtain a list of Annotation Objects
        NSMutableArray *annotations = [tripData objectForKey:@"Annotations"];
        [infoViewController setAnnotations:annotations];
      
    }
    
}












































@end
