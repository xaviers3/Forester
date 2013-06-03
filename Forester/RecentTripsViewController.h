//
//  RecentTripsViewController.h
//  Forester
//
//  Created by CS4704 on 11/29/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ExistingTripViewController.h"
#import "NewTripViewController.h"


@interface RecentTripsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NewTripViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *recentTableView;
- (IBAction)beginNewTrip:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *beginNewTripButton;

//Dictionary holding all myPoints information
@property (nonatomic, strong) NSMutableDictionary* dict1DateDict2;

//Key values for dict1. Updates only when inserting or removing a set of trips
@property (nonatomic, strong) NSMutableArray* dates;

//trip dictionary
@property (strong, nonatomic) NSMutableDictionary* dict2tripNameDict3;

//trips names. Updates when dict2 updates
@property (strong, nonatomic) NSMutableArray* tripNames;

//contains String date, as well as arrays of annotation data and trip data
@property (strong, nonatomic) NSMutableDictionary* dict3InfoData;

//Count the number of trips per date of the sorted dates up to 5 trips.
//Numbers stored in NSnumber objects
/**
 * For the Example trips.plist file, the array will be constructed as follows:
 * (Dates in order: 2012-12-04, 2011-07-20, 2011-07-18, 2011-05-28, 2011-04-02)
 
 what is a category
 *
 * t[0] = 1
 * t[1] = 1
 * t[2] = 2
 * t[3] = 1
 *
 */
@property (strong, nonatomic) NSMutableArray* tripsPerSortedDate;

//trip dictionary
@property (strong, nonatomic) NSMutableDictionary* topFiveTrips;

//trip names
@property (strong, nonatomic) NSMutableArray* topFiveTripNames;

//Dictionary Storing information about a particular trip
@property (strong, nonatomic) NSMutableDictionary* selectedTrip;
@property (strong, nonatomic) NSString* selectedTripName;

@end
