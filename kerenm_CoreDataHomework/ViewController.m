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

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _coreDataStackConfig = [CoreDataStackConfiguration new];
    _coreDataStackConfig.storeType = NSSQLiteStoreType;
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
    
    
}


- (IBAction)btnAdd_Clicked:(id)sender {
    Item *item = [Item createInMoc: _moc];
    item.title  = self.txtItemDescription.stringValue;
    NSError *saveError = nil;
    BOOL success = [_moc save:&saveError];
    if(!success){
        [[NSApplication sharedApplication]  presentError:saveError];
    }
    
    [self refreshTable];
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
    NSTableCellView *cell = [tableView makeViewWithIdentifier:@"tableCellID" owner:nil];
    cell.textField.stringValue=@(rowIndex).stringValue;
    //NSLog(@"rowindex %ld", (long)rowIndex);
    NSLog(@"rowindex at viewForTableColumn %ld", (NSUInteger)rowIndex);

    Item *i = [_allItems objectAtIndex:rowIndex];
    NSString *itemTitle = i.title;
    cell.textField.stringValue = itemTitle;
    return cell;
}

-(NSInteger)   numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.allItems count];
}

@end
