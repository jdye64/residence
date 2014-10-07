//
//  WAMPResidenceService.m
//  Residence
//
//  Created by Jeremy Dyer on 10/1/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "WAMPResidenceService.h"

@interface WAMPResidenceService()

@property(nonatomic, strong) MDWamp *wamp;

@end

@implementation WAMPResidenceService

- (id) init {
    self = [super init];
    if (self) {
        
        self.rpiDevices = [[NSMutableArray alloc] init];
        
        //Create the initial WAMP connection
        MDWampTransportWebSocket *websocket = [[MDWampTransportWebSocket alloc] initWithServer:[NSURL URLWithString:@"ws://pi.jeremydyer.me:9000/ws"] protocolVersions:@[kMDWampProtocolWamp2msgpack, kMDWampProtocolWamp2json]];
        
        self.wamp = [[MDWamp alloc] initWithTransport:websocket realm:@"realm1" delegate:self];
        
        [self.wamp connect];
    }
    return self;
}

+ (WAMPResidenceService *)sharedInstance
{
    static WAMPResidenceService *sharedInstance = nil;
    static dispatch_once_t isDispatched;
    
    dispatch_once(&isDispatched, ^{
        sharedInstance = [[WAMPResidenceService alloc] init];
    });
    
    return sharedInstance;
}

- (void)notifyDataSourceUpdated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATED" object:nil];
}

- (NSArray *)jsonArrayFromString:(id) jsonString {
    NSError *error;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray* jsonArray = [NSJSONSerialization
                          JSONObjectWithData:jsonData
                          options:kNilOptions
                          error:&error];
    return jsonArray;
}

- (NSDictionary *)jsonDictionaryFromString:(id) jsonString {
    NSError *error;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* jsonDict = [NSJSONSerialization
                          JSONObjectWithData:jsonData
                          options:kNilOptions
                          error:&error];
    
    if (error) {
        NSLog(@"ERROR creating JSON from WAMP response %@", error.description);
    }
    return jsonDict;
}

- (void) removeRPiByUID:(NSString *) uid {
    for (int i = 0; i < [self.rpiDevices count]; i++) {
        RPi *rpi = self.rpiDevices[i];
        if ([rpi.uid isEqualToString:uid]) {
            [self.rpiDevices removeObjectAtIndex:i];
        }
    }
}

-(void)updateRPi:(RPi *)updatedRPi {
    for (int i = 0; i < [self.rpiDevices count]; i++) {
        RPi *rpi = self.rpiDevices[i];
        if ([updatedRPi.uid isEqualToString:rpi.uid]) {
            [self.rpiDevices replaceObjectAtIndex:i withObject:updatedRPi];
            //NSLog(@"Replaced RPi %i with updated RPi %d", rpi.on, updatedRPi.on);
        }
    }
}

// Called when client has connected to the server
- (void) mdwamp:(MDWamp*)wamp sessionEstablished:(NSDictionary*)info {
    
    //Gets the list of devices from the session
    [wamp call:@"com.jeremydyer.residence.rpi.list" args:nil kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
        if (error == nil) {
            NSArray* jsonArray = [self jsonArrayFromString:result.result];
            
            //NSLog(@"JSON Array %@", jsonArray);
            
            for (int i = 0; i < [jsonArray count]; i++) {
                NSDictionary *json = (NSDictionary *) jsonArray[i];
                [self.rpiDevices addObject:[[RPi alloc] initWithJSON:json]];
            }
            
            NSLog(@"Number of RPi Devices received %lu", (unsigned long)[self.rpiDevices count]);
            
            [self notifyDataSourceUpdated];
            
        } else {
            // handle the error
            NSLog(@"ERROR: %@", error);
        }
    }];
    
    //Registers to listen for new RPi devices that may join the session.
    [self.wamp subscribe:@"com.jeremydyer.residence.rpi.join.notify" onEvent:^(MDWampEvent *payload) {
        
        NSDictionary *jsonDict = [self jsonDictionaryFromString:payload.arguments[0]];
        [self.rpiDevices addObject:[[RPi alloc] initWithJSON:jsonDict]];
        [self notifyDataSourceUpdated];
        
    } result:^(NSError *error) {
        if (error != nil) {
            NSLog(@"ERROR Subscribing to event com.jeremydyer.residence.rpi.join.notify -> %@", error.description);
        }
    }];
    
    //Registers to listen for RPi devices that have went offline
    [self.wamp subscribe:@"com.jeremydyer.residence.rpi.offline" onEvent:^(MDWampEvent *payload) {
        NSLog(@"RPi device has went offline!!!");
        
        NSDictionary *jsonDict = [self jsonDictionaryFromString:payload.arguments[0]];
        RPi *rpi = [[RPi alloc] initWithJSON:jsonDict];
        [self removeRPiByUID:rpi.uid];
        [self notifyDataSourceUpdated];
        
        
    } result:^(NSError *error) {
        if (error != nil) {
            NSLog(@"ERROR Subscribing to 'com.jeremydyer.residence.rpi.offline' %@", error.description);
        }
    }];
    
    
    //Registers to listen for RPi device updates
    [self.wamp subscribe:@"com.jeremydyer.residence.rpi.update.notify" onEvent:^(MDWampEvent *payload) {
        NSLog(@"RPi device update notification has been received!");
        
        NSDictionary *jsonDict = [self jsonDictionaryFromString:payload.arguments[0]];
        RPi *updateRPi = [[RPi alloc] initWithJSON:jsonDict];
        [self updateRPi:updateRPi];
        [self notifyDataSourceUpdated];
        
    } result:^(NSError *error) {
        if (error != nil) {
            NSLog(@"ERROR Subscribing to 'com.jeremydyer.residence.rpi.offline' %@", error.description);
        }
    }];

}

- (void)updateRPiDevice:(RPi *)rpiDevice {
    
    NSArray *args = @[[rpiDevice toJson]];
    
    [self.wamp call:rpiDevice.updateDeviceRPC args:args kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
        if (error != nil) {
            NSLog(@"ERROR: %@", error);
        }
    }];
}

-(void)turnOnOutlet:(Outlet *)outlet forRPi:(RPi*) rpi {
    NSArray *args = @[outlet.portNumber];
    [self.wamp call:rpi.turnOnOutletRPC args:args kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
        if (error != nil) {
            NSLog(@"ERROR: %@", error);
        } else {
            NSLog(@"Outlet should be turned on now!");
        }
    }];
}

-(void)turnOffOutlet:(Outlet *)outlet forRPi:(RPi*) rpi {
    NSArray *args = @[outlet.portNumber];
    [self.wamp call:rpi.turnOffOutletRPC args:args kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
        if (error != nil) {
            NSLog(@"ERROR: %@", error);
        } else {
            NSLog(@"Outlet should be turned OFF now!");
        }
    }];
}


// Called when client disconnect from the server
- (void) mdwamp:(MDWamp *)wamp closedSession:(NSInteger)code reason:(NSString*)reason details:(NSDictionary *)details {
    NSLog(@"ClosedSession");
}

-(void)disconnectWAMPSession {
    NSLog(@"Disconnecting form WAMP session");
    [self.wamp disconnect];
}

@end
