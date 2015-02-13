//
//  USGSData.m
//  EarthquakeMap
//
//  Created by Jeremy on 2/7/15.
//  Copyright (c) 2015 Jeremy. All rights reserved.
//

#import "USGSData.h"
#import "Earthquake.h"
#import "Constants.h"

@interface USGSData ()

@property (nonatomic) NSMutableData *responseData;

@end

@implementation USGSData

#pragma mark - Communicate with view controller

// Query USGS for earthquake data
-(void)getEarthquakeDataForstarttime: (NSString *)starttime endtime:(NSString *)endtime latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees) longitude maxradiuskm:(float)maxradiuskm
{
    
    //Creat url with format: http://comcat.cr.usgs.gov/fdsnws/event/1/[METHOD[?PARAMETERS]]
    NSString *url = [NSString stringWithFormat:@"http://comcat.cr.usgs.gov/fdsnws/event/1/query?starttime=%@&endtime=%@&latitude=%f&longitude=%f&maxradiuskm=%f&format=geojson&orderby=time", starttime, endtime, latitude, longitude, maxradiuskm];
    
    NSLog(@"%@", url);

    // Create the request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
}

// Parse full earthquake data
-(NSMutableArray *)makeEarthquakesArrayFromData:(NSData *)data

{
    NSError *localError = nil;
    NSDictionary *parsedJSONObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    if(localError){
        //Option to notify view controller to display error message
        return nil;
    }
    
    NSArray *geojsonObject = [parsedJSONObject valueForKey:kGeoJsonKeyFeatures];
    NSDictionary *metadata = [parsedJSONObject valueForKey:kGeoJsonKeyMetadata];
    NSUInteger count = [[metadata valueForKey:kGeoJsonKeyCount] integerValue];
    
    return [self makeEarthquakesArrayFromGeoJsonObject:geojsonObject count:count];
    
}

// Parse geojsonObjects
-(NSMutableArray *)makeEarthquakesArrayFromGeoJsonObject: (NSArray *)geojsonObject count:(NSUInteger) count
{
    NSMutableArray *earthquakesArray = [[NSMutableArray alloc]init];
    
    for(int i = 0; i<count; i++){
        NSDictionary *feature = [geojsonObject objectAtIndex:i];
        Earthquake *earthquake = [self earthquakeObjectForFeature:feature];
        [earthquakesArray addObject:earthquake];
    }

    return earthquakesArray;
}
    
// Parse single earthquake data
-(Earthquake *)earthquakeObjectForFeature:(NSDictionary *)feature
{
    
    NSDictionary *geometry = [feature valueForKey:kGeoJsonKeyGeometry];
    
        NSArray *geojsonCoordinates =[geometry objectForKey:kGeoJsonKeyCoordinates];
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake([geojsonCoordinates[1] doubleValue], [geojsonCoordinates[0] doubleValue]);
        float depth = [geojsonCoordinates[2] floatValue];

    
    NSDictionary *properties = [feature valueForKey:kGeoJsonKeyProperties];
    
        float magnitude = [[properties objectForKey:kGeoJsonKeyMag] floatValue];
        NSUInteger significance = [[properties objectForKey:kGeoJsonKeySig]integerValue];
        NSString *place = [properties objectForKey:kGeoJsonKeyPlace];
        NSString *type = [properties objectForKey:kGeoJsonKeyType];
        long time = (long)[[properties objectForKey:kGeoJsonKeyTime] longValue];

    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setDay:1];
    [components setMonth:1];
    [components setYear:1970];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *epoch = [calendar dateFromComponents:components];
    NSDate *date = [NSDate dateWithTimeInterval:time/1000 sinceDate:epoch];
    
    
    Earthquake *earthquake = [[Earthquake alloc]initWithCoordinates:coordinates depth:depth magnitude:magnitude significance:significance place:place type:type date:date];
    
   

    return  earthquake;
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // Initialize response data instance variable for use later. This method is called each time there is a redirect so reinitializing it also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the response data instance variable
    [_responseData appendData:data];
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    
    // Parse data and notify view controller that earthquake data is ready
    NSArray *earthquakeArray = [self makeEarthquakesArrayFromData:_responseData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kEarthquakeNotificationName object:self userInfo:@{kEarthquakeNotificationUserInfoArrayKey:earthquakeArray}];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed
    
    // Option to notify view controller that request for earthquake data has failed
    
}
@end
