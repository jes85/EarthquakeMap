//
//  ViewController.m
//  EarthquakeMap
//
//  Created by Jeremy on 2/5/15.
//  Copyright (c) 2015 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "USGSData.h"
#import "Constants.h"
#import "HistoryTableViewController.h"
#import "DetailsViewController.h"
#import "Earthquake.h"
#import "CustomAnnotation.h"

@interface ViewController () 
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CLLocationManager *clLocationManager;
@property (nonatomic) MKUserLocation *userLocation;

@property (nonatomic) NSArray *earthquakeHistory;

//Can make these into user settings
//For now, End time = current date, Start time = a date kNumberOfSecondsInPast seconds before current date
@property (nonatomic) NSString *starttime;
@property (nonatomic) NSString *endtime;
@property (nonatomic) float maxradiuskm;


@property (weak, nonatomic) IBOutlet UIButton *historyButton;




@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.clLocationManager requestWhenInUseAuthorization];
    
    if(![self isLocationEnabled]){
        return;
    }
    
    [self setUpMapView];
    
}

-(void)setUpMapView
{
    self.mapView.delegate = self;
    self.maxradiuskm = kMaxRadiuskm;
    self.mapView.showsUserLocation = YES;
    
    // USGSData.m will post notification when it received the earthquake data
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedEarthquakeArray:) name:kEarthquakeNotificationName object:nil];
    
    // I only want to update earthquake data on a significant location change (changed distance filter instead)
    //[self.clLocationManager startMonitoringSignificantLocationChanges];
    [self.clLocationManager startUpdatingLocation];
    
    
}

-(void)resetMapView
{
    self.mapView.showsUserLocation = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.clLocationManager stopMonitoringSignificantLocationChanges];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - CLLocationManager

-(CLLocationManager *)clLocationManager
{
    if(!_clLocationManager) {
        _clLocationManager = [[CLLocationManager alloc]init];
        _clLocationManager.delegate = self;
        _clLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _clLocationManager.distanceFilter = 1000;//this can be a user setting
    }
    return _clLocationManager;

}
-(BOOL)isLocationEnabled

{
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways | [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse;
}

// Called when user's location authorization status changed
// Alert user that app won't work if their status is restricted/denied
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch(status){
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"kCLAuthorizationStatusNotDetermined");

        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"kCLAuthorizationStatusAuthorizedWhenInUse or kCLAuthorizationStatusAuthorizedAlways");
            if(self.mapView.showsUserLocation==NO){
                [self setUpMapView];
            }
        }
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        {
            NSLog(@"kCLAuthorizationStatusDenied or kCLAuthorizationStatusRestricted");
            [self resetMapView];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:kAlertLocationServicesDisabledTitle message:kAlertLocationServicesDisabledMessage delegate:self cancelButtonTitle:kAlertLocationServicesDisabledOk otherButtonTitles:nil, nil];
            [alertView show];

        }
            break;
        default:
            break;
    }
   

}
// Delegate method called when locations are updated (for some reason this is not being called, so I'm just using didUpdateUserLocation instead)
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    MKUserLocation *location = (MKUserLocation *)[locations lastObject];
    [self updateMapForLocation:location.coordinate];
    
}
// Delegate method called when locations failed to update
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

#pragma mark - Map View Methods
- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:(MKUserLocation *)newUserLocation
{
    NSLog(@"didUpdateUserLocation");
    
    //Originally I had it update here, but I only want it to update on significant location change
    //[self updateMapForLocation:newUserLocation.coordinate];
    
    
}

// Update visible map region and get new earthquake data
-(void) updateMapForLocation:(CLLocationCoordinate2D)coordinates
{
    [self updateVisibleMapRegionForLocation:coordinates];
    [self queryEarthquakesNearCurrentLocationForLatitude:coordinates.latitude longitude:coordinates.longitude];
}

-(void) updateVisibleMapRegionForLocation:(CLLocationCoordinate2D)location
{
    MKCoordinateRegion region;
    
    region.span = self.mapView.region.span;
    region.center = location;
    [self.mapView setRegion:region animated:YES];

}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"calloutAccessoryControlTapped");
    
    [self performSegueWithIdentifier:kShowAnnotationDetailSegueIdentifier sender:view];

    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    
    if([annotation isKindOfClass:[CustomAnnotation class]]){
        //try to dequeue an existing pin first
        MKPinAnnotationView *customPinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Custom Annotation View"];
        if(!customPinAnnotationView){
            customPinAnnotationView =[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"Custom Annotation View"];
        
            customPinAnnotationView.canShowCallout = YES;
           
            // Display detail disclosure button
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customPinAnnotationView.rightCalloutAccessoryView = rightButton;
        }else{
            customPinAnnotationView.annotation = annotation;
        }
        return customPinAnnotationView;
    }
    
    //if annotation is user location, return nil to use default annotation view
    return nil;
}

