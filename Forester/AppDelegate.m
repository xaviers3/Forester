//
//  AppDelegate.m
//  Forester
//
//  Created by CS3714 on 11/29/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //customizes the appearance of the app
    //[self customizeAppearance];
    
    //load the trips plist file from the documents directory. If none exists, create one
    [self loadTripsFromDocumentsDirectory];
    
    //TEST
    //[self loadTripFromMainBundle];
    
    return YES;
}

/*******************************
 CUSTOMIZE APPEARANCE
 ******************************/

-(void)customizeAppearance {
    /******************************
     NavigationBar customization
     *****************************/
    
    //create navigation bar background image
    UIImage *navBarImage = [UIImage imageNamed:@"nav-bar.png"];
    
    //set the navigation bar background image
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
    //create a button image for generic use that can be resizable
    UIImage *barButton = [[UIImage imageNamed:@"bar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    //set the button background image
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //create a back button image
    UIImage *backButton = [[UIImage imageNamed:@"back-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 6)];
    
    //set the back button background image
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    /**************************
     TabBar customization
     ************************/
    
    /*Here we customize our NavigationBar with the custom images*/
    
    //create an image for tabbar background
    UIImage *tabBarImage = [UIImage imageNamed:@"tab-bar.png"];
    
    //set the tabBar background image
    [[UITabBar appearance] setBackgroundImage:tabBarImage];
    
    //sets the tint color of the uitabbar texts to the white color
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
}
							
// Write the foodPoints and myPoints dictionary data structures to hard disk before the app becomes inactive
- (void)applicationWillResignActive:(UIApplication *)application
{
    [self writeTrips];
}


-(void) loadTripFromMainBundle{
    
    NSString *plistFilePathInMainBundle = [[NSBundle mainBundle] pathForResource:@"trips" ofType:@"plist"];
    
    // Instantiate a modifiable dictionary and initialize it with the content of the plist file in main bundle
    NSMutableDictionary* tripsData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInMainBundle];
    self.trips = tripsData;
}



#pragma mark - helper methods

//load food points from documents directory
-(void) loadTripsFromDocumentsDirectory{
    /************************************
     All application-specific and user data files must be written to the Documents directory. Nothing can be written
     into application's main bundle because it is locked for writing after your app is published. The contents of the
     Documents directory are backed up by iTunes during backup of an iOS device. Therefore, the user can recover the
     data written by your app from an earlier device backup.
     
     The Documents directory path on an iOS device is different from the one used for iOS Simulator.
     
     To obtain the Documents directory path, you use the NSSearchPathForDirectoriesInDomains function.
     However, this function was designed originally for Mac OS X, where multiple such directories could exist.
     Therefore, it returns an array of paths rather than a single path.
     For iOS, the resulting array's objectAtIndex:0 is the path to the Documents directory.
     ************************************/
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"trips.plist"];
    
    // Instantiate a modifiable dictionary and initialize it with the content of the plist file
    NSMutableDictionary *tripsData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInDocumentsDirectory];
    
    if (!tripsData) {
        /*
         In this case, the trips.plist file does not exist in the documents directory.
         This will happen when the user launches the app for the very first time.
         Therefore, read the plist file from the main bundle to show the user some example trips.
         
         Get the file path to the trips.plist file in application's main bundle.
         */
        NSString *plistFilePathInMainBundle = [[NSBundle mainBundle] pathForResource:@"trips" ofType:@"plist"];
        
        // Instantiate a modifiable dictionary and initialize it with the content of the plist file in main bundle
        tripsData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistFilePathInMainBundle];
    }
    
    self.trips = tripsData;
}



-(void) writeTrips{
    // Write the trips dictionary data structure to hard disk before the app becomes inactive
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *plistFilePathInDocumentsDirectory = [documentsDirectoryPath stringByAppendingPathComponent:@"trips.plist"];
    
    [self.trips writeToFile:plistFilePathInDocumentsDirectory atomically:YES];
    /*
     The flag "atomically" specifies whether the file should be written atomically or not.
     
     If flag is YES, the trips dictionary is written to an auxiliary file, and then the auxiliary file is
     renamed to path plistFilePathInDocumentsDirectory
     
     If flag is NO, the trips dictionary is written directly to path plistFilePathInDocumentsDirectory.
     
     The YES option guarantees that the path will not be corrupted even if the system crashes during writing.
     */
}
























































@end
