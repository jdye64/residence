//
//  DeviceOutletTableViewController.m
//  Residence
//
//  Created by Jeremy Dyer on 10/1/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "DeviceOutletTableViewController.h"

@interface DeviceOutletTableViewController ()

@property(nonatomic, strong) RPi *rpi;

@end

@implementation DeviceOutletTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataSourceUpdated:)
                                                 name:@"UPDATED"
                                               object:nil];
    
    self.rpi = [[WAMPResidenceService sharedInstance].rpiDevices objectAtIndex:self.indexToDisplay.row];
}

- (void)dataSourceUpdated:(NSNotification *) notification {
    self.rpi = [[WAMPResidenceService sharedInstance].rpiDevices objectAtIndex:self.indexToDisplay.row];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rpi.outlets count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OutletCell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OutletCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Outlet *outlet = self.rpi.outlets[indexPath.row];
    if (outlet.on == 1) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor greenColor];
    }
    
    NSString *onOff = outlet.on == 0 ? @" - Off" : @" - On";
    cell.textLabel.text = [outlet.outletDescription stringByAppendingString:onOff];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Outlet *outlet = self.rpi.outlets[indexPath.row];
    
    //Toggles the on/off value
    outlet.on = !outlet.on;
    
    //Either turns on or off the outlet.
    if (outlet.on) {
        [[WAMPResidenceService sharedInstance] turnOnOutlet:outlet forRPi:self.rpi];
    } else {
        [[WAMPResidenceService sharedInstance] turnOffOutlet:outlet forRPi:self.rpi];
    }
    
    [self.rpi.outlets replaceObjectAtIndex:indexPath.row withObject:outlet];
    
    [[WAMPResidenceService sharedInstance] updateRPiDevice:self.rpi];
}

@end
