//
//  EditableTableViewController.m
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "EditableTableViewController.h"

@implementation EditableTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad {
    //Set up the header view.
    UIView *header = [self loadHeaderView];
    [self.tableView setTableHeaderView:header];
}

- (UIView *)loadHeaderView {
    if (!self.headerView) {
        self.headerView = [[NSBundle mainBundle] loadNibNamed:@"TableEditHeaderView" owner:self options:nil][0];
        
    }
    return self.headerView;
}

- (IBAction)toggleEdit:(id)sender {
    
    if (self.isEditing) {
        //Change the text of button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        //Turn off editing mode.
        [self setEditing:NO animated:YES];
    } else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        //Enter editing mode.
        [self setEditing:YES animated:YES];
    }
}

@end
