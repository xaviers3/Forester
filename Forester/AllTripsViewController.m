//
//  AllTripsViewController.m
//  Forester
//
//  Created by CS4704 on 12/17/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import "AllTripsViewController.h"

@interface AllTripsViewController ()

@end

@implementation AllTripsViewController


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
    self.dates = (NSArray *)[[self.dict1DateDict2 allKeys]sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dates count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* date = [self.dates objectAtIndex:section];
    //Get number of rows
    self.dict2tripNameDict3 = [self.dict1DateDict2 objectForKey:date];
    self.tripNames = [(NSArray*)[self.dict2tripNameDict3 allKeys]sortedArrayUsingSelector:@selector(compare:)];
    
    return [self.tripNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Obtain the object reference of a UITableViewCell object
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TripNameCell"];
    
    int row = [indexPath row];
    int section = [indexPath section];
    
    NSString* date = [self.dates objectAtIndex:section];
    self.dict2tripNameDict3 = [self.dict1DateDict2 objectForKey:date];
    self.tripNames = [(NSArray*)[self.dict2tripNameDict3 allKeys]sortedArrayUsingSelector:@selector(compare:)];
    
    NSString* title = [self.tripNames objectAtIndex:row];
    self.dict3InfoData = [self.dict2tripNameDict3 objectForKey:title];
    

        
    cell.textLabel.text = title;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        
    cell.detailTextLabel.text = date;
    
    return cell;
}

//Load information to be passed to downstream controller
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
    int row = [indexPath row];
    int section = [indexPath section];
    
    NSString* date = [self.dates objectAtIndex:section];
    self.dict2tripNameDict3 = [self.dict1DateDict2 objectForKey:date];
    self.tripNames = [(NSArray*)[self.dict2tripNameDict3 allKeys]sortedArrayUsingSelector:@selector(compare:)];
    NSString* title = [self.tripNames objectAtIndex:row];
    self.dict3InfoData = [self.dict2tripNameDict3 objectForKey:title];
    self.selectedTrip = [[NSMutableDictionary alloc] init];
     [self.selectedTrip setObject:self.dict3InfoData forKey:title];
    //self.selectedTrip set
    self.selectedTripName = title;
    [self performSegueWithIdentifier:@"ToExisting" sender:(self)];
}


#pragma mark - Prepare for Segue
//load downstream view controller
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString* segueIdentifier = [segue identifier];
    
    //accesory button pressed. self.selectedTrip loaded with info of selected cell
    if([segueIdentifier isEqualToString:@"ToExisting"]){
        
        ExistingTripViewController* existingTripViewController = [segue destinationViewController];
        
        [existingTripViewController setSelectedTripName:self.selectedTripName];
        [existingTripViewController setSelectedTrip:self.selectedTrip];
    }
}



@end
