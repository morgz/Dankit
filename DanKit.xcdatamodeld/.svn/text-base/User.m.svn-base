// 
//  User.m
//  DanKit
//
//  Created by Daniel Morgan on 29/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "NSManagedObject+Helpers.h"
#import "Authentication.h"

@implementation User 

@dynamic userId;
@dynamic email;
@dynamic password;
@dynamic firstName;
@dynamic lastName;
@dynamic isCurrent;
@dynamic UDID;
@dynamic gender;
@dynamic facebookId;
@dynamic authentications;


+(id)findEntityWithPropertyName:(NSString *)property andValue:(id)searchValue {
	
	NSManagedObjectContext *managedObjectContext = [self moc];
	
	//Get the User from the core data store. If they don't exist then create.
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [self entity];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %@",property,searchValue]];
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *returnedEntryArray = [managedObjectContext executeFetchRequest:request error:&error];
	
	// Pass back the issue if it has been found with the requested ID
	// Other wise pass back nil
	if (returnedEntryArray.count > 0) {
		return (User *)[returnedEntryArray objectAtIndex:0];
	}
	else {
		return nil;
	}
	
}


+(NSMutableArray *)allSortedBy:(NSString *)sortBy {
	
	
	NSManagedObjectContext *managedObjectContext = [self moc];
	
	//Get all the currently stored Issues and order them by their issue number
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [self entity];
	[request setEntity:entity];
	
	if (sortBy != nil) {
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[request setSortDescriptors:sortDescriptors];
		[sortDescriptors release];
		[sortDescriptor release];
	}
	
	NSError *error;
	NSMutableArray *fetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	[request release];
	
	
	if (fetchResults == nil) {
		// Handle the error.
		return nil;
	}
	else {
		return [fetchResults autorelease];
	}
	
}

+(User *)findUserWithId:(NSString *)searchTerm {

	User *aUser = (User *)[self findEntityWithPropertyName:@"userId" andValue:searchTerm];

	if (aUser) {
		return aUser;
	}
	else {
		return nil;
	}
}


+(User *)findUserWithEmail:(NSString *)searchTerm {
	
	User *aUser = (User *)[self findEntityWithPropertyName:@"email" andValue:searchTerm];
	
	if (aUser) {
		return aUser;
	}
	else {
		return nil;
	}
}

+(User *)findUserWithFacebookId:(NSString *)searchTerm {
	
	User *aUser = (User *)[self findEntityWithPropertyName:@"facebookId" andValue:searchTerm];
	
	if (aUser) {
		return aUser;
	}
	else {
		return nil;
	}
}

+(User *)findCurrentUser {
	
	User *aUser = (User *)[self findEntityWithPropertyName:@"isCurrent" andValue:[NSNumber numberWithBool:YES]];
	
	if (aUser) {
		return aUser;
	}
	else {
		return nil;
	}
}

-(Authentication *)findAuthenticationWithProviderName:(NSString *)name {
	
	NSManagedObjectContext *managedObjectContext = [self moc];
	
	//Get the User from the core data store. If they don't exist then create.
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Authentication" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF IN %@ AND provider == %@",self.authentications,name];
	[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *returnedEntryArray = [managedObjectContext executeFetchRequest:request error:&error];
	
	// Pass back the issue if it has been found with the requested ID
	// Other wise pass back nil
	if (returnedEntryArray.count > 0) {
		return (Authentication *)[returnedEntryArray objectAtIndex:0];
	}
	else {
		return nil;
	}
	
}

#pragma mark Updating Attributes
//Save extra User Attributes. Called after successful login or signup.

