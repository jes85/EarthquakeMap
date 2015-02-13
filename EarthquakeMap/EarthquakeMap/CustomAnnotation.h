//
//  CustomAnnotation.h
//  EarthquakeMap
//
//  Created by Jeremy on 2/9/15.
//  Copyright (c) 2015 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property(nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic) NSUInteger index;

- (id)initWithLocation:(CLLocationCoordinate2D)coord title:(NSString *)t subtitle:(NSString *)st index:(NSUInteger) i;

@end
