//
//  RPi.h
//  Residence
//
//  Created by Jeremy Dyer on 10/1/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Outlet.h"

@interface RPi : NSObject

@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) NSString *ip;
@property(nonatomic, strong) NSString *eth0_mac;
@property(nonatomic, strong) NSString *pyObject;
@property(nonatomic, strong) NSString *secretKey;
@property(nonatomic, strong) NSString *turnOffOutletRPC;
@property(nonatomic, strong) NSString *turnOnOutletRPC;
@property(nonatomic, strong) NSString *updateDeviceRPC;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *state;
@property(nonatomic, assign) NSInteger zip;
@property(nonatomic, strong) NSString *address1;
@property(nonatomic, strong) NSString *address2;
@property(nonatomic, strong) NSString *location_name;
@property(nonatomic, strong) NSString *room_name;

@property(nonatomic, strong) NSMutableArray *outlets;

-(id)initWithJSON:(NSDictionary *)jsonData;
-(NSString *)toJson;

@end
