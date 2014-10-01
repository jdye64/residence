//
//  WAMPResidenceService.h
//  Residence
//
//  Created by Jeremy Dyer on 10/1/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MDWamp/MDWamp.h>
#import "RPi.h"

#define RPI_JOINED_NOTIFICATION @"com.jeremydyer.residence.rpi.join.notify"

@interface WAMPResidenceService : NSObject<MDWampClientDelegate>

@property(nonatomic, strong) NSMutableArray *rpiDevices;

+ (WAMPResidenceService *)sharedInstance;

-(void)disconnectWAMPSession;

@end
