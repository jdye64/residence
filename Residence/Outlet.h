//
//  Outlet.h
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

@interface Outlet : NSObject

@property (assign) NSInteger outletId;
@property (assign) NSInteger deviceId;
@property (nonatomic, strong) NSString *desc;
@property (assign) NSInteger gpioPort;

- (id)initWithJSON:(NSDictionary *)json;

@end
