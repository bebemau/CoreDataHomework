//
//  Location.m
//  kerenm_CoreDataHomework
//
//  Created by Man, Keren on 3/12/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import "Location.h"
#import "Item.h"


@implementation Location

@dynamic latitude;
@dynamic longtitude;
@dynamic locationName;
@dynamic locationToItem;

+(instancetype)createInMoc:(NSManagedObjectContext*)moc{
    Location *location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:moc];
    return location;
}

@end
