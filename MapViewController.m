//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKMapItem *myMapItem;
@property (strong, nonatomic) MKPointAnnotation *myAnnotation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myMapItem = [MKMapItem mapItemForCurrentLocation];

    CLLocationDegrees latitude = [self.locationData[@"latitude"] doubleValue];
     CLLocationDegrees longitude = [self.locationData[@"longitude"] doubleValue];


    MKPointAnnotation *bikeAnnotation = [[MKPointAnnotation alloc] init];

    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longitude);

    bikeAnnotation.coordinate = coord;
    bikeAnnotation.title = self.locationData[@"stAddress1"];

    CLLocationCoordinate2D center = bikeAnnotation.coordinate;
    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = 0.5;
    coordinateSpan.longitudeDelta = 0.5;
    MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
//    CLLocationDegrees myLatitude = self.myMapItem.placemark.coordinate.latitude;
//    CLLocationDegrees myLongitude = self.myMapItem.placemark.coordinate.longitude;
//    CLLocationCoordinate2D myCoord = CLLocationCoordinate2DMake(self.myLocation.coordinate, myLongitude);
    self.myAnnotation = [[MKPointAnnotation alloc] init];
    self.myAnnotation.coordinate = self.myLocation.coordinate;
    self.myAnnotation.title = @"YOU";


    [self.mapView addAnnotation:self.myAnnotation];
    [self.mapView addAnnotation:bikeAnnotation];
    [self.mapView setRegion:region animated:YES];


    
}

#pragma mark - annotation pin methods

//MARK: pin callout accessory and image change
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    if([annotation isEqual:self.myAnnotation])
    {
        
    }
    else
    {
        pin.image = [UIImage imageNamed:@"bikeImage"];
    }
    return pin;
    
}



-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CLLocationCoordinate2D center = [view.annotation coordinate];
    NSString *busStopTitle = [view.annotation title];
//    NSDictionary *busStopDict = [self.detailByTitleDict objectForKey:busStopTitle];
//    BusStop *busStopInfo = [[BusStop alloc] initWithDictionary:busStopDict];
//    [self performSegueWithIdentifier:@"bustStopDetailInfo" sender:(BusStop *)busStopInfo];

    MKCoordinateSpan coordinateSpan;
    coordinateSpan.latitudeDelta = .05;
    coordinateSpan.longitudeDelta = .05;

    MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
    [self.mapView setRegion:region animated:YES];

}

#pragma mark - custom methods

- (void) zoomInWithPlaceString:(NSString *)address
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
        {
            NSLog(@"Som Ting Wong");
        }
        else
        {
            for (CLPlacemark *placemark in placemarks)
            {
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.coordinate = placemark.location.coordinate;
                annotation.title = placemark.name; //placemark.subLocality
                CLLocationCoordinate2D center = annotation.coordinate;
                MKCoordinateSpan coordinateSpan;
                coordinateSpan.latitudeDelta = 0.5;
                coordinateSpan.longitudeDelta = 0.5;

                MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
                [self.mapView setRegion:region animated:YES];
                //                [self.mapView addAnnotation:annotation];
            }
        }
    }];
    
    
}


@end
