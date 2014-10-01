//
//  EditableTableViewController.h
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EditableTableViewProtocol <NSObject>

@required
- (IBAction)addRow:(id)sender;

@end

@interface EditableTableViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIButton *editModeButton;
@property (nonatomic, strong) IBOutlet UIButton *addRowButton;

- (IBAction)toggleEdit:(id)sender;

@end
