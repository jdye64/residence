//
//  RPi.m
//  Residence
//
//  Created by Jeremy Dyer on 10/1/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "RPi.h"

@implementation RPi

-(id)initWithJSON:(NSDictionary *)jsonData {
    self = [super init];
    if (self) {
        self.uid = [NSString stringWithFormat:@"%@", jsonData[@"uid"]];
        self.ip = jsonData[@"ip"];
        self.pyObject = jsonData[@"py/object"];
        self.secretKey = jsonData[@"secretKey"];
        self.turnOnOutletRPC = jsonData[@"turnOnOutletRPC"];
        self.turnOffOutletRPC = jsonData[@"turnOffOutletRPC"];
        self.updateDeviceRPC = jsonData[@"updateDeviceRPC"];
        self.city = jsonData[@"city"];
        self.state = jsonData[@"state"];
        NSLog(@"JSONData Zip: %@", jsonData[@"zip"]);
        self.zip = !jsonData[@"zip"] ? -1 : [jsonData[@"zip"] integerValue];
        self.address1 = jsonData[@"address1"];
        self.address2 = jsonData[@"address2"];
        self.location_name = jsonData[@"location_name"];
        self.room_name = jsonData[@"room_name"];
        self.eth0_mac = jsonData[@"eth0_mac"];
        
        self.outlets = [[NSMutableArray alloc] init];
        for (NSDictionary *json in jsonData[@"outlets"]) {
            //NSLog(@"JSON -> %@", json);
            Outlet *outlet = [[Outlet alloc] initWithJSON:json];
            [self.outlets addObject:outlet];
        }
        
        //NSLog(@"%lu outlets were added", (unsigned long)[self.outlets count]);
    }
    return self;
}

-(NSString *)toJson {
    
    NSMutableArray *outletJson = [[NSMutableArray alloc] init];
    for (Outlet *ot in self.outlets) {
        [outletJson addObject:[ot toJson]];
    }
    
    NSDictionary *json = @{
                           @"uid": [NSNumber numberWithInteger:[self.uid integerValue]],
                           @"ip": self.ip,
                           @"secretKey": self.secretKey,
                           @"turnOffOutletRPC": self.turnOffOutletRPC,
                           @"turnOnOutletRPC": self.turnOnOutletRPC,
                           @"updateDeviceRPC": self.updateDeviceRPC,
                           @"outlets": outletJson,
                           @"city": self.city,
                           @"state": self.state,
                           @"zip": [NSNumber numberWithInteger:self.zip],
                           @"address1": self.address1,
                           @"address2": self.address2,
                           @"location_name": self.location_name,
                           @"room_name": self.room_name,
                           @"eth0_mac": self.eth0_mac
                           };
    
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end
