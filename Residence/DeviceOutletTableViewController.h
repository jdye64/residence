//
//  DeviceOutletTableViewController.h
//  Residence
//
//  Created by Jeremy Dyer on 10/1/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPi.h"
#import "WAMPResidenceService.h"

@interface DeviceOutletTableViewController : UITableViewController

@property(nonatomic, strong) NSIndexPath *indexToDisplay;

@end
