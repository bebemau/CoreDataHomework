//
//  Image.m
//  kerenm_CoreDataHomework
//
//  Created by Man, Keren on 3/12/15.
//  Copyright (c) 2015 Man, Keren. All rights reserved.
//

#import "Image.h"
#import "Item.h"


@implementation Image

@dynamic imageUrl;
@dynamic imageToItem;

+(instancetype)createInMoc:(NSManagedObjectContext*)moc{
    Image *image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:moc];
    return image;
}

@end
