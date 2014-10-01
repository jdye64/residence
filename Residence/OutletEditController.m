//
//  OutletEditController.m
//  Dyer
//
//  Created by Jeremy Dyer on 6/30/14.
//  Copyright (c) 2014 Jeremy Dyer. All rights reserved.
//

#import "OutletEditController.h"
#import "GPIOClient.h"
#import "GPIOStore.h"

@interface OutletEditController ()

@property (assign)BOOL editing;
@property (nonatomic, strong) Device *outletDevice;
@property (nonatomic, strong) Outlet *existingOutlet;

//Collection view properties.
@property (assign) CGFloat collectionHeight;
@property (assign) CGFloat collectionWidth;

@property (nonatomic, strong) NSMutableArray *deviceOutletsStatus;

@end

@implementation OutletEditController

NSArray *portsArray = nil;

-(id)initWithDevice:(Device *)outletDevice
     existingOutlet:(Outlet *)outlet {
    self = [super init];
    if (self) {
        self.outletDevice = outletDevice;
        if (outlet) {
            self.existingOutlet = outlet;
            self.editing = YES;
        } else {
            self.editing = NO;
        }
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.editing) {
        self.outletDescriptionText.text = self.existingOutlet.desc;
    }
    
    portsArray = @[@7, @11, @12, @13, @15, @16, @18, @22];
    
    [self.gpioDeviceOutletCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"FlickrCell"];
    
    self.collectionHeight = [self.gpioDeviceOutletCollection frame].size.height;
    self.collectionWidth = [self.gpioDeviceOutletCollection frame].size.width;
    
    self.deviceOutletsStatus = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)updateOutlet {
    NSDictionary *json = @{@"device_id" : [NSNumber numberWithInteger:self.outletDevice.deviceId], @"desc" : self.outletDescriptionText.text, @"gpio_port": [NSNumber numberWithInt:15], @"outlet_id": [NSNumber numberWithInteger:self.existingOutlet.outletId]};
    
    [[GPIOClient sharedInstance] updateOutletWithJSON:json success:^(AFHTTPRequestOperation *operation, id JSON) {
        Outlet *updatedOutlet = [[Outlet alloc] initWithJSON:JSON];
        [[GPIOStore sharedInstance] updateOutlet:updatedOutlet];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to update Outlet");
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


-(void)createOutlet {
    
    NSDictionary *json = @{@"device_id" : [NSNumber numberWithInteger:self.outletDevice.deviceId], @"desc" : self.outletDescriptionText.text, @"gpio_port": [NSNumber numberWithInt:15]};
    
    [[GPIOClient sharedInstance] addOutletWithJSON:json success:^(AFHTTPRequestOperation *operation, id JSON) {
        Outlet *newOutlet = [[Outlet alloc] initWithJSON:JSON];
        [[GPIOStore sharedInstance] addOutlet:newOutlet];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to create new Outlet");
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (IBAction)saveOutlet:(id)sender {
    if (self.editing) {
        [self updateOutlet];
    } else {
        [self createOutlet];
    }
}


#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 8;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"FlickrCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected item at index %@", indexPath);
    NSNumber *gpioOutlet = (NSNumber *)[portsArray objectAtIndex:[indexPath row]];
    NSLog(@"Setting Outlet GPIO port to %@", gpioOutlet);
    self.existingOutlet.gpioPort = [gpioOutlet integerValue];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(20, 20);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}


@end