- (void)updateWithDictionary:(NSDictionary *)properties {
	
	if ([properties objectForKey:@"id"] && ![[properties objectForKey:@"id"]isKindOfClass:[NSNull class]]) 
		self.userId = [properties objectForKey:@"id"];
	
	if ([properties objectForKey:@"email"] && ![[properties objectForKey:@"email"]isKindOfClass:[NSNull class]]) 
		self.email = [properties objectForKey:@"email"];
	
	//not from rails, added in signup and login view controllers
	if ([properties objectForKey:@"password"] && ![[properties objectForKey:@"password"]isKindOfClass:[NSNull class]]) 
		self.password = [properties objectForKey:@"password"];
	
	//if ([properties objectForKey:@"is_private"] && ![[properties objectForKey:@"is_private"]isKindOfClass:[NSNull class]]) 
	//	self.isPrivate = [properties objectForKey:@"is_private"];
	
	/*
	 if ([properties objectForKey:@"username"] && ![[properties objectForKey:@"username"]isKindOfClass:[NSNull class]])
	 self.username = [properties objectForKey:@"username"];
	 
	 if ([properties objectForKey:@"first_name"] && ![[properties objectForKey:@"first_name"]isKindOfClass:[NSNull class]])
	 self.firstName = [properties objectForKey:@"first_name"];
	 
	 if ([properties objectForKey:@"last_name"] && ![[properties objectForKey:@"last_name"]isKindOfClass:[NSNull class]]) 
	 self.lastName = [properties objectForKey:@"last_name"];
	 
	 if ([properties objectForKey:@"description"] && ![[properties objectForKey:@"description"]isKindOfClass:[NSNull class]]) 
	 self.userDescription = [properties objectForKey:@"description"];
	 
	 */
	
	/*
	 if ([properties objectForKey:@"gender_id"] && ![[properties objectForKey:@"gender_id"]isKindOfClass:[NSNull class]])
	 self.gender = [properties objectForKey:@"gender_id"];
	 
	 if ([properties objectForKey:@"birth_date"] && ![[properties objectForKey:@"birth_date"]isKindOfClass:[NSNull class]]) {
	 
	 NSDate *date = [DateHelpers parseDate:[properties objectForKey:@"birth_date"]];
	 
	 self.birthDate = date;
	 }
	 */
	
}


- (void)updateWithDictionaryFromFacebook:(NSDictionary *)properties {
	
	if ([properties objectForKey:@"id"] && ![[properties objectForKey:@"id"]isKindOfClass:[NSNull class]]) 
		self.facebookId = [properties objectForKey:@"id"];
	
	if ([properties objectForKey:@"email"] && ![[properties objectForKey:@"email"]isKindOfClass:[NSNull class]]) 
		self.email = [properties objectForKey:@"email"];
	
	if ([properties objectForKey:@"first_name"] && ![[properties objectForKey:@"first_name"]isKindOfClass:[NSNull class]]) 
		self.firstName = [properties objectForKey:@"first_name"];
	
	if ([properties objectForKey:@"last_name"] && ![[properties objectForKey:@"last_name"]isKindOfClass:[NSNull class]]) 
		self.lastName = [properties objectForKey:@"last_name"];
	
	
	//if ([properties objectForKey:@"is_private"] && ![[properties objectForKey:@"is_private"]isKindOfClass:[NSNull class]]) 
	//	self.isPrivate = [properties objectForKey:@"is_private"];
	
	/*
	 if ([properties objectForKey:@"username"] && ![[properties objectForKey:@"username"]isKindOfClass:[NSNull class]])
	 self.username = [properties objectForKey:@"username"];
	 
	 if ([properties objectForKey:@"first_name"] && ![[properties objectForKey:@"first_name"]isKindOfClass:[NSNull class]])
	 self.firstName = [properties objectForKey:@"first_name"];
	 
	 if ([properties objectForKey:@"last_name"] && ![[properties objectForKey:@"last_name"]isKindOfClass:[NSNull class]]) 
	 self.lastName = [properties objectForKey:@"last_name"];
	 
	 if ([properties objectForKey:@"description"] && ![[properties objectForKey:@"description"]isKindOfClass:[NSNull class]]) 
	 self.userDescription = [properties objectForKey:@"description"];
	 
	 */
	
	/*
	 if ([properties objectForKey:@"gender_id"] && ![[properties objectForKey:@"gender_id"]isKindOfClass:[NSNull class]])
	 self.gender = [properties objectForKey:@"gender_id"];
	 
	 if ([properties objectForKey:@"birth_date"] && ![[properties objectForKey:@"birth_date"]isKindOfClass:[NSNull class]]) {
	 
	 NSDate *date = [DateHelpers parseDate:[properties objectForKey:@"birth_date"]];
	 
	 self.birthDate = date;
	 }
	 */
	
}


@end
