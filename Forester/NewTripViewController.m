//
//  NewTripViewController.m
//  Forester
//
//  Created by CS4704 on 12/14/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import "NewTripViewController.h"
#import "ButtonLoader.h"

@interface NewTripViewController ()

@end

@implementation NewTripViewController
int count= 0;
CLLocation* startingLocation;

int cancelPressed;
bool shouldContinue = NO;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.mapView setDelegate:self];
    //Customize button look and feel
	[ButtonLoader loadButtonImage:self.playPauseButton];
    
    // Set the map type to hybrid view
    self.mapView.mapType = MKMapTypeHybrid;
    
    // Instantiate a Save button to invoke the save: method when tapped
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                   target:self action:@selector(save:)];
    
    
    
    // Set up the Save custom button on the right of the navigation bar
    self.navigationItem.rightBarButtonItem = saveButton;
    
    //Initializations
    self.mapAnnotations = [[NSMutableArray alloc] init];
    self.tripData = [[NSMutableDictionary alloc] init];
    self.annotationsArray = [[NSMutableArray alloc] init];
    self.tripArray = [[NSMutableArray alloc] init];
    
    //Load Date - returns 2011-02-28 09:57:49 +0000 in array format
    self.dateString = [[self loadDate] objectAtIndex:0];
    
    //Set up Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
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


#pragma mark - Delegate Alertview

//Helps save call
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!buttonIndex == [alertView cancelButtonIndex]){
        [self.delegate newTripViewController:self didFinishWithSave:YES];
    }
}

#pragma mark - Buttons
//Save Button Has been pressed
- (void)save:(id)sender{
    // Inform the delegate that the user tapped the Save button
    [self.tripData setObject:self.dateString forKey:@"Date"];
    [self.tripData setObject:self.annotationsArray forKey:@"Annotations"];
    [self.tripData setObject:self.tripArray forKey:@"Trip"];
    
    //Show textfield
    UIAlertView *prompt = [[UIAlertView alloc] initWithTitle:@"Please enter a trip Title:"
                                                     message:@"\n\n"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Save", nil];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 50, 260, 25)];
    [self.textField setBackgroundColor:[UIColor whiteColor]];
    [self.textField setPlaceholder:@"Name for message"];
    [prompt addSubview:self.textField];
    
    // show the dialog box
    [prompt show];
    // set cursor and show keyboard
    [self.textField becomeFirstResponder];
    return;
}


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

- (IBAction)playPauseButtonPressed:(UIButton *)sender {
    count++;
    if(count % 2 == 1){
        [self.locationManager startUpdatingLocation];
        [self.playPauseButton setTitle:@"Recording" forState:UIControlStateNormal];
        
        if(count > 1){
            //Zoom in to the level of the track bounding box
            [self.mapView setVisibleMapRect:self.trackBoundingBox];
        }
        
    }else{
        [self.locationManager stopUpdatingLocation];
        [self.playPauseButton setTitle:@"Paused" forState:UIControlStateNormal];
    }
}

#pragma mark - Helper Methods

-(NSArray*) loadDate{
    //Get todays Date and format as yyyy-mm-dd
    NSDate* now = [NSDate date];
    NSString *fullDate = [[NSString alloc] initWithFormat:@"%@",now]; // now: 2011-02-28 09:57:49 +0000
    NSArray *arr = [fullDate componentsSeparatedByString:@" "];
    return arr;
}


- (IBAction)sampleRateChanged:(UISlider *)sender {
    double sampleValue = [sender value];
    if((int)sampleValue == 20){
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        NSLog(@"filter = none");
    }else{
        self.locationManager.distanceFilter = 20-sampleValue;
    }
}

-(void)loadMapAnnotations{
    
    //Create Annotation Objects
    for(int i = 0; i< [self.annotationsArray count]; i++){
        
        NSString *annotation = [self.annotationsArray objectAtIndex:i];
        
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
        
        //Construct a annotations string object
        double longitude;
        longitude = touchMapCoordinate.longitude;
        double latitude;
        latitude = touchMapCoordinate.latitude;
        
        NSString* annotationString = [[NSString alloc] initWithFormat:@"%@,%@,%f,%f", title, subtitle, longitude, latitude];
        
        
        [self.annotationsArray addObject:annotationString];
        //Overwrite annotations in trip data
    }
}


#pragma mark - Delegate Location Manager Methods

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(count %2 == 1){
        [self.mapView setCenterCoordinate: userLocation.location.coordinate animated:YES];
    }
}

