//
//  USGSData.h
//  EarthquakeMap
//
//  Created by Jeremy on 2/7/15.
//  Copyright (c) 2015 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USGSData : NSObject <NSURLConnectionDelegate>


-(void)getEarthquakeDataForstarttime: (NSString *)starttime endtime:(NSString *)endtime latitude:(double)latitude longitude:(double) longitude maxradiuskm:(float)maxradiuskm;

@end
