//
//  DetailsViewController.h
//  EarthquakeMap
//
//  Created by Jeremy on 2/8/15.
//  Copyright (c) 2015 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Earthquake;

@interface DetailsViewController : UIViewController

@property (nonatomic) Earthquake *earthquake;

+(NSString *)stringForDate:(NSDate *)date; // used in ViewController.m and historytvc.m too

@end
