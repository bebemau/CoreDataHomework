//
//  Tag.h
//  kerenm_CoreDataHomework
//
//  Created by Man, Keren on 3/12/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * tagName;
@property (nonatomic, retain) Item *tagToItem;

+(instancetype)createInMoc:(NSManagedObjectContext*)moc;

@end
