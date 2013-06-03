//
//  MapAnnotation.m
//  Forester
//
//  Created by CS4704 on 12/14/12.
//  Copyright (c) 2012 Xavier Seymour. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

// Our instance method for initializing the annotation object
- (id)initWithMapCoordinate:(CLLocationCoordinate2D)coordinate
            annotationTitle:(NSString *)title
         annotationSubtitle:(NSString *)subtitle {
    
    self.coordinate = coordinate;
    self.annotationTitle = title;
    self.annotationSubtitle = subtitle;
    return self;
}

// Return the title of the annotation
- (NSString *)title {
    return self.annotationTitle;
}


// Return the subtitle of the annotation
- (NSString *)subtitle {
    return self.annotationSubtitle;
}

@end