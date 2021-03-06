//
//  RPiDevicesTableViewController.m
//  Residence
//
//  Created by Jeremy Dyer on 10/1/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "RPiDevicesTableViewController.h"

@interface RPiDevicesTableViewController ()

@property(nonatomic, strong) NSIndexPath *lastSelectedIndex;

@end

@implementation RPiDevicesTableViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rpiJoinedSession:)
                                                 name:RPI_JOINED_NOTIFICATION
                                               object:nil];
}

- (void)dataSourceUpdated:(NSNotification *) notification {
    [self.tableView reloadData];
}

- (void)rpiJoinedSession:(NSNotification *) notification {
    NSLog(@"New RPI joined the session %@", notification.object);
    MDWampEvent *event = (MDWampEvent *) notification.object;
    NSLog(@"Argument 1 %@", event.arguments[0]);
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
    return [[[WAMPResidenceService sharedInstance] rpiDevices] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DeviceCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    RPi *rpi = [[[WAMPResidenceService sharedInstance] rpiDevices] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [[rpi.location_name stringByAppendingString:@" - "] stringByAppendingString:rpi.room_name];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row at %lu", (long)indexPath.row);
    self.lastSelectedIndex = indexPath;
    [self performSegueWithIdentifier:@"showDeviceDetailsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showDeviceDetailsSegue"])
    {
        // Get reference to the destination view controller
        DeviceOutletTableViewController *vc = [segue destinationViewController];
        NSLog(@"Selected index at %ld", (long)self.lastSelectedIndex.row);
        
        vc.indexToDisplay = self.lastSelectedIndex;
    }
}

@end
