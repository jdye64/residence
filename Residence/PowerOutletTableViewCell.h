//
//  PowerOutletTableViewCell.h
//  Dyer
//
//  Created by Jeremy Dyer on 6/28/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerOutletTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *outletImage;
@property (strong, nonatomic) IBOutlet UISwitch *outletOnOffSwitch;
@property (weak, nonatomic) IBOutlet UILabel *outletDescription;

@end
