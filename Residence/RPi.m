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
                           @"py/object": self.pyObject,
                           @"secretKey": self.secretKey,
                           @"turnOffOutletRPC": self.turnOffOutletRPC,
                           @"turnOnOutletRPC": self.turnOnOutletRPC,
                           @"updateDeviceRPC": self.updateDeviceRPC,
                           @"outlets": outletJson
                           };
    
    NSError *writeError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:&writeError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end
