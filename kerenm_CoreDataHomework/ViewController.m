//
//  ViewController.m
//  CoreDataExercise
//
//  Created by Man, Keren on 3/5/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import "ViewController.h"
#import "ConfigurableCoreDataStack.h"
#import "Item.h"

@interface ViewController ()
@property (weak) IBOutlet NSTextField *txtImage;
@property (weak) IBOutlet NSTextField *txtLocation;
@property (weak) IBOutlet NSTextField *txtTag;
@property (weak) IBOutlet NSTextField *txtItemDescription;
@property (weak) IBOutlet NSButton *btnAdd;
@property CoreDataStackConfiguration *coreDataStackConfig;
@property ConfigurableCoreDataStack *stack;
@property NSManagedObjectContext *moc;
@property (weak) IBOutlet NSTableView *tblItems;
@property NSArray *allItems;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _coreDataStackConfig = [CoreDataStackConfiguration new];
    //_coreDataStackConfig.storeType = NSSQLiteStoreType;
    _coreDataStackConfig.storeType = NSInMemoryStoreType;
    _coreDataStackConfig.modelName = @"InventoryModel";
    _coreDataStackConfig.appIdentifier = @"com.kerenman.inventory";
    _coreDataStackConfig.dataFileNameWithExtension = @"store.sqllite.coredataHomework";
    _coreDataStackConfig.searchPathDirectory = NSApplicationSupportDirectory;
    
    _stack = [[ConfigurableCoreDataStack alloc ] initWithConfiguration:_coreDataStackConfig];
    _moc = _stack.managedObjectContext;
    
    //table
    self.tblItems.delegate = self;
    self.tblItems.dataSource = self;
    [self refreshTable];
    [self.tblItems setTarget:self];
    [self.tblItems setDoubleAction:@selector(tblItems_DoubleClick:)];
    
//    NSRect frame;
//    frame.size.width = frame.size.height = 18;
//    NSButton *myCheckBox = [[NSButton alloc] initWithFrame:frame];
//    [myCheckBox setButtonType:NSSwitchButton];
//    [self addSubview:myCheckBox];
}

- (void)tblItems_DoubleClick:(id)object {
    NSInteger rowIndex = [self.tblItems clickedRow];
    NSLog(@"%ld", (long)rowIndex);
    if(rowIndex != -1){
        NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
        NSViewController *vc = [sb instantiateControllerWithIdentifier:@"itemDetailViewController"];
        //[self presentViewControllerAsSheet:vc];
        [self presentViewControllerAsModalWindow:vc];
    }
}

-(void)refreshTable{
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSError *fetchError = nil;
    _allItems = [_moc executeFetchRequest:fr error:&fetchError];
    NSLog(@"%@", _allItems);
    
    [self.tblItems reloadData];
}

-(NSView*)tableView:(NSTableView*)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
    Item *i = [_allItems objectAtIndex:rowIndex];
    NSTableCellView *cell = nil;
    
    if([[tableColumn identifier] isEqualToString:@"titleColumn"]){
        cell = [tableView makeViewWithIdentifier:@"tableCellTitle" owner:nil];
        cell.textField.stringValue=@(rowIndex).stringValue;
        NSString *itemTitle = i.title;
        cell.textField.stringValue = itemTitle;
    }
    else if ([[tableColumn identifier] isEqualToString:@"datePostedColumn"]){
        cell = [tableView makeViewWithIdentifier:@"tableCellDatePosted" owner:nil];
        cell.textField.stringValue=@(rowIndex).stringValue;
        NSString *dateString = [NSDateFormatter localizedStringFromDate: i.datePosted
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterFullStyle];
        cell.textField.stringValue = dateString;
    }

    return cell;
}

-(NSInteger)   numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.allItems count];
}

//- (IBAction)clickShow:(id)sender {
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
//    NSViewController *vc = [sb instantiateControllerWithIdentifier:@"blueVc"];
////    [self presentViewControllerAsSheet:vc];
////    [self dismissController:vc];
//    //[self presentViewControllerAsModalWindow:vc];
//    NSButton *button = sender;
//    [self presentViewController:vc asPopoverRelativeToRect:button.bounds ofView:button preferredEdge:NSMaxYEdge behavior:NSPopoverBehaviorTransient];
//}

- (IBAction)browse_Clicked:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    op.directoryURL = [NSURL fileURLWithPath:@"~/Desktop".stringByExpandingTildeInPath];
    
    //    [op beginSheet:self.view.window  completionHandler:^(NSModalResponse returnCode) {
    //        //execute after user makes choice
    //        NSLog(@"Uer finished choosing");
    //    }];
    
    [op beginWithCompletionHandler:^(NSInteger result) {
        //execute after user makes choice
        NSLog(@"User finished choosing");
        
        NSLog(@"user got: %@", op.URLs);
        
        NSError *err = nil;
        NSURL *myURL = nil; //somewhere we decide where
        //[NSFileManager defaultManager] copyItemAtURL:op.URL toURL:([myURL error: &err];
    }];

}

- (IBAction)btnSubmit_clicked:(id)sender {
    Item *item = [Item createInMoc: _moc];
    item.title  = self.txtItemDescription.stringValue;
    
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    //    NSDate *datePosted = [dateFormatter dateFromString:self.txtDatePosted.stringValue];
    item.datePosted  = [NSDate date];
    NSError *saveError = nil;
    BOOL success = [_moc save:&saveError];
    if(!success){
        [[NSApplication sharedApplication]  presentError:saveError];
    }
    
    [self refreshTable];
}

@end
