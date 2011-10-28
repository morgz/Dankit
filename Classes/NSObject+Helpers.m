//
//  NSObject+Helpers.m
//  DanKit
//
//  Created by Daniel Morgan on 13/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSObject+Helpers.h"

@implementation NSObject (Helpers)

-(ATMHud *)sharedHud {
	
	return [((DanKitAppDelegate *)[[UIApplication sharedApplication] delegate])hud];
	
}

-(void)challengeAuthenticationShowLogin:(BOOL)login orShowSignUp:(BOOL)signup {
	
	return [((DanKitAppDelegate *)[[UIApplication sharedApplication] delegate])challengeAuthenticationShowLogin:login orShowSignUp:signup];
	
}

-(void)hideAuthenticationController {
	
	[((DanKitAppDelegate *)[[UIApplication sharedApplication] delegate])hideAuthenticationController];
}

-(BOOL)isUnauthorised:(ASIHTTPRequest *)request {
	
	//Unauthorized
	if (request.responseStatusCode == KHTMLCodeUnauthorized) {
		
		
		//////////////
		//
		// If we're auto loggin in then because we're unauthorized need to display login form
		//
		if ([request isRemoteRequestOfType:KRemoteRequestTypeAutoLogin]) {
			
			[[UserManager sharedManager] challengeAuthenticationShowLogin:YES orShowSignUp:NO];
		}
		
		[UIHelpers showLoginFailedAlert];
		
		return YES;
		
	}
	else {
		return NO;
	}
    
	
}

/*
 -(void)challengeAuthenticationAfterFaceBookLogin {
 
 return [((DanKitAppDelegate *)[[UIApplication sharedApplication] delegate])challengeAuthentication];
 
 }
 */

@end