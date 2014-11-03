//
//  Outlet.h
//  Residence
//
//  Created by Jeremy Dyer on 10/1/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Outlet : NSObject

@property(nonatomic, strong) NSString *pyObject;
@property(nonatomic, assign) int on;
@property(nonatomic, strong) NSString *outlet;
@property(nonatomic, strong) NSString *outletDescription;

-(id)initWithJSON:(NSDictionary *)jsonData;
-(NSDictionary *)toJson;

@end
