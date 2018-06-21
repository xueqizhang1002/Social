//
//  SCLocationManager.m
//  SocialApp
//
//  Created by Michelle on 12/31/17.
//  Copyright © 2017 Zhang, Suki. All rights reserved.
//

#import "SCLocationManager.h"
#import <MapKit/MapKit.h>

NSString * const SCLocationUpdateNotification = @"SCLocationUpdateNotification";

@interface SCLocationManager () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocationManager *CLManager;

@end

@implementation SCLocationManager

+ (instancetype)sharedManager {
    static SCLocationManager *locationManager = nil;
    @synchronized(self) {
        if (locationManager == nil) {
            locationManager = [SCLocationManager new];
            locationManager.CLManager = [CLLocationManager new];
            locationManager.CLManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            locationManager.CLManager.distanceFilter = 1000.0;
        }
    }
    return locationManager;
}

- (void)getUserPermission {
    if (([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) || ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways)) {
        [self.CLManager requestWhenInUseAuthorization];
    }
}

+ (BOOL)isLocationServicesEnabled {
    return [CLLocationManager locationServicesEnabled];
}

- (CLLocation *)getUserCurrentLocation {
    return self.currentLocation;
}

- (void)stopLoadUserLocation {
    [self.CLManager stopUpdatingLocation];
}

- (void)startLoadUserLocation {
    self.CLManager.delegate = self;
    [self getUserPermission];
    [self.CLManager startMonitoringSignificantLocationChanges];
    [self.CLManager startUpdatingLocation];
}

- (BOOL)coordinateA:(CLLocationCoordinate2D)coordinateA isSameAsCoordinateB:(CLLocationCoordinate2D)coordinateB {
    if ((fabs(coordinateA.latitude - coordinateB.latitude) <= 0.005) && (fabs(coordinateA.longitude - coordinateB.longitude) <= 0.005)) {
        return YES;
    }
    return NO;
}

- (BOOL)shouldUpdateLocationWithLastLocation:(CLLocationCoordinate2D)coordinateA andNewLocation:(CLLocationCoordinate2D)coordinateB {
    if ((fabs(coordinateA.latitude - coordinateB.latitude) > 1) || (fabs(coordinateA.longitude - coordinateB.longitude) > 1)) {
        return YES;
    }
    return NO;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    BOOL shouldUpdateLocation = NO;
    if (!self.currentLocation && locations.lastObject) {
        shouldUpdateLocation = YES;
    } else if ([self shouldUpdateLocationWithLastLocation:self.currentLocation.coordinate andNewLocation:locations.lastObject.coordinate]) {
        shouldUpdateLocation = YES;
    }
    if (shouldUpdateLocation) {
        self.currentLocation = locations.lastObject;
        NSLog(@"currentLocation is: %@", _currentLocation);
        //self.currentLocation = [[CLLocation alloc] initWithLatitude:34.099765 longitude:-118.098897];
        [[NSNotificationCenter defaultCenter] postNotificationName:SCLocationUpdateNotification object:nil];
    }
}

@end
