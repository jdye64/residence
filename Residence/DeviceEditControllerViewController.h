//
//  DeviceEditControllerViewController.h
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "Device.h"

@interface DeviceEditControllerViewController : UIViewController

- (id)initWithLocation:(Location *)deviceLocation;

- (id)initWithLocation:(Location *)location
             andDevice:(Device *)device;

@property (weak, nonatomic) IBOutlet UIButton *deviceSaveBtn;
@property (weak, nonatomic) IBOutlet UITextField *deviceDescriptionText;
@property (weak, nonatomic) IBOutlet UITextField *deviceUrlText;

- (IBAction)deviceSaveBtn:(id)sender;

@end
