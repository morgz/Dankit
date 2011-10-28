//
//  UserParser.h
//  DanKit
//
//  Created by Daniel Morgan on 29/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JSON.h"

@class User;
@class Authentication;
@interface UserParser : NSObject {

	NSManagedObjectContext *managedObjectContext;
	
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

-(User *)parseFacebookUser:(NSDictionary *)userDict forUser:(User *)user withError:(NSError **)error;
//-(User *)parseUserJson:(NSString *)jsonString withError:(NSError **)error;

-(id)parseUserJson:(NSString *)jsonString withError:(NSError **)error;
-(User *)parseUserDictionary:(NSDictionary *)userDictionary withError:(NSError **)error;
-(NSMutableArray *)parseUsersArray:(NSArray *)resultsArray withError:(NSError **)error;

-(BOOL)updateUser:(User *)existingUser WithDictionary:(NSDictionary *)userDict withError:(NSError **)error;

-(Authentication *)parseOauth:(NSDictionary *)authDict forUser:(User *)user error:(NSError **)error;

@end