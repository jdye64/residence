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
    }
    return self;
}

@end
