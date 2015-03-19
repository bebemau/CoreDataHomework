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

+(instancetype)findOrCreateWithTitle:(NSString*)title inMoc:(NSManagedObjectContext*)moc
{
    NSFetchRequest *fr = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    fr.predicate = [NSPredicate predicateWithFormat:@"tagName == %@", title];
    if ([moc countForFetchRequest:fr error:nil] == 1) {
        return [[moc executeFetchRequest:fr error:nil] firstObject];
    }
    
    Tag *tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:moc];
    tag.tagName = title;
    return tag;
}


@end
