//
//  AppDelegate.h
//  Forester
//
//  Created by CS3714 on 11/29/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Global Data Trips is used by classes in this project. Trips will be a dictionary used to store
// All trip data recorded thus far.
@property (strong, nonatomic) NSMutableDictionary *trips;

@end
