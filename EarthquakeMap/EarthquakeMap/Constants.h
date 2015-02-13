//
//  Constants.h
//  EarthquakeMap
//
//  Created by Jeremy on 2/8/15.
//  Copyright (c) 2015 Jeremy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject



//GeoJsonKeys
    #define kGeoJsonKeyType                         @"type"
    #define kGeoJsonKeyMetadata                     @"metadata"
    #define kGeoJsonKeyFeatures                     @"features"


    //Metadata parameters
    #define kGeoJsonKeyCount                        @"count"

    //Feature parameters
    #define kGeoJsonKeyProperties                   @"properties"

        //Properties parameters
        #define kGeoJsonKeyMag                      @"mag"
        #define kGeoJsonKeyPlace                    @"place"
        #define kGeoJsonKeySig                      @"sig"
        #define kGeoJsonKeyTime                     @"time"
        #define kGeoJsonKeyTz                       @"tz"


    #define kGeoJsonKeyGeometry                     @"geometry"

        //Geometry parameters
        #define kGeoJsonKeyCoordinates              @"coordinates"

//Alert View
#define kAlertLocationServicesDisabledTitle         @"Location Services Not Enabled"
#define kAlertLocationServicesDisabledMessage       @"App won't work without location services. Please go to Settings and change location authorization to When In Use"
#define kAlertLocationServicesDisabledOk            @"Ok"

//Notification - Earthquake array
#define kEarthquakeNotificationName                 @"EarthquakeArray"
#define kEarthquakeNotificationUserInfoArrayKey     @"array"

//Reuse Identifiers
#define kEarthquakeHistoryCellReuseIdentifier       @"Earthquake Cell"

//Segue Identifiers
#define kShowAnnotationDetailSegueIdentifier        @"Show Annotation Detail Segue"
#define kShowDetailFromHistorySegueIdentifier       @"Show Detail From History Segue"
#define kShowHistorySegueIdentifier                 @"Show History Segue"

//Detail Labels
#define  kPlaceLabel                                @"Place: "
#define kLatitudeLabel                              @"Latitude: "
#define kLongitudeLabel                             @"Longitude: "
#define kDepthLabel                                 @"Depth: "
#define kMagnitudeLabel                             @"Magnitude: "
#define kSignificanceLabel                          @"Significance: "
#define kTypeLabel                                  @"Type: "
#define kDateLabel                                  @"Date: "


//Earthquake Parameters (given more time I would make these adjustable user settings)
#define kNumberOfSecondsInPast                      -60*60*24*365*1 //1 year
#define kMaxRadiuskm                                40.0; //km

//Navigation Titles
#define kHistoryTVCTitle                            @"Earthquake History";
#define kDetailVCTitle                              @"Earthquake Details"



@end
