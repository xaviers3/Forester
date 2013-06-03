//
//  AllTripsViewController.h
//  Forester
//
//  Created by CS4704 on 12/17/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ExistingTripViewController.h"

@interface AllTripsViewController : UITableViewController

//Dictionary holding all myPoints information
@property (nonatomic, strong) NSMutableDictionary* dict1DateDict2;

//Key values for dict1. Updates only when inserting or removing a set of trips
@property (nonatomic, strong) NSArray* dates;

//trip dictionary
@property (strong, nonatomic) NSMutableDictionary* dict2tripNameDict3;

//trips names. Updates when dict2 updates
@property (strong, nonatomic) NSArray* tripNames;

//contains String date, as well as arrays of annotation data and trip data
@property (strong, nonatomic) NSMutableDictionary* dict3InfoData;


//Dictionary Storing information about a particular trip
@property (strong, nonatomic) NSMutableDictionary* selectedTrip;
@property (strong, nonatomic) NSString* selectedTripName;


@end
