//
//  Channel.h
//  Dyer
//
//  Created by Jeremy Dyer on 7/12/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

@property (nonatomic, strong) NSNumber *channel;
@property (nonatomic, strong) NSNumber *gpioValue;
@property (nonatomic, strong) NSString *gpioURI;

@end
