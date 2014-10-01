//
//  PowerOutletTableViewCell.m
//  Dyer
//
//  Created by Jeremy Dyer on 6/28/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "PowerOutletTableViewCell.h"

@implementation PowerOutletTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.outletOnOffSwitch addTarget:self action:@selector(onOffSwitched:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)onOffSwitched:(id)sender {
    NSLog(@"switched!");
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
