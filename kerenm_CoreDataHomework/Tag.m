//
//  Tag.m
//  kerenm_CoreDataHomework
//
//  Created by Man, Keren on 3/12/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import "Tag.h"
#import "Item.h"


@implementation Tag

@dynamic tagName;
@dynamic tagToItem;

+(instancetype)createInMoc:(NSManagedObjectContext*)moc{
    Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:moc];
    return tag;
}

@end
