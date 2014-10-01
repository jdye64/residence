//
//  GPIOClient.m
//  Dyer
//
//  Created by Jeremy Dyer on 5/23/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "GPIOClient.h"
#import "GPIOStore.h"

@implementation GPIOClient

__strong static GPIOClient *_sharedClient = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        _sharedClient = [[self alloc] init];
    });
    
    return _sharedClient;
}

- (void) loadGPIOLocationsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString *string = [NSString stringWithFormat:@"%@/location", @"http://pi.jeremydyer.me"];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        
        [[GPIOStore sharedInstance] clearLocationCache];
        NSArray *jsonArray = [JSON objectForKey:@"locations"];
        for (id location in jsonArray) {
            [[GPIOStore sharedInstance] addLocation:[[Location alloc] initWithJSON:location]];
        }
        
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    [operation start];
}


- (void) loadDevicesForLocation:(NSInteger) locationid
                        success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString *string = [NSString stringWithFormat:@"%@/location/%ld", @"http://pi.jeremydyer.me", (long)locationid];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        
        [[GPIOStore sharedInstance] clearDeviceCache];
        NSArray *jsonArray = [JSON objectForKey:@"location_devices"];
        for (id device in jsonArray) {
            [[GPIOStore sharedInstance] addDevice:[[Device alloc] initWithJSON:device]];
        }
        
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    [operation start];
}


- (void) loadOutletsForDevice:(NSInteger) deviceId
                      success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    NSString *string = [NSString stringWithFormat:@"%@/device/%ld", @"http://pi.jeremydyer.me", (long)deviceId];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        
        [[GPIOStore sharedInstance] clearOutletCache];
        NSArray *jsonArray = [[[JSON objectForKey:@"device"] objectAtIndex:0] objectForKey:@"outlets"];
        for (id location in jsonArray) {
            [[GPIOStore sharedInstance] addOutlet:[[Outlet alloc] initWithJSON:location]];
        }
        
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
    [operation start];
}


- (void) switchOutlet:(Outlet *)outlet
          forDeviceId:(NSInteger)deviceId
               turnOn:(BOOL)turnOn
              success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString *deviceUrl = [[[GPIOStore sharedInstance] deviceWithId:deviceId] deviceUrl];
    NSString *string = [NSString stringWithFormat:@"%@/gpio/%ld", deviceUrl, (long)outlet.gpioPort];
    
    NSDictionary *params = nil;
    if (turnOn) {
        params = @ {@"channel_value": [NSNumber numberWithInt:0]};
    } else {
        params = @ {@"channel_value": [NSNumber numberWithInt:1]};
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:string parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}


- (void) addLocationWithJSON:(NSDictionary *)jsonLocationValue
              success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString *string = [NSString stringWithFormat:@"%@/location", @"http://pi.jeremydyer.me"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:string parameters:jsonLocationValue success:^(AFHTTPRequestOperation *operation, id JSON) {
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
}


- (void) updateLocationWithJSON:(NSDictionary *)jsonLocationValue
                     success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    [NSNumber numberWithInt:[[jsonLocationValue objectForKey:@"location_id"] intValue]];
    NSString *string = [NSString stringWithFormat:@"%@/location/%@", @"http://pi.jeremydyer.me", [NSNumber numberWithInt:[[jsonLocationValue objectForKey:@"location_id"] intValue]]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager PUT:string parameters:jsonLocationValue success:^(AFHTTPRequestOperation *operation, id JSON) {
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
    
}


- (void) deleteLocationWithID:(NSInteger)locationId
                      success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString *string = [NSString stringWithFormat:@"%@/location/%ld", @"http://pi.jeremydyer.me", (long)locationId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager DELETE:string parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void) addDeviceWithJSON:(NSDictionary *)jsonDeviceValue
                   success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString *string = [NSString stringWithFormat:@"%@/device", @"http://pi.jeremydyer.me"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:string parameters:jsonDeviceValue success:^(AFHTTPRequestOperation *operation, id JSON) {
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void) updateDeviceWithJSON:(NSDictionary *)jsonDeviceValue
                   success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString *string = [NSString stringWithFormat:@"%@/device/%@", @"http://pi.jeremydyer.me", [NSNumber numberWithInt:[[jsonDeviceValue objectForKey:@"device_id"] intValue]]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager PUT:string parameters:jsonDeviceValue success:^(AFHTTPRequestOperation *operation, id JSON) {
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

- (void) deleteDeviceWithID:(NSInteger)deviceId
                    success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString *string = [NSString stringWithFormat:@"%@/device/%ld", @"http://pi.jeremydyer.me", (long)deviceId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager DELETE:string parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}


- (void) addOutletWithJSON:(NSDictionary *)jsonOutletValue
                   success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString *string = [NSString stringWithFormat:@"%@/outlet", @"http://pi.jeremydyer.me"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:string parameters:jsonOutletValue success:^(AFHTTPRequestOperation *operation, id JSON) {
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}


- (void) updateOutletWithJSON:(NSDictionary *)jsonOutletValue
                   success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString *string = [NSString stringWithFormat:@"%@/outlet/%@", @"http://pi.jeremydyer.me", [NSNumber numberWithInt:[[jsonOutletValue objectForKey:@"outlet_id"] intValue]]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager PUT:string parameters:jsonOutletValue success:^(AFHTTPRequestOperation *operation, id JSON) {
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}


- (void) deleteOutletWithID:(NSInteger)outletId
                    success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    
    NSString *string = [NSString stringWithFormat:@"%@/outlet/%ld", @"http://pi.jeremydyer.me", (long)outletId];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager DELETE:string parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        success(operation, JSON);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

@end
