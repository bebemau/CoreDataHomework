//
//  Item.m
//  CoreDataExercise
//
//  Created by Man, Keren on 3/5/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import "Item.h"


@implementation Item

@dynamic title;

+(instancetype)createInMoc:(NSManagedObjectContext*)moc{
    Item *ii = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:moc];
    return ii;
}

@end
