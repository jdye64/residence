//
//  Device.m
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "Device.h"

@implementation Device

- (id)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        self.deviceId = (NSInteger)[[json objectForKey:@"dev_id"] intValue];
        self.desc = [json objectForKey:@"desc"];
        self.locationId = (NSInteger)[[json objectForKey:@"loc_id"] intValue];
        self.deviceUrl = [json objectForKey:@"dev_url"];
    }
    return self;
}

- (NSString *)deviceUrl {
    if ([_deviceUrl hasPrefix:@"http"]) {
        return _deviceUrl;
    } else {
        return [@"http://" stringByAppendingString:_deviceUrl];
    }
}

@end
