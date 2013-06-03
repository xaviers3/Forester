//
//  RecentTripsViewController.m
//  Forester
//
//  Created by CS4704 on 11/29/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import "RecentTripsViewController.h"
#import "ButtonLoader.h"


@interface RecentTripsViewController ()

@end

@implementation RecentTripsViewController
int numberOfEntries;
int upToDate;


//---------------------------------------------------------------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Obtain an object reference to the App Delegate object
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Set the local instance variable to the obj ref of the myPoints dictionary
    // data structure created in the App Delegate class
    self.dict1DateDict2 = appDelegate.trips;
    
    // Obtain a descending ordered sorted list of dates and store them in a mutable array
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey: nil ascending: NO];
    self.dates = (NSMutableArray *)[[self.dict1DateDict2 allKeys]sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    self.tripsPerSortedDate = [[NSMutableArray alloc] init];
    self.topFiveTrips = [[NSMutableDictionary alloc] init];
    
    //Load top 5
    [self populateTripsPerSortedDate];
    numberOfEntries = [self populateTopFive];
    
    [ButtonLoader loadButtonImage:self.beginNewTripButton];
}


- (IBAction)beginNewTrip:(UIButton *)sender {
    // Perform the segue named ShowAddFood
    [self performSegueWithIdentifier:@"StartNewTrip" sender:self];
}


-(void)viewDidAppear:(BOOL)animated{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *directoryPath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"temp"]];
    NSFileManager *manager = [[NSFileManager alloc] init];
    //If the path exists, delete it
    if([manager fileExistsAtPath:directoryPath]){
        [manager removeItemAtPath:directoryPath error:nil];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    // Return the number of recent trips in the array as the number of rows in the given section
    return numberOfEntries;
}

// Set the table view section header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[NSString alloc] initWithFormat:@"5 most recent Trips:"];
}

// Customize the appearance of the table view cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Obtain the object reference of a UITableViewCell object
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripNameCell"];
    
    int row = [indexPath row];
    
    int count = [self.topFiveTripNames count];
    if(count != row){
        NSString* tripTitle = [self.topFiveTripNames objectAtIndex:row];
        self.dict3InfoData = [self.topFiveTrips objectForKey:tripTitle];
            
        NSString* date = [self.dict3InfoData objectForKey:@"Date"];
        cell.textLabel.text = tripTitle;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        
        cell.detailTextLabel.text = date;
    }
    
    return cell;
}

//Load information to be passed to downstream controller
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSString* selectedTripName = [self.topFiveTripNames objectAtIndex:[indexPath row]];
    self.selectedTrip = [[NSMutableDictionary alloc] init];
    [self.selectedTrip setObject:[self.topFiveTrips objectForKey:selectedTripName] forKey:selectedTripName];
    self.selectedTripName = selectedTripName;
    [self performSegueWithIdentifier:@"ToExistingTrip" sender:(self)];
}





#pragma mark - Helper Functions

