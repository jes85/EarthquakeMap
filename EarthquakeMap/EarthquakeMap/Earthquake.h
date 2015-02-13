//
//  Earthquake.h
//  EarthquakeMap
//
//  Created by Jeremy on 2/7/15.
//  Copyright (c) 2015 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Earthquake : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (nonatomic) float depth;
@property (nonatomic) float magnitude;
@property (nonatomic) NSUInteger significance;
@property (nonatomic) NSDate *date; 
@property (nonatomic) NSString *place;
@property (nonatomic) NSString *type;

-(instancetype)initWithCoordinates:(CLLocationCoordinate2D) coords depth:(float)depth magnitude:(float)mag significance: (NSUInteger)sig place:(NSString *)place type:(NSString *)type date:(NSDate *)date;
@end
