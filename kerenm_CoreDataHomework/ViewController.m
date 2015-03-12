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
    
    
}


- (IBAction)btnAdd_Clicked:(id)sender {
    Item *item = [Item createInMoc: _moc];
    item.title  = self.txtItemDescription.stringValue;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    NSDate *datePosted = [dateFormatter dateFromString:self.txtDatePosted.stringValue];
    item.datePosted  = datePosted;
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

@end
