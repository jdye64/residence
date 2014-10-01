//
//  GPIOStore.h
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Location.h"
#import "Device.h"
#import "Outlet.h"

@interface GPIOStore : NSObject

+ (instancetype)sharedInstance;

//Operations to clear the cache.
- (void)clearLocationCache;
- (void)clearDeviceCache;
- (void)clearOutletCache;

//Locations
- (Location *)locationWithId:(NSInteger)locationId;
- (void)addLocation:(Location *)location;
- (void)updateLocation:(Location *)updatedLocation;
- (void)deleteLocationAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteLocation:(Location *)location;
- (NSArray *)locations;

//Devices
- (Device *)deviceWithId:(NSInteger)deviceId;
- (void)addDevice:(Device *)device;
- (void)updateDevice:(Device *)updatedDevice;
- (void)deleteDeviceAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteDevice:(Device *)device;
- (NSArray *)devices;

//Outlets
- (void)addOutlet:(Outlet *)outlet;
- (void)updateOutlet:(Outlet *)updatedOutlet;
- (void)deleteOutletAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteOutlet:(Outlet *)outlet;
- (NSArray *)outlets;

@end
