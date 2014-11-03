//
//  Outlet.m
//  Residence
//
//  Created by Jeremy Dyer on 10/1/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "Outlet.h"

@implementation Outlet

-(id)initWithJSON:(NSDictionary *)jsonData {
    self = [super init];
    if (self) {
        
        NSInteger on = [[jsonData objectForKey:@"on"] integerValue];
        bool onOff = [[jsonData objectForKey:@"on"] boolValue];
        
        //NSLog(@"JsonData Value %@, On Value %d onOff Bool Value %d", jsonData[@"on"], on, onOff);
        if (on == 0) {
            self.on = 0;
        } else {
            self.on = 1;
        }
        self.pyObject = jsonData[@"py/object"];
        self.outletDescription = jsonData[@"outletDescription"];
        self.outlet = jsonData[@"outlet"];
    }
    return self;
}

-(NSDictionary *)toJson {
//    NSDictionary *json = @{
//                           @"on": self.on ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0],
//                           @"portNumber": self.portNumber,
//                           @"outletDescription": self.outletDescription,
//                           @"py/object": self.pyObject
//                           };
    NSDictionary *json = @{
                           @"on": self.on ? [NSNumber numberWithInt:1] : [NSNumber numberWithInt:0],
                           @"outlet": self.outlet,
                           @"outletDescription": self.outletDescription
                           };
    return json;
}

@end
