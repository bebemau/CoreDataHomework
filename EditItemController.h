//
//  EditItemController.h
//  kerenm_CoreDataHomework
//
//  Created by Man, Keren on 3/16/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewController.h"
#import "Item.h"

@interface EditItemController : NSViewController

@property (weak) IBOutlet NSTextField *txtItemDescription;
@property (weak) IBOutlet NSTextField *txtTag;
@property (weak) IBOutlet NSTextField *txtLocation;
@property (weak) IBOutlet NSTextField *txtImage1;
@property (weak) IBOutlet NSTextField *txtImage3;
@property (weak) IBOutlet NSTextField *txtImage2;
@property (weak) IBOutlet NSImageView *imageView1;
@property (weak) IBOutlet NSImageView *imageView2;
@property NSManagedObjectContext *moc;
@property NSString *appIdentifier;
@property ViewController *parentVC;
@property Item *item;
@end
