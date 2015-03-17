//
//  Image.h
//  kerenm_CoreDataHomework
//
//  Created by Man, Keren on 3/12/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) Item *imageToItem;

+(instancetype)createInMoc:(NSManagedObjectContext*)moc;

@end
