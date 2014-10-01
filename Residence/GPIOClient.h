//
//  GPIOClient.h
//  Dyer
//
//  Created by Jeremy Dyer on 5/23/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "Device.h"
#import "Outlet.h"

@interface GPIOClient : NSObject

+ (instancetype) sharedInstance;

- (void) loadGPIOLocationsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) loadDevicesForLocation:(NSInteger) locationid
                        success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) loadOutletsForDevice:(NSInteger) deviceId
                      success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) switchOutlet:(Outlet *)outlet
          forDeviceId:(NSInteger)deviceId
               turnOn:(BOOL)turnOn
              success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) addLocationWithJSON:(NSDictionary *)jsonLocationValue
                     success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) updateLocationWithJSON:(NSDictionary *)jsonLocationValue
                     success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) deleteLocationWithID:(NSInteger)locationId
                     success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) addDeviceWithJSON:(NSDictionary *)jsonDeviceValue
                     success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) updateDeviceWithJSON:(NSDictionary *)jsonDeviceValue
                      success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) deleteDeviceWithID:(NSInteger)DeviceId
                      success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) addOutletWithJSON:(NSDictionary *)jsonOutletValue
                   success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) updateOutletWithJSON:(NSDictionary *)jsonOutletValue
                   success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void) deleteOutletWithID:(NSInteger)outletId
                    success:(void (^)(AFHTTPRequestOperation *operation, id JSON)) success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

@end
