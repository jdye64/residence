//
//  DevicesTableViewController.m
//  Dyer
//
//  Created by Jeremy Dyer on 5/5/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "DevicesTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "OutletTableViewController.h"
#import "GPIOStore.h"
#import "DeviceEditControllerViewController.h"

@interface DevicesTableViewController ()

@property (nonatomic, assign) NSInteger locationId;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation DevicesTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithLocationId:(NSInteger) locationId
{
    self = [super init];
    if (self) {
        self.locationId = locationId;
        self.tableView.allowsSelectionDuringEditing = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Reload the table data
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setting Up Activity Indicator View
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicatorView.hidesWhenStopped = YES;
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    [self.activityIndicatorView startAnimating];
    
    
    [[GPIOClient sharedInstance] loadDevicesForLocation:self.locationId
                                                success:^(AFHTTPRequestOperation *operation, id JSON) {
                                                    
                                                    [self.activityIndicatorView stopAnimating];
                                                    [self.tableView setHidden:NO];
    
                                                    self.title = @"Devices";
                                                    [self.tableView reloadData];
    
                                                }
                                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Devices"
                                                                                                        message:[error localizedDescription]
                                                                                                       delegate:nil
                                                                                              cancelButtonTitle:@"Ok"
                                                                                              otherButtonTitles:nil];
                                                    [alertView show];
                                                }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![[GPIOStore sharedInstance] devices]) {
        return 0;
    } else {
        return [[[GPIOStore sharedInstance] devices] count];
    }
}

- (IBAction)addRow:(id)sender {
    
    //In order to really add a view we want to navigate to a new controller that allows the location to be properly created first.
    Location *deviceLocation = [[GPIOStore sharedInstance] locationWithId:self.locationId];
    DeviceEditControllerViewController *deviceEditController = [[DeviceEditControllerViewController alloc] initWithLocation:deviceLocation];
    [self.navigationController pushViewController:deviceEditController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Device *existingDevice = [[GPIOStore sharedInstance] devices][indexPath.row];
    NSInteger deviceId = [existingDevice deviceId];
    Location *deviceLocation = [[GPIOStore sharedInstance] locationWithId:self.locationId];
    
    //If in editing mode then display the Edit Location Controller
    if (self.isEditing) {
        DeviceEditControllerViewController *deviceEditController = [[DeviceEditControllerViewController alloc]
                                                                    initWithLocation:deviceLocation
                                                                    andDevice:existingDevice];
        [self.navigationController pushViewController:deviceEditController animated:YES];
    } else {
        OutletTableViewController *outletController = [[OutletTableViewController alloc] initWithDeviceId:deviceId];
        [self.navigationController pushViewController:outletController animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeviceCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Device *device = [[GPIOStore sharedInstance] devices][indexPath.row];
    cell.textLabel.text = [device desc];
    cell.detailTextLabel.text = [[NSNumber numberWithInteger:[device deviceId]] stringValue];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[GPIOStore sharedInstance] deleteDeviceAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

@end
