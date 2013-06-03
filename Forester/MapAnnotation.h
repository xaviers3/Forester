//
//  MapAnnotation.h
//  Forester
//
//  Created by CS4704 on 12/14/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface MapAnnotation : NSObject <MKAnnotation>

// MKAnnotation Protocol requires methods: coordinate, title, and subtitle

@property (nonatomic, readwrite)    CLLocationCoordinate2D  coordinate;
@property (nonatomic, strong)       NSString                *annotationTitle;
@property (nonatomic, strong)       NSString                *annotationSubtitle;


// Our instance method for initializing the annotation object
- (id)initWithMapCoordinate:(CLLocationCoordinate2D)coordinate
            annotationTitle:(NSString *)title
         annotationSubtitle:(NSString *)subtitle;

/*
 MKAnnotation Protocol requires the explicit declarations and implementations
 of the methods: title and subtitle. It asks the annotation object to return
 a title and subtitle for the annotation.
 */
- (NSString *)title;
- (NSString *)subtitle;

@end
