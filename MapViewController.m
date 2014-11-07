//
//  MapViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
@import CoreLocation;

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKMapItem *myMapItem;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myMapItem = [MKMapItem mapItemForCurrentLocation];

    CLLocationDegrees latitude= [self.locationData[@"latitude"] doubleValue];
     CLLocationDegrees longtitude = [self.locationData[@"longtitude"] doubleValue];


    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];

    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(latitude, longtitude);

    myAnnotation.coordinate = coord;
   myAnnotation.title = @"YOU";
    [self.mapView addAnnotation:myAnnotation];


    
}

#pragma mark - annotation pin methods

//MARK: pin callout accessory and image change
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.image = [UIImage imageNamed:@"bikeImage"];
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
