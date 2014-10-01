//
//  LocationEditController.m
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "LocationEditController.h"
#import "GPIOClient.h"
#import "Location.h"
#import "GPIOStore.h"

@interface LocationEditController ()

@property (assign)BOOL update;
@property (nonatomic, strong) Location *location;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation LocationEditController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        self.update = NO;
    }
    return self;
}

- (id)initWithLocation:(Location *)location {
    self = [super init];
    if (self) {
        // Custom initialization
        self.location = location;
        self.update = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Prepares the view with the Location information.
    if (self.location) {
        self.externalIPText.text = [self.location externalIP];
        self.locDescText.text = [self.location desc];
    }
    
    if (self.update) {
        self.saveLocationBtn.titleLabel.text = @"Update";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveLocation:(id)sender {
    
    if (self.update) {
        //Generate the JSON expected by the GPIO Master server.
        NSDictionary *json = @{@"desc" : self.locDescText.text, @"external_ip": self.externalIPText.text, @"location_id" : [NSNumber numberWithInteger:self.location.locationId]};
        
        // Setting Up Activity Indicator View
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicatorView.hidesWhenStopped = YES;
        self.activityIndicatorView.center = self.view.center;
        [self.view addSubview:self.activityIndicatorView];
        [self.activityIndicatorView startAnimating];
        
        [[GPIOClient sharedInstance] updateLocationWithJSON:json success:^(AFHTTPRequestOperation *operation, id JSON) {
            
            [self.activityIndicatorView stopAnimating];
            Location *updatedLocation = [[Location alloc] initWithJSON:JSON];
            
            [[GPIOStore sharedInstance] updateLocation:updatedLocation];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.activityIndicatorView stopAnimating];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Adding Location"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        //Generate the JSON expected by the GPIO Master server.
        NSDictionary *json = @{@"desc" : self.locDescText.text, @"external_ip": self.externalIPText.text};
        
        // Setting Up Activity Indicator View
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicatorView.hidesWhenStopped = YES;
        self.activityIndicatorView.center = self.view.center;
        [self.view addSubview:self.activityIndicatorView];
        [self.activityIndicatorView startAnimating];
        
        [[GPIOClient sharedInstance] addLocationWithJSON:json success:^(AFHTTPRequestOperation *operation, id JSON) {
            
            [self.activityIndicatorView stopAnimating];
            Location *newLocation = [[Location alloc] initWithJSON:JSON];
            [[GPIOStore sharedInstance] addLocation:newLocation];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.activityIndicatorView stopAnimating];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Adding Location"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
@end
