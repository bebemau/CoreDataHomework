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

@interface EditItemController ()
@property (weak) IBOutlet NSButton *btnAdd;
@property (weak) IBOutlet NSTextField *txtItemDescription;
@property (weak) IBOutlet NSTextField *txtTag;
@property (weak) IBOutlet NSTextField *txtLocation;
@property (weak) IBOutlet NSTextField *txtImage1;
@property (weak) IBOutlet NSTextField *txtImage3;
@property (weak) IBOutlet NSTextField *txtImage2;
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
        }
        else if([[sender identifier] isEqualToString: @"image2"]){
            self.txtImage2.stringValue = [op.URL path];
        }
        else if([[sender identifier] isEqualToString: @"image3"]){
            self.txtImage3.stringValue = [op.URL path];
        }
        
    }];
}

- (IBAction)btnSubmit_clicked:(id)sender {
    Item *item = [Item createInMoc: _moc];
    item.title  = self.txtItemDescription.stringValue;
    item.uuid = [[NSUUID UUID] UUIDString];
    item.datePosted  = [NSDate date];
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    //    NSDate *datePosted = [dateFormatter dateFromString:self.txtDatePosted.stringValue];
    
    //save image
    [self saveImage:self.txtImage1.stringValue parentItem:item imageFileName: [NSString stringWithFormat:@"%@%@", item.uuid, @"_1"]];
    [self saveImage:self.txtImage2.stringValue parentItem:item imageFileName: [NSString stringWithFormat:@"%@%@", item.uuid, @"_2"]];
    [self saveImage:self.txtImage3.stringValue parentItem:item imageFileName: [NSString stringWithFormat:@"%@%@", item.uuid, @"_3"]];
    
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
    }
    
    Image *image = [Image createInMoc: _moc];
    image.imageUrl = [destinationPath path];
    image.imageToItem  =item;
}

@end
