//
//  User.h
//  DanKit
//
//  Created by Daniel Morgan on 29/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Authentication;
@interface User :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * isCurrent;
@property (nonatomic, retain) NSString * UDID;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * facebookId;

@property (nonatomic, retain) NSSet* authentications;


+(User *)findCurrentUser;
+(User *)findUserWithEmail:(NSString *)searchTerm;
+(User *)findUserWithId:(NSString *)searchTerm;
+(User *)findUserWithFacebookId:(NSString *)searchTerm;

-(Authentication *)findAuthenticationWithProviderName:(NSString *)name ;

+(id)findEntityWithPropertyName:(NSString *)property andValue:(id)searchValue;
+(NSMutableArray *)allSortedBy:(NSString *)sortBy;


//Update properties of user from remote. Called after succesfuly signup/signin
- (void)updateWithDictionary:(NSDictionary *)properties;
- (void)updateWithDictionaryFromFacebook:(NSDictionary *)properties;

@end

@interface User (CoreDataGeneratedAccessors)
- (void)addAuthenticationsObject:(NSManagedObject *)value;
- (void)removeAuthenticationsObject:(NSManagedObject *)value;
- (void)addAuthentications:(NSSet *)value;
- (void)removeAuthentications:(NSSet *)value;
@end


