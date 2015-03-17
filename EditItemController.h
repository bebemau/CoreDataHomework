//
//  EditItemController.h
//  kerenm_CoreDataHomework
//
//  Created by Man, Keren on 3/16/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewController.h"

@interface EditItemController : NSViewController
@property NSManagedObjectContext *moc;
@property NSString *appIdentifier;
@property ViewController *parentVC;
@end
