//
//  NSManagedObject+Helpers.h
//  DanKit
//
//  Created by Daniel Morgan on 29/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Helpers) 

	+ (NSManagedObjectContext *)moc;
	+ (NSManagedObjectModel *)mom;
	+ (NSEntityDescription *)entity;
	+ (NSFetchRequest *)allFetchRequest;
	+ (NSArray *)allObjects;
	+ (NSUInteger)allObjectsCount;
	+ (id)create;
	
	- (NSManagedObjectContext *)moc;
	- (BOOL)save;
	- (void)deleteObject;
	
@end
