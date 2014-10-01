//
//  LocationEditController.h
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@interface LocationEditController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *locDescText;
@property (weak, nonatomic) IBOutlet UITextField *externalIPText;
@property (weak, nonatomic) IBOutlet UIButton *saveLocationBtn;

- (id)initWithLocation:(Location *)location;

- (IBAction)saveLocation:(id)sender;

@end
