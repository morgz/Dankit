//
//  NSManagedObject+Helperss.h
//  DanKit
//
//  Created by Daniel Morgan on 13/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import "NSManagedObject+Helpers.h"

@implementation NSManagedObject (Helpers)

+ (id)create {
	NSEntityDescription *entityDecription = [self entity];
	NSString *name = [entityDecription name];
	return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:[self moc]] ;
}

+ (NSManagedObjectContext *)moc {
	return [(id)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (NSManagedObjectContext *)moc {
	return [[self class] moc];
}

+ (NSManagedObjectModel *)mom {
	return [(id)[[UIApplication sharedApplication] delegate] managedObjectModel];
}

+ (NSEntityDescription *)entity {
	return [[[self mom] entitiesByName] objectForKey:NSStringFromClass([self class])];
}

+ (NSFetchRequest *)allFetchRequest {
	NSFetchRequest *fr = [[NSFetchRequest alloc] init];
	[fr setEntity:[self entity]];
	return [fr autorelease];
}

+ (NSArray *)allObjects {
	return [[self moc] executeFetchRequest:[self allFetchRequest] error:nil];
}

+ (NSUInteger)allObjectsCount {
	return [[self moc] countForFetchRequest:[self allFetchRequest] error:nil];
}

- (BOOL)save {
	return [[self moc] save:nil];	
}

- (void)deleteObject {
	[[self moc] deleteObject:self];
}




@end