-(void)populateTripsPerSortedDate{
    int count = 0;
    int i;
    for(i = 0; i< self.dates.count; i++){
        if(count >= 5) break;
        
        NSString* currDate = [self.dates objectAtIndex:i];
        self.dict2tripNameDict3 = [self.dict1DateDict2 objectForKey:currDate];
        self.tripNames = (NSMutableArray *)[[self.dict2tripNameDict3 allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        NSNumber *tripcount = [NSNumber numberWithInt:[self.tripNames count]];
        if([tripcount intValue]+count > 5){
            while ([tripcount intValue]+count > 5) {
                tripcount= [NSNumber numberWithInt:[tripcount intValue]-1];
            }
        }
        [self.tripsPerSortedDate insertObject:tripcount atIndex:i];
        count += [tripcount intValue];
    }
    upToDate = i-15;
}

//Load the topFiveTrips dictionary with the five most recent trips
-(int)populateTopFive{
    
    // counts the number of trips that have been iterated over thus far for a particular date
    int currentTripsIterated=0;
    //indicates which date we are in
    int currentDate=0;
    //Used to count the total number of trips printed to cells thus far
    int top5Count=0;
    self.topFiveTripNames = [[NSMutableArray alloc] init];
    
    for(top5Count = 0; top5Count < 5; top5Count++){
        //Get the next trips information within the same tripdate
        if(currentTripsIterated < [[self.tripsPerSortedDate objectAtIndex:currentDate] intValue]){
            //Pull the current Date
            NSString* currDate = [self.dates objectAtIndex:currentDate];
            self.dict2tripNameDict3 = [self.dict1DateDict2 objectForKey:currDate];
            self.tripNames = (NSMutableArray *)[[self.dict2tripNameDict3 allKeys] sortedArrayUsingSelector:@selector(compare:)];
            
            //add trip to topFiveTrips
            NSString* tripTitle = [self.tripNames objectAtIndex:currentTripsIterated];
            self.dict3InfoData = [self.dict2tripNameDict3 objectForKey:tripTitle];
            [self.topFiveTrips setObject:self.dict3InfoData forKey:tripTitle];
            
            [self.topFiveTripNames addObject:tripTitle];
            
            currentTripsIterated++;
        }
        else{//Load information from the next date
            currentTripsIterated = 0;
            currentDate++;
            
            int trips = [self.tripsPerSortedDate count];
            if(trips == currentDate)
                break;
            
            if(currentTripsIterated < [[self.tripsPerSortedDate objectAtIndex:currentDate] intValue]){
                //Pull the current Date
                NSString* currDate = [self.dates objectAtIndex:currentDate];
                self.dict2tripNameDict3 = [self.dict1DateDict2 objectForKey:currDate];
                self.tripNames = (NSMutableArray *)[[self.dict2tripNameDict3 allKeys] sortedArrayUsingSelector:@selector(compare:)];
                
                //add trip to topFiveTrips
                NSString* tripTitle = [self.tripNames objectAtIndex:currentTripsIterated];
                self.dict3InfoData = [self.dict2tripNameDict3 objectForKey:tripTitle];
                [self.topFiveTrips setObject:self.dict3InfoData forKey:tripTitle];
                
                [self.topFiveTripNames addObject:tripTitle];
                
                currentTripsIterated++;
            }
            
        }
    }
    
    return [self.topFiveTripNames count];
    
}


#pragma mark - Delegate Methods
//New trip is being saved. Save an instance of the trip in the trip.plist file
-(void)newTripViewController:(NewTripViewController *)controller didFinishWithSave:(BOOL)save{
    
    //Search dict1DateDict2 dates for newTrip date. If it exists, Add newTrip to dict2tripNameDict3
    //and rewrite dict2NameDict3 within dict1DateDict2
    if([self.dates containsObject:controller.dateString]){
        self.dict2tripNameDict3 = [self.dict1DateDict2 objectForKey:controller.dateString];
        self.tripNames = (NSMutableArray*)[self.dict2tripNameDict3 allKeys];
        
        
        NSString* tripTitle = controller.textField.text;
        //perform check for duplicate trip names
        NSMutableArray* lowerTripNames = [[NSMutableArray alloc] init];
        
        for(int i = 0; i<[self.tripNames count]; i++){
            NSString* name = [[self.tripNames objectAtIndex:i] lowercaseString];
            [lowerTripNames addObject:name];
            
        }
        
        if([lowerTripNames containsObject:[tripTitle lowercaseString]]){
            tripTitle = [[NSString alloc] initWithFormat:@"%@!",tripTitle];
        }
        [self.dict2tripNameDict3 setObject:controller.tripData forKey:tripTitle];
        [self.dict1DateDict2 setObject:self.dict2tripNameDict3 forKey:controller.dateString];
    }
    
    //Otherwise, we need to create a new date dictionary object within dict1DateDict2 (key: date, value: newDictionary)
    //Then, populate newDictionary with its first item (key: tripname, value: tripData)
    else{
        self.dict2tripNameDict3 = [[NSMutableDictionary alloc] init];
        [self.dict2tripNameDict3 setObject:controller.tripData forKey:controller.textField.text];
        [self.dict1DateDict2 setObject:self.dict2tripNameDict3 forKey:controller.dateString];
    }
    
    //move image data to proper folder
    NSString* tripTitle = controller.textField.text;
    tripTitle= [tripTitle stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *newDirectoryPath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", tripTitle]];
    NSString *tempDirectoryPath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"temp"]];

    //Copy temp folder to new folder
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    if(  [manager createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:NO attributes:nil error:nil]){
        if([manager fileExistsAtPath:tempDirectoryPath]){
            [manager copyItemAtPath:tempDirectoryPath toPath:newDirectoryPath error:nil];
        }
    }
    else
    {
        if([manager fileExistsAtPath:newDirectoryPath]){
            [manager removeItemAtPath:newDirectoryPath error:nil];
            [manager createDirectoryAtPath:newDirectoryPath withIntermediateDirectories:NO attributes:nil error:nil];
            if([manager fileExistsAtPath:tempDirectoryPath]){
                [manager copyItemAtPath:tempDirectoryPath toPath:newDirectoryPath error:nil];
            }
        }
    }

    
    //update arrays storing keys and reload tableview
    // Obtain a descending ordered sorted list of dates and store them in a mutable array
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey: nil ascending: NO];
    self.dates = self.dates = (NSMutableArray *)[[self.dict1DateDict2 allKeys]sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    self.tripNames = (NSMutableArray*)[self.dict2tripNameDict3 allKeys];
    
    [self populateTripsPerSortedDate];
    numberOfEntries = [self populateTopFive];
    [self.recentTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Prepare for Segue
//load downstream view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString* segueIdentifier = [segue identifier];
    
    //accesory button pressed. self.selectedTrip loaded with info of selected cell
    if([segueIdentifier isEqualToString:@"ToExistingTrip"]){
        
        ExistingTripViewController* existingTripViewController = [segue destinationViewController];
        
        [existingTripViewController setSelectedTripName:self.selectedTripName];
        [existingTripViewController setSelectedTrip:self.selectedTrip];
    }
    
    //Start new Trip button pressed. Begin new trip
    if([segueIdentifier isEqualToString:@"StartNewTrip"]){
        NewTripViewController* newTripViewController = [segue destinationViewController];
        
        [newTripViewController setDelegate:self];
    }
    
}











































@end
