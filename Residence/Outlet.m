//
//  Outlet.m
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "Outlet.h"

@implementation Outlet

-(id)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.outletId = (NSInteger)[[json objectForKey:@"out_id"] intValue];
        self.deviceId = (NSInteger)[[json objectForKey:@"dev_id"] intValue];
        self.gpioPort = (NSInteger)[[json objectForKey:@"gpio_port"] intValue];
        self.desc = [json objectForKey:@"desc"];
    }
    return self;
}

@end
