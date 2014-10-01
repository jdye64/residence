//
//  RPi.h
//  Residence
//
//  Created by Jeremy Dyer on 10/1/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPi : NSObject

@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) NSString *ip;
@property(nonatomic, strong) NSString *pyObject;
@property(nonatomic, strong) NSString *secretKey;
@property(nonatomic, strong) NSString *turnOffOutletRPC;
@property(nonatomic, strong) NSString *turnOnOutletRPC;

-(id)initWithJSON:(NSDictionary *)jsonData;

@end
