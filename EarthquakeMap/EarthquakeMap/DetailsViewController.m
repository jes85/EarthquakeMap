//
//  DetailsViewController.m
//  EarthquakeMap
//
//  Created by Jeremy on 2/8/15.
//  Copyright (c) 2015 Jeremy. All rights reserved.
//

#import "DetailsViewController.h"
#import "Constants.h"
#import "Earthquake.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *depthLabel;
@property (weak, nonatomic) IBOutlet UILabel *magnitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *significanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.placeLabel.text = [kPlaceLabel stringByAppendingString:self.earthquake.place];
    self.latitudeLabel.text = [kLatitudeLabel stringByAppendingString:[NSString stringWithFormat:@"%f", self.earthquake.coordinates.latitude]];
    self.longitudeLabel.text = [kLongitudeLabel stringByAppendingString:[NSString stringWithFormat:@"%f",self.earthquake.coordinates.longitude]];
    self.depthLabel.text = [kDepthLabel stringByAppendingString:[NSString stringWithFormat:@"%f",self.earthquake.depth]];
    self.magnitudeLabel.text = [kMagnitudeLabel stringByAppendingString:[NSString stringWithFormat:@"%f",self.earthquake.magnitude]];
    self.significanceLabel.text = [kSignificanceLabel stringByAppendingString:[NSString stringWithFormat:@"%lu",self.earthquake.significance]];
    self.typeLabel.text = [kTypeLabel stringByAppendingString:self.earthquake.type];
    
    NSString *formattedDate = [DetailsViewController stringForDate:self.earthquake.date];
    self.dateLabel.text = [kDateLabel stringByAppendingString:formattedDate];
    
    
    self.navigationItem.title = kDetailVCTitle;
}

+(NSString *)stringForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [dateFormatter stringFromDate:date];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
