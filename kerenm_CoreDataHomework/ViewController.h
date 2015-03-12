//
//  ViewController.h
//  CoreDataExercise
//
//  Created by Man, Keren on 3/5/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ConfigurableCoreDataStack.h"

@interface ViewController : NSViewController<
NSTableViewDataSource,
NSTableViewDelegate
>

@property (weak) IBOutlet NSTextField *txtItemDescription;
@property (weak) IBOutlet NSButton *btnAdd;
@property CoreDataStackConfiguration *coreDataStackConfig;
@property ConfigurableCoreDataStack *stack;
@property NSManagedObjectContext *moc;
@property (weak) IBOutlet NSTableView *tblItems;
@property NSArray *allItems;
@property (weak) IBOutlet NSTextField *txtDatePosted;
@end

