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
#import "Image.h"

@interface ViewController ()
@property (weak) IBOutlet NSTextField *txtLocation;
@property (weak) IBOutlet NSTextField *txtTag;
@property (weak) IBOutlet NSTextField *txtItemDescription;
@property (weak) IBOutlet NSButton *btnAdd;
@property CoreDataStackConfiguration *coreDataStackConfig;
@property ConfigurableCoreDataStack *stack;
@property NSManagedObjectContext *moc;
@property (weak) IBOutlet NSTableView *tblItems;
@property (weak) IBOutlet NSTextField *txtImage1;
@property (weak) IBOutlet NSTextField *txtImage2;
@property (weak) IBOutlet NSTextField *txtImage3;
@property NSArray *allItems;
@property NSURL *imageDirectory;
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
    
    //setup image directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *applicationSupportDirectory = [paths objectAtIndex:0];
    NSURL *applicationUrl = [NSURL fileURLWithPath: applicationSupportDirectory isDirectory: YES];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@", _coreDataStackConfig.appIdentifier, @"images"];
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

- (IBAction)browse_Clicked:(id)sender {
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
    
    [self refreshTable];
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
