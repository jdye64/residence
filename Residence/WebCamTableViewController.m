//
//  WebCamTableViewController.m
//  Residence
//
//  Created by Jeremy Dyer on 10/7/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "WebCamTableViewController.h"

@implementation WebCamTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"WebCamTableViewController has loaded!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WebCamCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WebCamCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = @"WebCam Cell";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row at %lu", indexPath.row);
}

@end