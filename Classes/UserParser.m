//
//  UserParser.m
//  DanKit
//
//  Created by Daniel Morgan on 29/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserParser.h"
#import "NSManagedObject+Helpers.h"
#import "User.h"


@implementation UserParser
@synthesize managedObjectContext;

- (void)dealloc {
    
	[managedObjectContext release];
	[super dealloc];
}

-(id)init {
	
	if((self = [super init])) {
        // set up instance variables and whatever else here
		NSManagedObjectContext *context = [NSManagedObject moc];
		self.managedObjectContext = context;
    }
    return self;
	
}

#pragma mark User Auth Parsing

-(id)parseUserJson:(NSString *)jsonString withError:(NSError **)error {
	
	
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	
	//Json class parses the json string and returns an array with dictionaries for each item
	id userObject = [parser objectWithString:jsonString error:NULL];
	[parser release];
	
	//We haven't got json back but probably some html error
	if (!userObject) {
		*error = [UIHelpers appErrorWithCode:KErrorCodeRemoteJsonParsingError andDescription:@"Couldn't resolved an object from response. Probably malformatted JSON or HTML Error"];
		return nil;
	}
	
	//Are we dealing with a single user or a mutlitude of users?
	
	if ([userObject isKindOfClass:[NSDictionary class]]) {
		userObject = (NSDictionary *)userObject;
		return [self parseUserDictionary:userObject withError:error];
	}
	
	if ([userObject isKindOfClass:[NSArray class]]) {
		userObject = (NSArray *)userObject;
		return [self parseUsersArray:userObject withError:error];
	}
	
	
	*error = [UIHelpers appErrorWithCode:KErrorCodeRemoteJsonParsingError andDescription:@"Couldn't resolved an object from response. Probably malformatted JSON or HTML Error. It was neither a Dictionary nor an Array."];
	return nil;
	
	
}

#pragma mark User Auth Parsing

//Single User - Doesn't need to handel deleting

-(User *)parseUserDictionary:(NSDictionary *)userDictionary withError:(NSError **)error {
	
	//We haven't got json back but probably some html error
	if (!userDictionary) {
		*error = [UIHelpers appErrorWithCode:KErrorCodeRemoteJsonParsingError andDescription:@"Couldn't resolved an object from response. Probably malformatted JSON or HTML Error"];
		return nil;
	}
	
	
	//Create a new user if needed and then update it's attributes otherwise update existing
	//Then save
	if (![userDictionary objectForKey:@"id"]) {
		*error = [UIHelpers appErrorWithCode:KErrorCodeRemoteJsonParsingError andDescription:@"Couldn't resolved an object from response. Probably malformatted JSON or HTML Error"];
		return nil;
	}
	
	NSString *idString = [userDictionary objectForKey:@"id"];
	
	User *existingUser = [User findUserWithId:idString];
	
	
	//////////////
	//
	// Decide whether to create a new user or update existing user
	//

	if (existingUser) {
		//Existing
		[existingUser updateWithDictionary:userDictionary];
	}
	else {
		//New
		User *initialUser = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
		[initialUser updateWithDictionary:userDictionary];
		//[initialUser setIsUser:[NSNumber numberWithBool:YES]];
		existingUser = initialUser;
	}
	
	///////
	//
	// Save
	//
	
	NSError *anError;
	if (![self.managedObjectContext save:&anError]) {
		// Handle the error.
		NSLog(@"User Create Save Error %@",[anError localizedDescription]);
		*error = anError;
		return nil;
	}
	else {
		
		return existingUser;
	
	}
	
	
}

//Multiple User - Should handle deleting or should it?
-(NSMutableArray *)parseUsersArray:(NSArray *)resultsArray withError:(NSError **)error {
	
	//We haven't got json back but probably some html error
	if (!resultsArray) {
		*error = [UIHelpers appErrorWithCode:KErrorCodeRemoteJsonParsingError andDescription:@"Couldn't resolved an object from response. Probably malformatted JSON or HTML Error"];
		return nil;
	}
	
	__block NSMutableArray *collectedResults = [NSMutableArray arrayWithCapacity:resultsArray.count];
	
	[resultsArray enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
		
		User *user = [self parseUserDictionary:object withError:error];
		
		if (user) {
			[collectedResults addObject:user];
		}
		
		
	}];
	
	
	return collectedResults;
}



