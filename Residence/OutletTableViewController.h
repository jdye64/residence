//
//  OutletTableViewController.h
//  Dyer
//
//  Created by Jeremy Dyer on 5/5/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPIOClient.h"
#import "PowerOutletTableViewCell.h"
#import "EditableTableViewController.h"

@interface OutletTableViewController : EditableTableViewController <EditableTableViewProtocol>

- (id) initWithDeviceId:(NSInteger)deviceId;

@end
