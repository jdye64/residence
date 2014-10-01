//
//  GPIO.h
//  Dyer
//
//  Created by Jeremy Dyer on 7/12/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channel.h"

@interface GPIO : NSObject

@property (nonatomic, strong) NSNumber *gpioMode;
@property (nonatomic, strong) NSNumber *gpioOffValue;
@property (nonatomic, strong) NSNumber *gpioOnValue;
@property (nonatomic, strong) NSString *gpioRPIVersion;
@property (nonatomic, strong) NSString *piVersion;

@property (nonatomic, strong) NSArray *channels;

@end
