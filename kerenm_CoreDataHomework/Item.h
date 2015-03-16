//
//  Item.h
//  CoreDataExercise
//
//  Created by Man, Keren on 3/5/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * datePosted;
@property (nonatomic, retain) NSSet * images;
@property (nonatomic, retain) NSSet * tags;
@property (nonatomic, retain) Location * location;
@property (nonatomic, retain) NSString * uuid;

+(instancetype)createInMoc:(NSManagedObjectContext*)moc;

@end
