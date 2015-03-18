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
#import "EditItemController.h"

@interface ViewController ()
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
        NSViewController *vc = [sb instantiateControllerWithIdentifier:@"EditItemControllerID"];
        Item *item = ((Item *)[_allItems objectAtIndex:rowIndex]);
        ((EditItemController *)vc).item = item;
        ((EditItemController *)vc).moc = _moc;
        //[self presentViewControllerAsSheet:vc];
        [self presentViewControllerAsModalWindow:vc];
    }
}

-(void)refreshTable{
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSError *fetchError = nil;
    _allItems = [_moc executeFetchRequest:fr error:&fetchError];
    //NSLog(@"%@", _allItems);
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

- (IBAction)btnAddNewItem_clicked:(id)sender {
    NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSViewController *vc = [sb instantiateControllerWithIdentifier:@"EditItemControllerID"];
    //[self presentViewControllerAsModalWindow:vc];
    [self presentViewControllerAsSheet:vc];
    ((EditItemController *)vc).moc = _moc;
    ((EditItemController *)vc).appIdentifier = _coreDataStackConfig.appIdentifier;
    ((EditItemController *)vc).parentVC = self;
}

@end
