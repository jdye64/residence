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
        MDWampTransportWebSocket *websocket = [[MDWampTransportWebSocket alloc] initWithServer:[NSURL URLWithString:@"ws://127.0.0.1:8080/ws"] protocolVersions:@[kMDWampProtocolWamp2msgpack, kMDWampProtocolWamp2json]];
        
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

// Called when client has connected to the server
- (void) mdwamp:(MDWamp*)wamp sessionEstablished:(NSDictionary*)info {
    
    //Gets the list of devices from the session
    [wamp call:@"com.jeremydyer.residence.rpi.list" args:nil kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
        if (error == nil) {
            NSData *jsonData = [result.result dataUsingEncoding:NSUTF8StringEncoding];
            NSArray* jsonArray = [NSJSONSerialization
                                  JSONObjectWithData:jsonData
                                  options:kNilOptions
                                  error:&error];
            
            for (int i = 0; i < [jsonArray count]; i++) {
                NSDictionary *json = (NSDictionary *) jsonArray[i];
                [self.rpiDevices addObject:[[RPi alloc] initWithJSON:json]];
            }
            
            NSLog(@"Number of RPi Devices received %lu", [self.rpiDevices count]);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATED" object:nil];
            
        } else {
            // handle the error
            NSLog(@"ERROR: %@", error);
        }
    }];
    
//    [self.wamp subscribe:@"com.jeremydyer.gpio.rpi.join.notify" onEvent:^(MDWampEvent *payload) {
//        
//        // do something with the payload of the event
//        NSLog(@"received an event %@", payload.arguments);
//        
//    } result:^(NSError *error) {
//        NSLog(@"subscribe ok? %@", (error==nil)?@"YES":@"NO");
//        
//        [wamp call:@"com.jeremydyer.gpio.turnon" args:nil kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
//            if (error== nil) {
//                // do something with result object
//                NSLog(@"RPi GPIO outlet has been turned on");
//            } else {
//                // handle the error
//                NSLog(@"ERROR: %@", error);
//            }
//        }];
//        
//        [wamp call:@"com.jeremydyer.gpio.turnoff" args:nil kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
//            if (error== nil) {
//                // do something with result object
//                NSLog(@"RPi GPIO outlet has been turned off");
//            } else {
//                // handle the error
//                NSLog(@"ERROR: %@", error);
//            }
//        }];
//    }];
//    
//    
//    [self.wamp subscribe:@"com.jeremydyer.gpio.rpi.turnon.notify" onEvent:^(MDWampEvent *payload) {
//        NSLog(@"Notification that RPi GPIO outlet has been turned ON %@", payload.arguments);
//    } result:^(NSError *error) {
//        NSLog(@"subscribe ok? %@", (error==nil)?@"YES":@"NO");
//    }];
//    
//    [self.wamp subscribe:@"com.jeremydyer.gpio.rpi.turnoff.notify" onEvent:^(MDWampEvent *payload) {
//        NSLog(@"Notification that RPi GPIO outlet has been turned OFF %@", payload.arguments);
//    } result:^(NSError *error) {
//        NSLog(@"subscribe ok? %@", (error==nil)?@"YES":@"NO");
//    }];
//    
//    [self.wamp subscribe:@"com.jeremydyer.gpio.rpi.disconnect.notify" onEvent:^(MDWampEvent *payload) {
//        NSLog(@"RPi device has left the session %@", payload.arguments);
//    } result:^(NSError *error) {
//        NSLog(@"subscribe ok? %@", (error==nil)?@"YES":@"NO");
//    }];
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
