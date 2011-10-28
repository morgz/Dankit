//
//  Authentication.h
//  DanKit
//
//  Created by Daniel Morgan on 02/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class User;

@interface Authentication :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * accessToken;
@property (nonatomic, retain) NSString * expirationDate;

@property (nonatomic, retain) NSString * uid; //For recalling auths saved on rails
@property (nonatomic, retain) NSString * provider;
@property (nonatomic, retain) User * user;

- (void)updateWithDictionary:(NSDictionary *)properties;

@end



