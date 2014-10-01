//
//  OutletTableViewController.m
//  Dyer
//
//  Created by Jeremy Dyer on 5/5/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "OutletTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "PowerOutletTableViewCell.h"
#import "OutletEditController.h"
#import "GPIOStore.h"

@interface OutletTableViewController ()

@property (nonatomic, assign) NSInteger deviceId;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation OutletTableViewController

static NSString *CellIdentifier = @"PowerOutletCell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithDeviceId:(NSInteger)deviceId
{
    self = [super init];
    if (self) {
        self.deviceId = deviceId;
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
    
    [[GPIOClient sharedInstance] loadOutletsForDevice:self.deviceId
                                             success:^(AFHTTPRequestOperation *operation, id JSON) {
                                                 [self.activityIndicatorView stopAnimating];
                                                 [self.tableView setHidden:NO];
    
                                                 self.title = @"Outlets";
                                                 [self.tableView reloadData];
    
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Device Outlets"
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
    if (![[GPIOStore sharedInstance] outlets]) {
        return 0;
    } else {
        return [[[GPIOStore sharedInstance] outlets] count];
    }
}

- (IBAction)addRow:(id)sender {
    
    //Gets the existing Device from the store.
    Device *existingDevice = [[GPIOStore sharedInstance] deviceWithId:self.deviceId];
    
    OutletEditController *outletEditController = [[OutletEditController alloc] initWithDevice:existingDevice existingOutlet:nil];
    [self.navigationController pushViewController:outletEditController animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //For Outlet we only pay attention to this events when they are being edited
    if (self.isEditing) {
        Device *outletDevice = [[GPIOStore sharedInstance] deviceWithId:self.deviceId];
        Outlet *existingOutlet = [[GPIOStore sharedInstance] outlets][indexPath.row];
        OutletEditController *outletEditController = [[OutletEditController alloc] initWithDevice:outletDevice existingOutlet:existingOutlet];
        [self.navigationController pushViewController:outletEditController animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PowerOutletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"PowerOutletTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    //Set the values for the PowerOutletTableViewCell
    Outlet *outlet = [[GPIOStore sharedInstance] outlets][indexPath.row];
    NSString *notFoundImage = [[NSBundle mainBundle] pathForResource:@"notfound" ofType:@"png"];
    
    cell.outletImage.backgroundColor = [UIColor blackColor];
    cell.outletImage.clipsToBounds = YES;
    cell.outletImage.image = [UIImage imageWithContentsOfFile:notFoundImage];
    
    cell.outletDescription.text = [outlet desc];
    [cell.outletOnOffSwitch addTarget:self action:@selector(onOffSwitched:) forControlEvents:UIControlEventValueChanged];
    
    return cell;
    
}

- (void)onOffSwitched:(id)sender {
    UISwitch *switchInCell = (UISwitch *)sender;    
    CGPoint switchPositionPoint = [sender convertPoint:CGPointZero toView:[self tableView]];
    NSIndexPath *indexPath = [[self tableView] indexPathForRowAtPoint:switchPositionPoint];
    
    Outlet *outlet = [[GPIOStore sharedInstance] outlets][indexPath.row];
    
    if (switchInCell.on) {
        [self turnOnOutlet:outlet];
    } else {
        [self turnOffOutlet:outlet];
    }
}


- (void)turnOnOutlet:(Outlet *)outlet {
    
    [[GPIOClient sharedInstance] switchOutlet:outlet
                                  forDeviceId:self.deviceId
                                       turnOn:YES
                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                          NSLog(@"Started from the bottom now we here!");
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"Operation has failed ...");
                                      }];
    
}

- (void)turnOffOutlet:(Outlet *)outlet {
    
    [[GPIOClient sharedInstance] switchOutlet:outlet
                                  forDeviceId:self.deviceId
                                       turnOn:NO
                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                          NSLog(@"Started from the bottom now we here!");
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"Operation has failed ...");
                                      }];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[GPIOStore sharedInstance] deleteOutletAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

@end
