// 
//  Authentication.m
//  DanKit
//
//  Created by Daniel Morgan on 02/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Authentication.h"

#import "User.h"

@implementation Authentication 

@dynamic accessToken;
@dynamic expirationDate;
@dynamic uid;
@dynamic provider;
@dynamic user;


#pragma mark Updating Attributes
//Save Attributes. Called after first time succesfull facebook auth

- (void)updateWithDictionary:(NSDictionary *)properties {
	
	if ([properties objectForKey:@"provider"] && ![[properties objectForKey:@"provider"]isKindOfClass:[NSNull class]]) 
		self.provider = [properties objectForKey:@"provider"];
	
	if ([properties objectForKey:@"access_token"] && ![[properties objectForKey:@"access_token"]isKindOfClass:[NSNull class]]) 
		self.accessToken = [properties objectForKey:@"access_token"];
	
	//not from rails, added in signup and login view controllers
	if ([properties objectForKey:@"expiration_date"] && ![[properties objectForKey:@"expiration_date"]isKindOfClass:[NSNull class]]) 
		self.expirationDate = [properties objectForKey:@"expiration_date"];
	
}

@end
