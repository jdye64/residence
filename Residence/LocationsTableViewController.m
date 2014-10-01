//
//  LocationsTableViewController.m
//  Dyer
//
//  Created by Jeremy Dyer on 5/5/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "LocationsTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "DevicesTableViewController.h"
#import "Location.h"
#import "LocationEditController.h"
#import "GPIOStore.h"

@interface LocationsTableViewController ()

@property (nonatomic, retain) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation LocationsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    
    [[GPIOClient sharedInstance] loadGPIOLocationsWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
        
        [self.activityIndicatorView stopAnimating];
        [self.tableView setHidden:NO];
        
        self.navigationItem.title = @"Locations";
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load GPIO Locations");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addRow:(id)sender {
    
    //In order to really add a view we want to navigate to a new controller that allows the location to be properly created first.
    LocationEditController *locationEditController = [[LocationEditController alloc] init];
    [self.navigationController pushViewController:locationEditController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![[GPIOStore sharedInstance] locations]) {
        return 0;
    } else {
        return [[[GPIOStore sharedInstance] locations] count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location *loc = [[GPIOStore sharedInstance] locations][indexPath.row];
    NSInteger locationId = [loc locationId];
    
    //If in editing mode then display the Edit Location Controller
    if (self.isEditing) {
        LocationEditController *locationEditController = [[LocationEditController alloc] initWithLocation:loc];
        [self.navigationController pushViewController:locationEditController animated:YES];
    } else {
        DevicesTableViewController *deviceController = [[DevicesTableViewController alloc] initWithLocationId:locationId];
        [self.navigationController pushViewController:deviceController animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Location *location = [[GPIOStore sharedInstance] locations][indexPath.row];
    cell.textLabel.text = [location desc];
    cell.detailTextLabel.text = [location externalIP];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [[GPIOStore sharedInstance] deleteLocationAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
