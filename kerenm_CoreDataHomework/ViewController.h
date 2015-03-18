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

-(void)refreshTable;

@end

