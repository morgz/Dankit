
//
//  Created by Daniel Morgan on 28/05/2010.
//  Copyright 2010 Kinkub. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "User.h"

@interface ASIHTTPRequest (DanKit) 


- (id)initWithAppURL:(NSURL *)newURL;
+ (NSURL *)urlFor:(NSString *)action;

+ (ASIHTTPRequest *)appRequestFor:(NSString *)action;
+ (ASIHTTPRequest *)appDeleteRequestFor:(NSString *)action;

-(BOOL)isRemoteRequestOfType:(NSString *)type;

/**
 A title set by the webapp.. dictates with titles will be used. We'll use this for now.
 **/


+ (ASIFormDataRequest *)appFormRequestFor:(NSString *)action withParams:(NSDictionary *)params;
+ (ASIFormDataRequest *)appPutRequestFor:(NSString *)action withParams:(NSDictionary *)params;

#pragma mark Username Methods

+ (ASIFormDataRequest *)loginRequestWithUsername:(NSString *)username andPassword:(NSString *)password;
+ (ASIFormDataRequest *)signUpRequestWithUsername:(NSString *)username andPassword:(NSString *)password andUser:(User *)user;


#pragma mark -

-(void)withoutBasicAuthentification;

@end
