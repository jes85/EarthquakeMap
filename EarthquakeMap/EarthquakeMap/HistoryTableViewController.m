//
//  HistoryTableViewController.m
//  EarthquakeMap
//
//  Created by Jeremy on 2/8/15.
//  Copyright (c) 2015 Jeremy. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "Constants.h"
#import "Earthquake.h"
#import "DetailsViewController.h"

@interface HistoryTableViewController ()

@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = kHistoryTVCTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [self.earthquakesArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kEarthquakeHistoryCellReuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Earthquake *earthquake = [self.earthquakesArray objectAtIndex: indexPath.row];
    cell.textLabel.text = earthquake.place;
    
    //NSString *coordinates = [NSString stringWithFormat:@"Latitude: %f Longitude: %f", earthquake.coordinates.latitude, earthquake.coordinates.longitude];
    NSString *dateLabel = [DetailsViewController stringForDate:earthquake.date];
    cell.detailTextLabel.text = dateLabel;
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:kShowDetailFromHistorySegueIdentifier]){
        if([[segue destinationViewController] isKindOfClass:[DetailsViewController class]]){
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            Earthquake *earthquake = self.earthquakesArray[indexPath.row];
            DetailsViewController *vc = [segue destinationViewController];
            vc.earthquake = earthquake;
        }
    }
}


@end
