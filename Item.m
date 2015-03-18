//
//  Item.m
//  kerenm_CoreDataHomework
//
//  Created by Man, Keren on 3/17/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import "Item.h"
#import "Image.h"
#import "Location.h"
#import "Tag.h"


@implementation Item

@dynamic title;
@dynamic datePosted;
@dynamic uuid;
@dynamic itemToTag;
@dynamic itemToLocation;
@dynamic itemToImage;

+(instancetype)createInMoc:(NSManagedObjectContext*)moc{
    Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:moc];
    return item;
}

@end
