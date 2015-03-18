//
//  EditItemController.m
//  kerenm_CoreDataHomework
//
//  Created by Man, Keren on 3/16/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import "EditItemController.h"
#import "Item.h"
#import "Image.h"
#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface EditItemController ()
@property (weak) IBOutlet NSButton *btnAdd;
//@property (weak) IBOutlet NSTextField *txtItemDescription;
//@property (weak) IBOutlet NSTextField *txtTag;
//@property (weak) IBOutlet NSTextField *txtLocation;
//@property (weak) IBOutlet NSTextField *txtImage1;
//@property (weak) IBOutlet NSTextField *txtImage3;
//@property (weak) IBOutlet NSTextField *txtImage2;
@property NSURL *imageDirectory;
@end

@implementation EditItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //setup image directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths objectAtIndex:0];
    NSURL *applicationUrl = [NSURL fileURLWithPath: applicationSupportDirectory isDirectory: YES];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", _appIdentifier, @"images"];
    _imageDirectory = [applicationUrl URLByAppendingPathComponent:imagePath];
    NSError * error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:[_imageDirectory path]
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    if (error != nil) {
        NSLog(@"error creating image directory: %@", error);
    }
    
    //populate fields if model is populated
    if(_item != nil){
        self.moc = _item.managedObjectContext;
        self.txtItemDescription.stringValue = _item.title;
        NSSet *set=[_item itemToImage];
        NSArray *imageArray = [set allObjects];
        if(imageArray.count > 0){
            Image *image = [imageArray objectAtIndex:0];
            self.txtImage1.stringValue= image.imageUrl;
            //NSURL *imageUrl = [NSURL fileURLWithPath:image.imageUrl];
            NSImage * aImage = [[NSImage alloc] initWithContentsOfFile:image.imageUrl];
            [self.imageView1 setImage:aImage];
            image = [imageArray objectAtIndex:1];
            self.txtImage2.stringValue= image.imageUrl;
            aImage = [[NSImage alloc] initWithContentsOfFile:image.imageUrl];
            [self.imageView2 setImage:aImage];

        }
    }
    else
    {
        _item = [Item createInMoc: _moc];
    }
    
    [self getCoordinates];
    [self getCity];

}
- (IBAction)btnBrowse_clicked:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    NSArray* fileTypes = [[NSArray alloc] initWithObjects:@"png", @"jpg", nil];
    [op setAllowedFileTypes:fileTypes];
    op.directoryURL = [NSURL fileURLWithPath:@"~/Desktop".stringByExpandingTildeInPath];
    
    [op beginWithCompletionHandler:^(NSInteger result) {
        //execute after user makes choice
        NSLog(@"User finished choosing");
        NSLog(@"user got: %@", op.URLs);
        if([[sender identifier] isEqualToString: @"image1"]){
            self.txtImage1.stringValue = [op.URL path];
            NSImage * aImage = [[NSImage alloc] initWithContentsOfFile:[op.URL path]];
            [self.imageView1 setImage:aImage];
        }
        else if([[sender identifier] isEqualToString: @"image2"]){
            self.txtImage2.stringValue = [op.URL path];
            NSImage * aImage = [[NSImage alloc] initWithContentsOfFile:[op.URL path]];
            [self.imageView2 setImage:aImage];
        }
        
    }];
}

- (IBAction)btnSubmit_clicked:(id)sender {
    _item.title  = self.txtItemDescription.stringValue;
    _item.uuid = [[NSUUID UUID] UUIDString];
    _item.datePosted  = [NSDate date];
    
    //save image
    [self saveImage:self.txtImage1.stringValue parentItem:_item imageFileName: [NSString stringWithFormat:@"%@%@", _item.uuid, @"_1"]];
    [self saveImage:self.txtImage2.stringValue parentItem:_item imageFileName: [NSString stringWithFormat:@"%@%@", _item.uuid, @"_2"]];
    
    NSError *saveError = nil;
    BOOL success = [_moc save:&saveError];
    if(!success){
        [[NSApplication sharedApplication]  presentError:saveError];
    }
    
    [self.parentVC refreshTable];
    [self dismissController:self];
}

- (void) saveImage:(NSString*)sourcePath parentItem:(Item*)item imageFileName:(NSString*)fileName{
    NSError *err = nil;
    NSURL *destinationPath = nil;
    
    if(![sourcePath  isEqual: @""])
    {
        //fileName =[sourcePath lastPathComponent];
        destinationPath =  [_imageDirectory URLByAppendingPathComponent: fileName];
        [[NSFileManager defaultManager] copyItemAtURL: [NSURL fileURLWithPath:sourcePath isDirectory:NO]
                                                toURL:destinationPath
                                                error: &err];
        Image *image = [Image createInMoc: _moc];
        image.imageUrl = [destinationPath path];
        image.imageToItem  =item;
    }
    
}

-(void)getCoordinates{
    CLGeocoder* gc = [[CLGeocoder alloc] init];
    [gc geocodeAddressString:@"seattle" completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if ([placemarks count]>0)
        {
            // get the first one
            CLPlacemark* mark = (CLPlacemark*)[placemarks objectAtIndex:0];
            double lat = mark.location.coordinate.latitude;
            double lng = mark.location.coordinate.longitude;
            NSString *longString = [[NSNumber numberWithDouble:lng] stringValue];
            self.txtLocation.stringValue = [[[[NSNumber numberWithDouble:lat] stringValue] stringByAppendingString:@";"] stringByAppendingString:longString];
        }
    }];
}

-(void)getCity{
    CLGeocoder* gc = [[CLGeocoder alloc] init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:47.6062095 longitude:-122.3320708];
    [gc reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks,
                                                             NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSString *locality = [placemark locality];
            NSString * name =    [placemark name];
            NSString  *country  = [placemark country];
            NSLog(@"placemark: %@", [placemark name]);
            
//            m_locality = [placemark locality];
//            m_name =    [placemark name];
//            m_country  = [placemark country];
        }
    }];
}

@end
