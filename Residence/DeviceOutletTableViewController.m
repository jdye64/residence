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
    
    NSLog(@"RPi devices available %d", [[WAMPResidenceService sharedInstance].rpiDevices count]);
    NSLog(@"Loading RPi at index %@", self.indexToDisplay);
    self.rpi = [[WAMPResidenceService sharedInstance].rpiDevices objectAtIndex:self.indexToDisplay.row];
}

- (void)dataSourceUpdated:(NSNotification *) notification {
    NSLog(@"RPi devices available %d", [[WAMPResidenceService sharedInstance].rpiDevices count]);
    NSLog(@"Loading RPi at index %@", self.indexToDisplay);
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
    
    NSLog(@"Outlet On Value %d", outlet.on);
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
    NSLog(@"On was %d", outlet.on);
    outlet.on = !outlet.on;
    
    //Either turns on or off the outlet.
    if (outlet.on) {
        [[WAMPResidenceService sharedInstance] turnOnOutlet:outlet forRPi:self.rpi];
    } else {
        [[WAMPResidenceService sharedInstance] turnOffOutlet:outlet forRPi:self.rpi];
    }
    
    [self.rpi.outlets replaceObjectAtIndex:indexPath.row withObject:outlet];
    NSLog(@"On Now is %d", outlet.on);
    
    [[WAMPResidenceService sharedInstance] updateRPiDevice:self.rpi];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
