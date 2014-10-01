//
//  DeviceEditControllerViewController.m
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "DeviceEditControllerViewController.h"
#import "Location.h"
#import "Device.h"
#import "GPIOClient.h"
#import "GPIOStore.h"

@interface DeviceEditControllerViewController ()

@property (assign)BOOL update;
@property (nonatomic, strong) Location *deviceLocation;
@property (nonatomic, strong) Device *existingDevice;

@end

@implementation DeviceEditControllerViewController

- (id)initWithLocation:(Location *)deviceLocation {
    self = [super init];
    if (self) {
        // Custom initialization
        self.deviceLocation = deviceLocation;
    }
    return self;
}

- (id)initWithLocation:(Location *)location
             andDevice:(Device *)device {
    self = [super init];
    if (self) {
        // Custom initialization
        self.update = YES;
        self.deviceLocation = location;
        self.existingDevice = device;
        
        self.deviceSaveBtn.titleLabel.text = @"Update";
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.update) {
        self.deviceDescriptionText.text = [self.existingDevice desc];
        self.deviceUrlText.text = [self.existingDevice deviceUrl];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateDevice {
    
    NSDictionary *json = @{@"location_id" : [NSNumber numberWithInteger:self.deviceLocation.locationId], @"desc" : self.deviceDescriptionText.text, @"device_id" : [NSNumber numberWithInteger:self.existingDevice.deviceId], @"device_url": self.deviceUrlText.text};
    
    [[GPIOClient sharedInstance] updateDeviceWithJSON:json success:^(AFHTTPRequestOperation *operation, id JSON) {
        Device *updatedDevice = [[Device alloc] initWithJSON:JSON];
        [[GPIOStore sharedInstance] updateDevice:updatedDevice];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED TO CREATE NEW DEVICE ...");
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


-(void)createDevice {
    
    NSDictionary *json = @{@"location_id" : [NSNumber numberWithInteger:self.deviceLocation.locationId], @"desc" : self.deviceDescriptionText.text, @"device_url": self.deviceUrlText.text};
    
    [[GPIOClient sharedInstance] addDeviceWithJSON:json success:^(AFHTTPRequestOperation *operation, id JSON) {
        Device *newDevice = [[Device alloc] initWithJSON:JSON];
        [[GPIOStore sharedInstance] addDevice:newDevice];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED TO CREATE NEW DEVICE ...");
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


- (IBAction)deviceSaveBtn:(id)sender {
    if (self.update) {
        [self updateDevice];
    } else {
        [self createDevice];
    }
}


@end
