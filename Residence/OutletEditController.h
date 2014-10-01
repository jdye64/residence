//
//  OutletEditController.h
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "Outlet.h"

@interface OutletEditController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

-(id)initWithDevice:(Device *)outletDevice existingOutlet:(Outlet *)outlet;

@property (weak, nonatomic) IBOutlet UIButton *outletSaveBtn;
@property (weak, nonatomic) IBOutlet UITextField *outletDescriptionText;
@property (weak, nonatomic) IBOutlet UICollectionView *gpioDeviceOutletCollection;


- (IBAction)saveOutlet:(id)sender;

@end
