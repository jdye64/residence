//
//  Location.h
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (assign) NSInteger locationId;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *externalIP;

//A Location will contain a list of Device object.
@property (nonatomic, strong) NSArray *locationDevices;

-(id)initWithJSON:(NSDictionary *)json;

@end
