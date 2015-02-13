//
//  Earthquake.m
//  EarthquakeMap
//
//  Created by Jeremy on 2/7/15.
//  Copyright (c) 2015 Jeremy. All rights reserved.
//

#import "Earthquake.h"
@implementation Earthquake



-(instancetype)initWithCoordinates:(CLLocationCoordinate2D) coords depth:(float)depth magnitude:(float)mag significance: (NSUInteger)sig place:(NSString *)place type:(NSString *)type date:(NSDate *)date
{
    self = [super init];
    if(self){
        self.coordinates = coords;
        self.depth = depth;
        self.magnitude = mag;
        self.significance = sig;
        self.place = place;
        self.type = type;
        self.date = date;
    }
    return self;
}

@end
