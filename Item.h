//
//  Item.h
//  kerenm_CoreDataHomework
//
//  Created by Man, Keren on 3/17/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image, Location, Tag;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * datePosted;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSSet *itemToTag;
@property (nonatomic, retain) Location *itemToLocation;
@property (nonatomic, retain) NSSet *itemToImage;

+(instancetype)createInMoc:(NSManagedObjectContext*)moc;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addItemToTagObject:(Tag *)value;
- (void)removeItemToTagObject:(Tag *)value;
- (void)addItemToTag:(NSSet *)values;
- (void)removeItemToTag:(NSSet *)values;

- (void)addItemToImageObject:(Image *)value;
- (void)removeItemToImageObject:(Image *)value;
- (void)addItemToImage:(NSSet *)values;
- (void)removeItemToImage:(NSSet *)values;

@end
