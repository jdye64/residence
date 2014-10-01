//
//  Location.m
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "Location.h"

@implementation Location

-(id)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.locationId = (NSInteger)[[json objectForKey:@"loc_id"] intValue];
        self.desc = [json objectForKey:@"desc"];
        self.externalIP = [json objectForKey:@"ex_ip"];
    }
    return self;
}

@end