-(BOOL)updateUser:(User *)existingUser WithDictionary:(NSDictionary *)userDict withError:(NSError **)error {
	
	
	//Updates all other properties and sets the current user challenge
	[existingUser updateWithDictionary:userDict];
	
	//[existingUser setIsUser:[NSNumber numberWithBool:YES]];
	
	
	///////
	//
	// Save
	//
	
	NSError *anError;
	if (![self.managedObjectContext save:&anError]) {
		// Handle the error.
		NSLog(@"User Create Save Error %@",[anError localizedDescription]);
		*error = anError;
		return FALSE;
	}
	else {
		
		//Finally save a reference the current user so we can grab it on app launch as the latest user used.
		//[existingUser saveIDInUserDefaultsAndSetBools];
		
		return TRUE;
		
	}
	
}

#pragma mark Facebook Parsing

-(User *)parseFacebookUser:(NSDictionary *)userDict forUser:(User *)user withError:(NSError **)error {
	
	
	//We haven't got json back but probably some html error
	if (!userDict) {
		*error = [UIHelpers appErrorWithCode:KErrorCodeRemoteJsonParsingError andDescription:@"Couldn't resolved an object from Facebook response. Probably malformatted JSON or HTML Error"];
		return nil;
	}
	
	
	//Create a new user if needed and then update it's attributes otherwise update existing
	//Then save
	if (![userDict objectForKey:@"id"]) {
		*error = [UIHelpers appErrorWithCode:KErrorCodeRemoteJsonParsingError andDescription:@"Couldn't resolved a Facebook ID from Facebook response. Probably malformatted JSON or HTML Error"];
		return nil;
	}
	
	
	//////////////
	//
	// If user == nil then we create a new user
	//

	if (!user) {
		
		user = [User findUserWithFacebookId:[userDict objectForKey:@"id"]];
		
		//If we also can't find a local user with the facebook email then create an entirely new user.
		
		if (!user) {
			user = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
		}
		
	}
	
	
	
	//////////////
	//
	// Update the user with values from Facebook
	//

	[user updateWithDictionaryFromFacebook:userDict];
	
	
	
	NSError *anError;
	if (![self.managedObjectContext save:&anError]) {
		// Handle the error.
		NSLog(@"User Create Facebook Save Error %@",[anError localizedDescription]);
		*error = anError;
		return nil;
	}
	else {
		
		//[initialUser setAsCurrentUser];
		//Finally save a reference the current user so we can grab it on app launch as the latest user used.
		//[initialUser saveIDInUserDefaultsAndSetBools];
		return user;
		
	}
		
}

#pragma mark Auth Parsing

-(Authentication *)parseOauth:(NSDictionary *)authDict forUser:(User *)user error:(NSError **)error {
	
	//NSMutableArray *localAuths = [NSMutableArray arrayWithArray:[user.authentications allObjects]]; //anything left in this localArticles at the end will be deleted as it doesn't exist on remote
	
	Authentication *auth = nil;
	
	if (authDict) {
		
		
		if (![authDict objectForKey:@"provider"]) {
			
			*error = [UIHelpers appErrorWithCode:KErrorCodeRemoteJsonParsingError andDescription:@"Couldn't resolved an object from response. Probably malformatted JSON or HTML Error"];
			return nil;
		}
		
		
		Authentication *existingOauth = [user findAuthenticationWithProviderName:[authDict objectForKey:@"provider"]];
		
		//Update old or create new
		if (existingOauth) {
			
			[existingOauth updateWithDictionary:authDict];
			
			auth = existingOauth;

		}
		else {
			
			
			auth = (Authentication *)[NSEntityDescription insertNewObjectForEntityForName:@"Authentication" 
																		   inManagedObjectContext:self.managedObjectContext];
			
			[auth updateWithDictionary:authDict];

			[user addAuthenticationsObject:(NSManagedObject *)auth];
			 
			
		}

		
	}
	
	return auth;
			  
	
	
}


@end

