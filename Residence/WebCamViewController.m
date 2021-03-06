//
//  WebCamViewController.m
//  Residence
//
//  Created by Jeremy Dyer on 10/7/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "WebCamViewController.h"

@interface WebCamViewController()

@property(nonatomic, strong) MDWamp *wamp;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *coughBtn;
@property (weak, nonatomic) IBOutlet UIButton *randomBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;

@end

@implementation WebCamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"WebCamViewController has been loaded!");
    
    //Create the initial WAMP connection
    MDWampTransportWebSocket *websocket = [[MDWampTransportWebSocket alloc] initWithServer:[NSURL URLWithString:@"ws://pi.jeremydyer.me:9000/ws"] protocolVersions:@[kMDWampProtocolWamp2msgpack, kMDWampProtocolWamp2json]];
    
    self.wamp = [[MDWamp alloc] initWithTransport:websocket realm:@"realm1" delegate:self];
    
    [self.wamp connect];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


// Called when client has connected to the server
- (void) mdwamp:(MDWamp*)wamp sessionEstablished:(NSDictionary*)info {
    
//    //Gets the list of devices from the session
//    [wamp call:@"com.jeremydyer.residence.rpi.webcam.takesnapshot" args:nil kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
//        if (error == nil) {
//            NSDictionary *jsonDict = (NSDictionary *) result.result;
//            NSString *base64EncodedImage = jsonDict[@"image"];
//            
//            NSData *nsdataFromBase64String = [[NSData alloc]initWithBase64EncodedString:base64EncodedImage options:0];
//            UIImage *image = [[UIImage alloc] initWithData:nsdataFromBase64String];
//            self.imageView.image = image;
//        } else {
//            // handle the error
//            NSLog(@"ERROR: %@", error);
//        }
//    }];
    
//    NSArray *args = @[@{@"source_url": @"https://s3.amazonaws.com/makeandbuild/courier/audio/1.wav"}];
//    
//    //Gets the list of devices from the session
//    [wamp call:@"com.jeremydyer.residence.rpi.audio.play" args:args kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
//        if (error == nil) {
//            NSDictionary *jsonDict = (NSDictionary *) result.result;
//            NSString *base64EncodedImage = jsonDict[@"image"];
//            
//            NSData *nsdataFromBase64String = [[NSData alloc]initWithBase64EncodedString:base64EncodedImage options:0];
//            UIImage *image = [[UIImage alloc] initWithData:nsdataFromBase64String];
//            self.imageView.image = image;
//        } else {
//            // handle the error
//            NSLog(@"ERROR: %@", error);
//        }
//    }];
    
}

- (IBAction)play_cough:(id)sender {
    NSArray *args = @[@{@"source_url": @"https://s3.amazonaws.com/makeandbuild/courier/audio/1.wav"}];
    
    //Gets the list of devices from the session
    [self.wamp call:@"com.jeremydyer.residence.rpi.audio.play" args:args kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
        if (error == nil) {
//            NSDictionary *jsonDict = (NSDictionary *) result.result;
//            NSString *base64EncodedImage = jsonDict[@"image"];
//            
//            NSData *nsdataFromBase64String = [[NSData alloc]initWithBase64EncodedString:base64EncodedImage options:0];
//            UIImage *image = [[UIImage alloc] initWithData:nsdataFromBase64String];
//            self.imageView.image = image;
            NSLog(@"Finished!");
        } else {
            // handle the error
            NSLog(@"ERROR: %@", error);
        }
    }];
}

- (IBAction)play_random:(id)sender {
    NSArray *args = @[@{@"source_url": @"https://s3.amazonaws.com/makeandbuild/courier/audio/2.wav"}];
    
    //Gets the list of devices from the session
    [self.wamp call:@"com.jeremydyer.residence.rpi.audio.play" args:args kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
        if (error == nil) {
//            NSDictionary *jsonDict = (NSDictionary *) result.result;
//            NSString *base64EncodedImage = jsonDict[@"image"];
//            
//            NSData *nsdataFromBase64String = [[NSData alloc]initWithBase64EncodedString:base64EncodedImage options:0];
//            UIImage *image = [[UIImage alloc] initWithData:nsdataFromBase64String];
//            self.imageView.image = image;
            NSLog(@"Finished!");
        } else {
            // handle the error
            NSLog(@"ERROR: %@", error);
        }
    }];
}

- (IBAction)play_last:(id)sender {
    NSArray *args = @[@{@"source_url": @"https://s3.amazonaws.com/makeandbuild/courier/audio/3.wav"}];
    
    //Gets the list of devices from the session
    [self.wamp call:@"com.jeremydyer.residence.rpi.audio.play" args:args kwArgs:nil complete:^(MDWampResult *result, NSError *error) {
        if (error == nil) {
//            NSDictionary *jsonDict = (NSDictionary *) result.result;
//            NSString *base64EncodedImage = jsonDict[@"image"];
//            
//            NSData *nsdataFromBase64String = [[NSData alloc]initWithBase64EncodedString:base64EncodedImage options:0];
//            UIImage *image = [[UIImage alloc] initWithData:nsdataFromBase64String];
//            self.imageView.image = image;
            NSLog(@"Finished!");
        } else {
            // handle the error
            NSLog(@"ERROR: %@", error);
        }
    }];
}


// Called when client disconnect from the server
- (void) mdwamp:(MDWamp *)wamp closedSession:(NSInteger)code reason:(NSString*)reason details:(NSDictionary *)details {
    NSLog(@"ClosedSession");
}


@end