//These were for debugging
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
   //for debugging
}
- (void)mapView:(MKMapView *)mapView
didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"Select");
}
- (void)mapView:(MKMapView *)mapView
didDeselectAnnotationView:(MKAnnotationView *)view
{
    
}

#pragma mark - Creating Annotations
-(CustomAnnotation *)makeAnnotationAtCoordinate: (CLLocationCoordinate2D) coord WithTitle:(NSString *)t subTitle:(NSString *)st index: (NSUInteger)i
{
    CustomAnnotation *annotation = [[CustomAnnotation alloc]initWithLocation:coord title:t subtitle:st index:i];
    return annotation;
    
}
-(void)updateAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc]init];
    for(int i = 0; i<[self.earthquakeHistory count]; i++){
        Earthquake *earthquake = [self.earthquakeHistory objectAtIndex:i];
        
        //NSString *subtitle = [NSString stringWithFormat:@"Latitude: %f Longitude: %f", earthquake.coordinates.latitude, earthquake.coordinates.longitude];
        NSString *subtitle = [DetailsViewController stringForDate:earthquake.date];
        
        CustomAnnotation *annotation = [self makeAnnotationAtCoordinate:earthquake.coordinates WithTitle:earthquake.place subTitle:subtitle index:i];
        [annotations addObject:annotation];
    }
    
    //remove all previous annotations (except user location) before adding new ones
    [self removeAllAnnotations];
    
    // add new annotations and update visible map region to show them
    [self.mapView addAnnotations:annotations];
    [self.mapView showAnnotations:annotations animated:YES];
    
    
    
    //debug
    NSLog(@"Map view annotations count: %lu", (unsigned long)self.mapView.annotations.count);
}

-(void)removeAllAnnotations
{
    NSMutableArray *annotationsToRemove = [self.mapView.annotations mutableCopy];
    [annotationsToRemove removeObject:self.mapView.userLocation];
    [self.mapView removeAnnotations:annotationsToRemove];
    
}
#pragma mark - Earthquake Requests
-(void)queryEarthquakesNearCurrentLocationForLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    [self getStartAndEndTimes];
    
    USGSData *dataClass = [[USGSData alloc]init];
    [dataClass getEarthquakeDataForstarttime:self.starttime endtime:self.endtime latitude:latitude longitude:longitude maxradiuskm:self.maxradiuskm];

}
-(void)getStartAndEndTimes
{
    
    NSDate *endTime = [NSDate date];
    NSDate *startTime = [NSDate dateWithTimeInterval:kNumberOfSecondsInPast sinceDate:endTime];
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"dd"];
    NSString *startDay = [df stringFromDate:startTime];
    NSString *endDay = [df stringFromDate:endTime];
    
    [df setDateFormat:@"MM"];
    NSString *startMonth = [df stringFromDate:startTime];
    NSString *endMonth = [df stringFromDate:endTime];
    
    [df setDateFormat:@"yyyy"];
    NSString *startYear = [df stringFromDate:startTime];
    NSString *endYear = [df stringFromDate:endTime];
    
    
    
    self.starttime = [NSString stringWithFormat:@"%@-%@-%@", startYear, startMonth, startDay];
    self.endtime = [NSString stringWithFormat:@"%@-%@-%@", endYear, endMonth, endDay];
    
    

}
- (IBAction)historyButtonTapped:(id)sender {
    
}



-(void)receivedEarthquakeArray:(NSNotification *)notification
{
    NSArray *earthquakeArray = [notification.userInfo objectForKey:kEarthquakeNotificationUserInfoArrayKey];
    self.earthquakeHistory = earthquakeArray;
    [self updateAnnotations];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Pass earthquakes array to history table view controller
    if([segue.identifier isEqual: kShowHistorySegueIdentifier]){
        if(sender==self.historyButton){
            if([[segue destinationViewController] isKindOfClass:[HistoryTableViewController class] ]){
                HistoryTableViewController *vc = [segue destinationViewController];
                vc.earthquakesArray = self.earthquakeHistory;
            
            }
        }
    }
    //Pass earthquake to detail view controller
    else if ([segue.identifier isEqual: kShowAnnotationDetailSegueIdentifier]){
        if([sender isKindOfClass:[MKAnnotationView class]]){
            if([[segue destinationViewController] isKindOfClass:[DetailsViewController class]]){
                DetailsViewController *vc = [segue destinationViewController];
                MKAnnotationView *annotationView = (MKAnnotationView *)sender;
                CustomAnnotation *annotation = annotationView.annotation;
                Earthquake *earthquake = [self.earthquakeHistory objectAtIndex:annotation.index];
                vc.earthquake = earthquake;
            }
            
            
        }
    }

}
@end
