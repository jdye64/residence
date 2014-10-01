//
//  Device.h
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "GPIO.h"

@interface Device : NSObject

@property (assign) NSInteger deviceId;
@property (nonatomic, strong) NSString *desc;
@property (assign) NSInteger locationId;
@property (nonatomic, strong) NSString *deviceUrl;
@property (nonatomic, strong) GPIO *deviceGpio;

-(id)initWithJSON:(NSDictionary *)json;

@end
