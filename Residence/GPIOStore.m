//
//  GPIOStore.m
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "GPIOStore.h"
#import "GPIOClient.h"
#import "Location.h"

@interface GPIOStore()

@property (nonatomic, strong) NSMutableArray *locationsCache;
@property (nonatomic, strong) NSMutableArray *devicesCache;
@property (nonatomic, strong) NSMutableArray *outletsCache;

@end

@implementation GPIOStore

__strong static GPIOStore *_sharedInstance = nil;

-(id)init {
    self = [super init];
    if (self) {
        //Listen for application low memory warnings.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearCache)
                                                     name:UIApplicationDidReceiveMemoryWarningNotification
                                                   object:nil];
        
        //Initialize the local cache store.
        [self clearCache];
        
    }
    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearCache
{
    self.locationsCache = [[NSMutableArray alloc] init];
    self.devicesCache = [[NSMutableArray alloc] init];
    self.outletsCache = [[NSMutableArray alloc] init];
}

- (void)clearLocationCache {
    self.locationsCache = [[NSMutableArray alloc] init];
}

- (void)clearDeviceCache {
    self.devicesCache = [[NSMutableArray alloc] init];
}

- (void)clearOutletCache {
    self.outletsCache = [[NSMutableArray alloc] init];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (Location *)locationWithId:(NSInteger)locationId {
    for (Location *loc in self.locationsCache) {
        if ([loc locationId] == locationId) {
            return loc;
        }
    }
    return nil;
}

- (void)addLocation:(Location *)location {
    [self.locationsCache addObject:location];
}

- (void)deleteLocationAtIndexPath:(NSIndexPath *)indexPath {
    Location *locationToDelete = [self.locationsCache objectAtIndex:[indexPath row]];
    
    //Delete the Location from the GPIO-Master server as well
    [[GPIOClient sharedInstance] deleteLocationWithID:[locationToDelete locationId] success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"Successfully deleted location %@", JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to delete location");
    }];
    
    [self.locationsCache removeObjectAtIndex:[indexPath row]];
}

- (NSArray *) locations {
    return self.locationsCache;
}

- (void)deleteLocation:(Location *)location {
    if (location) {
        [self.locationsCache removeObject:location];
    }
}

- (Device *)deviceWithId:(NSInteger)deviceId {
    for (Device *dev in self.devicesCache) {
        if ([dev deviceId] == deviceId) {
            return dev;
        }
    }
    return nil;
}

- (void)addDevice:(Device *)device {
    if (device) {
        [self.devicesCache addObject:device];
    }
}


- (void)deleteDeviceAtIndexPath:(NSIndexPath *)indexPath {
    Device *deviceToDelete = [self.devicesCache objectAtIndex:[indexPath row]];
    
    //Delete the Location from the GPIO-Master server as well
    [[GPIOClient sharedInstance] deleteDeviceWithID:[deviceToDelete deviceId] success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"Successfully deleted device %@", JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to delete device");
    }];
    
    [self.devicesCache removeObjectAtIndex:[indexPath row]];
}


- (void)deleteDevice:(Device *)device {
    [self.devicesCache removeObject:device];
}


- (NSArray *)devices {
    return self.devicesCache;
}

- (void)addOutlet:(Outlet *)outlet {
    if (outlet) {
        [self.outletsCache addObject:outlet];
    }
}


- (void)deleteOutletAtIndexPath:(NSIndexPath *)indexPath {
    Outlet *outletToDelete = [self.outletsCache objectAtIndex:[indexPath row]];
    
    //Delete the Location from the GPIO-Master server as well
    [[GPIOClient sharedInstance] deleteOutletWithID:[outletToDelete outletId] success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"Successfully deleted outlet %@", JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to delete outlet");
    }];
    
    [self.outletsCache removeObjectAtIndex:[indexPath row]];
}


- (void)deleteOutlet:(Outlet *)outlet {
    if (outlet) {
        [self.outletsCache removeObject:outlet];
    }
}


- (NSArray *)outlets {
    return self.outletsCache;
}


- (void)updateLocation:(Location *)updatedLocation {
    for (int i = 0; i < [self.locationsCache count]; i++) {
        Location *loc = self.locationsCache[i];
        if (loc.locationId == updatedLocation.locationId) {
            self.locationsCache[i] = updatedLocation;
            break;
        }
    }
}

- (void)updateDevice:(Device *)updatedDevice {
    for (int i = 0; i < [self.devicesCache count]; i++) {
        Device *dev = self.devicesCache[i];
        if (dev.deviceId == updatedDevice.deviceId) {
            self.devicesCache[i] = updatedDevice;
            break;
        }
    }
}

- (void)updateOutlet:(Outlet *)updatedOutlet {
    for (int i = 0; i < [self.outletsCache count]; i++) {
        Outlet *out = self.outletsCache[i];
        if (out.outletId == updatedOutlet.outletId) {
            self.outletsCache[i] = updatedOutlet;
            break;
        }
    }
}

@end
