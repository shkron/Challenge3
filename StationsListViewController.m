//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "MapViewController.h"
@import CoreLocation;

#define kJSONURL @"http://www.bayareabikeshare.com/stations/json"

@interface StationsListViewController () <CLLocationManagerDelegate, UITabBarDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *tableViewArray;
@property CLLocationManager *locationManager;


@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [CLLocationManager new];
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.navigationItem.title = @"Locating you...";

    [self dataWithURLString:kJSONURL];



}


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO: PinkPanther's TODO list: TODO, TODO, TODO TODO TODO TODO TODOOOOOOOOO
    return self.tableViewArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *cellData = self.tableViewArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"bikeImage"];
    cell.textLabel.text = cellData[@"stAddress1"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",cellData[@"availableBikes"]];
    
    return cell;
}

#pragma mark - CoreLocation

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self networkAlertWindow:error.localizedDescription];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for (CLLocation *location in  locations)
    {
        if (location.verticalAccuracy <1000 && location.horizontalAccuracy < 1000)
        {
            self.navigationItem.title = @"Located.";
//            [self reverseGeocode:location];
            [self.locationManager stopUpdatingLocation];

            break;
        }
    }
}



#pragma mark - custom methods

-(void)dataWithURLString:(NSString *)urlString
{

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                           if (connectionError)
                                           {
                                               [self networkAlertWindow:connectionError.localizedDescription];
                                           }
                                           else
                                           {
                                               NSDictionary *rawJSONDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                               self.tableViewArray = rawJSONDict[@"stationBeanList"];
                                               [self.tableView reloadData];
                                           }
                                           
                                       }];
}


-(void)networkAlertWindow:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Connection Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"MKay..." style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}



@end
