//
//  CustomAnnotation.m
//  EarthquakeMap
//
//  Created by Jeremy on 2/9/15.
//  Copyright (c) 2015 Jeremy. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithLocation:(CLLocationCoordinate2D)coord title:(NSString *)t subtitle:(NSString *)st index:(NSUInteger)i{
    self = [super init];
    if (self) {
        coordinate = coord;
        title = t;
        subtitle = st;
        self.index = i;
        
    }
    return self;
}
@end