//Location Updated. Retrieve Location and store in tripArray
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //NSLog(@"updated!");
    
    //Prepare tripArray Data and add to current trip data
    for (int i = 0; i<[locations count]; i++) {
        CLLocation *location = [locations objectAtIndex:i];
        double longitude = location.coordinate.longitude;
        double latitude = location.coordinate.latitude;
        
        if(count == 0){
            startingLocation = location;
        }
        
        // now: 2011-02-28 09:57:49 +0000
        NSArray* date = [self loadDate];
        
        NSString* formattedTripData = [[NSString alloc] initWithFormat:@"%@ %@,%f,%f", [date objectAtIndex:0], [date objectAtIndex:1], longitude, latitude];
        
        //Add formatted string to tripArray
        [self.tripArray addObject:formattedTripData];
        //NSLog(@"trip string: %@", formattedTripData);
        
        [self loadTripTrack];
        if (self.tripTrack != nil) {
            
            // Add the created trip track overlay to the map
            [self.mapView addOverlay:self.tripTrack];
            
            // Add the annotations to the map
            //[self.mapView addAnnotations:self.mapAnnotations];
        }
        
    }
}

//Load information to be passed to downstream controller
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    self.titleOfAnnotation = [view.annotation title];
    self.subtitleOfAnnotation = [view.annotation subtitle];
    
    self.coord = [view.annotation coordinate];
    //printf("longitude:%f, latitude:%f", self.coord.longitude, self.coord.latitude);
    [self performSegueWithIdentifier:@"ToInfo" sender:(self)];
}


#pragma mark - Creation of a Polyline Overlay
-(void) loadTripTrack{
    //LOAD USING PLIST IN MAINBUNDLE
    
    
    //Each waypoint is set up as follows:
    NSArray *waypoints = self.tripArray;
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

}

#pragma mark - MKMapViewDelegate Protocol Methods

//This MKMapViewDelegate protocol method is invoked by the system every time the addAnnotation
//or addAnnotations method is called.
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


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKOverlayView *overlayView = nil;
    
    if(overlay == self.tripTrack)
    {
        self.tripTrackView = [[MKPolylineView alloc] initWithPolyline:self.tripTrack];
        self.tripTrackView.fillColor = [UIColor greenColor];
        self.tripTrackView.strokeColor = [UIColor greenColor];
        self.tripTrackView.lineWidth = 3;
        overlayView = self.tripTrackView;
    }
    
    return overlayView;
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
    
    
    //retain location and information of matching annotation data
    NSArray* annotationData;
    int index;
    
    //Locate Annotation object to modify (retrieve index number)
    for(index = 0; index < [self.annotationsArray count]; index++){
        
        NSString *annotation = [self.annotationsArray objectAtIndex:index];
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
        
        //Check for a match. If found break, We have our index value
        if(fabs(longitude - cLongitude) <= 0.000001 && fabs(latitude - cLatitude) < 0.000001){
            //printf("index: %d", index);
            break;
        }
    }
    
    //Overwrite information in annotations
    NSString* newAnnotation = [[NSString alloc] initWithFormat:@"%@,%@,%f,%f", title, subtitle, controller.coord.longitude, controller.coord.latitude];
    [self.annotationsArray replaceObjectAtIndex:index withObject:newAnnotation];
    
    
    //Reload Data
    [self.mapView removeAnnotations:self.mapAnnotations];
    self.mapAnnotations = [[NSMutableArray alloc] init];
    [self loadMapAnnotations];
    [self.mapView addAnnotations:self.mapAnnotations];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    //SAVE IMAGE IF ONE WAS USED
    
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
        
        //Send trip name over
        NSString* tripName = @"temp";
        [infoViewController setTripName:tripName];
        //Setup annotations pass
        [infoViewController setAnnotations:self.annotationsArray];
        
    }
    
}




































@end
