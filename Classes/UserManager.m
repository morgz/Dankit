//
//  UserManager.m
//  DanKit
//
//  Created by Daniel Morgan on 29/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"
#import "ASINetworkQueue.h"
#import "UserParser.h"
#import "ASIHTTPRequest+DanKit.h"
#import "ASIFormDataRequest.h"
#import "NSManagedObject+Helpers.h"

typedef void (^RemoteRequestFinishedBlock)(UIViewController *);

static UserManager *sharedUserManager = nil;

@implementation UserManager
@synthesize currentUser;
@synthesize authNetworkQueue;
@synthesize parser;
@synthesize facebook;
@synthesize facebookPermissions;
@synthesize password;
@synthesize userDataNetworkQueue;


-(id)init {
	
	self = [super init];
	
	if (self) {
		parser = [[UserParser alloc]init];
		
		self.facebookPermissions =  [NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"email", @"offline_access",nil];
		
		facebook = [[Facebook alloc] initWithAppId:kFacebookAppId];
		
		[self setCurrentUser:[User findCurrentUser]];
	}
	
	return self;
	
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
	[currentUser release];
	
	authNetworkQueue.delegate = nil;
	[authNetworkQueue release];
	
	userDataNetworkQueue.delegate = nil;
	[userDataNetworkQueue release];
	
	[parser release];
	[facebook release];
	[facebookPermissions release];
	[password release];
	
    [super dealloc];
}


- (void)setCurrentUser:(User*)aUser {
   
	@synchronized(self)
    {
        if (aUser != currentUser)
        {
            [currentUser release];
            currentUser = [aUser retain];
			
			User *previousCurrentUser = [User findCurrentUser];
			
			if (previousCurrentUser != currentUser) {
								
				//We might have got nil so just check first.
				if (previousCurrentUser) {
					previousCurrentUser.isCurrent = [NSNumber numberWithBool:NO];
				}
				
				currentUser.isCurrent = [NSNumber numberWithBool:YES];
				
				NSError *anError;
				
				if (![[NSManagedObject moc] save:&anError]) {
					// Handle the error.
					NSLog(@"Setting Current User Save Error %@",[anError localizedDescription]);
				}
			}
			
			
        }
				
    }
}


#pragma mark -
#pragma mark USER REMOTE QUERY METHODS

-(void)getRemoteUserDataFor:(NSString *)url withCallbackController:(UIViewController *)callbackController {
	
	[[self sharedHud] setCaption:@"Updating Users"];
	[[self sharedHud] setActivity:YES];
	[[self sharedHud] show];
	
	if (!self.userDataNetworkQueue) {
		
		self.userDataNetworkQueue = [ASINetworkQueue queue];
		[self.userDataNetworkQueue setDelegate:self];
		//[self.userDataNetworkQueue setRequestDidFinishSelector:@selector(userDataRequestFinished:)];
		//[self.userDataNetworkQueue setRequestDidFailSelector:@selector(userDataRequestFailed:)];
		[self.userDataNetworkQueue setQueueDidFinishSelector:@selector(userDataQueueFinished:)];
	}
	
	// Stop anything already in the queue
	[self.userDataNetworkQueue cancelAllOperations];
	
	
	__block ASIHTTPRequest *request = [ASIHTTPRequest appRequestFor:url];
	
	//If we want callbacks and have set a callback controller
	if (callbackController) {
		
		[request setCompletionBlock:^{
			
			[self userDataRequestFinished:request];
			[callbackController remoteRequestFinished];
		}];
		
		[request setFailedBlock:^{
			[self userDataRequestFailed:request];
			[callbackController remoteRequestFailed];

		}];
	}
	
	
	[self.userDataNetworkQueue addOperation:request];
	[self.userDataNetworkQueue go];
	
}

-(void)userDataRequestFinished:(ASIHTTPRequest *)request {
	
	[[self sharedHud] hide];

	//If we get http error code 422 then we have validation errors
	if (request.responseStatusCode == KHTMLCodeUnauthorized) {
		[self authRequestFailed:request];
		return;
	}
	
	//If we get http error code 422 then we have validation errors
	if (request.responseStatusCode == KHTMLCodeForbidden) {
		[UIHelpers showAlert:@"Forbidden" withMessage:@"You are not allowed to access this content"];
		return;
	}
	
		
	NSString *response = [request responseString];
	NSLog(@"User Data Request suceeded");
	
	NSError *error = nil;
	
	id userData = nil;
	
	if (userData = [parser parseUserJson:response withError:&error]) {
	
	}
	else {
		
		[UIHelpers showAlertWithError:error];
		//self.currentUser = nil;
	}
	
	
	
	
}

-(void)userDataRequestFailed:(ASIHTTPRequest *)request {
	
	[[self sharedHud] hideAfter:1.0];
	
	
	//Checks the request to see if it's unauthorised. If it is then is displays the login dialogue.
	if ([self isUnauthorised:request])
		return;
	
	
	//Handle misc error
	NSLog(@"Request failed");
	[UIHelpers showAlertWithError:[request error]];

}

- (void)userDataQueueFinished:(ASINetworkQueue *)queue
{
	
	NSLog(@"Queue finished");
}




#pragma mark -
#pragma mark AUTHENTICATION METHODS

-(void)checkAuthentication {
	
	//TODO: if we don't have an internet connection and no account
	
	User *lastUser = [User findCurrentUser];
	
	
	//////////////
	//
	// We don't have any saved user accounts so load up the base Authentication controller.
	//
	if (!lastUser) {
		
		[self challengeAuthenticationShowLogin:NO orShowSignUp:NO];
		return;
	}
	
	//////////////
	//
	// We don't have a password but we have a user. Will have prob come from facebook connect.
	//
	if (!lastUser.password && lastUser.facebookId) {
		[self challengeAuthenticationShowLogin:NO orShowSignUp:YES];
		return;
	}
	
	
	
	//////////////
	//
	// Try and login if it fails we'll redirect to login screen
	//
	[self autoLoginWithCurrentUser];

	
	
}

-(void)saveAuthenticatedPasswordForCurrentUser {
	
	if (self.currentUser && self.password) {
		
		self.currentUser.password = self.password;
		
		NSError *anError;
		
		if (![[NSManagedObject moc] save:&anError]) {
			// Handle the error.
			NSLog(@"Setting Current User Password Save Error %@",[anError localizedDescription]);
		}
	}
	
}

#pragma mark Auth Network Methods

#pragma mark Login

-(void)autoLoginWithCurrentUser {

	if (self.currentUser) {
		if (!self.authNetworkQueue) {
			
			self.authNetworkQueue = [ASINetworkQueue queue];
			[self.authNetworkQueue setDelegate:self];
			[self.authNetworkQueue setRequestDidFinishSelector:@selector(authRequestFinished:)];
			[self.authNetworkQueue setRequestDidFailSelector:@selector(authRequestFailed:)];
			[self.authNetworkQueue setQueueDidFinishSelector:@selector(authQueueFinished:)];
		}
		
		// Stop anything already in the queue
		[self.authNetworkQueue cancelAllOperations];
		
		
		ASIFormDataRequest *request = [ASIFormDataRequest autoLoginRequestWithUsername:self.currentUser.email andPassword:self.currentUser.password];
		
		[self.authNetworkQueue addOperation:request];
		
		//Set the status of our user. We use this in the UI
		//CURRENT_USER.isAuthenticating = YES;
		
		//[self.loadingController showFullScreenLoadingWithMessage:@"Entering the Show" inController:self withYPosition:25 hidesButtons:YES];
		[self.authNetworkQueue go];
	}
	
}

-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)aPassword {
	
	
	[[self sharedHud] setCaption:@"Logging in"];
	[[self sharedHud] setActivity:YES];
	[[self sharedHud] show];
	
	if (!self.authNetworkQueue) {
		
		self.authNetworkQueue = [ASINetworkQueue queue];
		[self.authNetworkQueue setDelegate:self];
		[self.authNetworkQueue setRequestDidFinishSelector:@selector(authRequestFinished:)];
		[self.authNetworkQueue setRequestDidFailSelector:@selector(authRequestFailed:)];
		[self.authNetworkQueue setQueueDidFinishSelector:@selector(authQueueFinished:)];
	}
	
	// Stop anything already in the queue
	[self.authNetworkQueue cancelAllOperations];
	
	
	ASIFormDataRequest *request = [ASIFormDataRequest loginRequestWithUsername:username andPassword:aPassword];
	
	[self.authNetworkQueue addOperation:request];
	
	//Set the current password in an ivar so we can get it later
	self.password = aPassword;
	
	//Set the status of our user. We use this in the UI
	//CURRENT_USER.isAuthenticating = YES;
	
	//[self.loadingController showFullScreenLoadingWithMessage:@"Entering the Show" inController:self withYPosition:25 hidesButtons:YES];
	[self.authNetworkQueue go];
	
}


-(void)loginFacebook {

	[[self sharedHud] setCaption:@"Connecting to Facebook"];
	[[self sharedHud] setActivity:YES];
	[[self sharedHud] show];
	
	
	[self performSelector:@selector(authorizeFacebook) withObject:nil afterDelay:1];
}

-(void)authorizeFacebook {
	
	//TODO:Implement persistant facebook session
	/*
	// on login, use the stored access token and see if it still works
		_facebook.accessToken = [defaults objectForKey:ACCESS_TOKEN_KEY];
    _facebook.expirationDate = [defaults objectForKey:EXPIRATION_DATE_KEY];
	
    // only authorize if the access token isn't valid
    // if it *is* valid, no need to authenticate. just move on
    if (![_facebook isSessionValid]) {
        [_facebook authorize:_permissions delegate:self];
    }
	 */
	
	[self.facebook authorize:self.facebookPermissions delegate:self];
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logoutFacebook {
	[self.facebook logout:self];
}


#pragma mark Sign Up

-(void)signUpWithUsername:(NSString *)username andPassword:(NSString *)aPassword {
	
	[[self sharedHud] setCaption:@"Creating Account..."];
	[[self sharedHud] setActivity:YES];
	[[self sharedHud] show];
	
	if (!self.authNetworkQueue) {
		self.authNetworkQueue = [ASINetworkQueue queue];
		[self.authNetworkQueue setDelegate:self];
		[self.authNetworkQueue setRequestDidFinishSelector:@selector(authRequestFinished:)];
		[self.authNetworkQueue setRequestDidFailSelector:@selector(authRequestFailed:)];
		[self.authNetworkQueue setQueueDidFinishSelector:@selector(authQueueFinished:)];
	}
	
	// Stop anything already in the queue
	[self.authNetworkQueue cancelAllOperations];
	
	
	
	ASIFormDataRequest *request = [ASIFormDataRequest signUpRequestWithUsername:username andPassword:aPassword andUser:self.currentUser];
	
	
	
	[self.authNetworkQueue addOperation:request];
	
	//Set the current password in an ivar so we can get it later
	self.password = aPassword;
	
	//Set the status of our user. We use this in the UI
	//CURRENT_USER.isAuthenticating = YES;
	
	//[self.loadingController showFullScreenLoadingWithMessage:@"Entering the Show" inController:self withYPosition:25 hidesButtons:YES];
	[self.authNetworkQueue go];
	
}

#pragma mark Request succeeded/failed and parsing

-(void)authRequestFinished:(ASIHTTPRequest *)request {

	
	//If we get http error code 422 then we have validation errors
	if (request.responseStatusCode == KHTMLCodeUnauthorized) {
		[self authRequestFailed:request];
		return;
	}
	
	//If we get http error code 422 then we have validation errors
	if (request.responseStatusCode == KHTMLCodeUnprocessableEntity) {
		[self authRequestFailed:request];
		return;
	}
	
	//Store our possibly signedup or logged in user in this var.
	User *user = nil;
	
	if ([request isRemoteRequestOfType:KRemoteRequestTypeLogin]) {
		
		NSString *response = [request responseString];
		NSLog(@"User Login Request suceeded");
		
		NSError *error = nil;
		
		if (user = (User *)[parser parseUserJson:response withError:&error]) {
			//... Handle success
			self.currentUser = user; //Will also remember this as the last logged in user
			
			[self saveAuthenticatedPasswordForCurrentUser];
			
			[[self sharedHud] setCaption:@"Login Successful"];
			[[self sharedHud] setActivity:NO];
			[[self sharedHud] setImage:[UIImage imageNamed:@"check"]];
			[[self sharedHud] update];
			[[self sharedHud] hideAfter:2.0];
			
			[self hideAuthenticationController]; //Reveal the app now..
		}
		else {
			
			[[self sharedHud] hide];
			[UIHelpers showAlertWithError:error];
			//self.currentUser = nil;
		}


	}
	else if ([request isRemoteRequestOfType:KRemoteRequestTypeSignUp]) {
		
		//... Handle success
		NSString *response = [request responseString];
		NSLog(@"User Sign Up Request suceeded");
		
		NSError *error = nil;
		
		
		if (user = (User *)[parser parseUserJson:response withError:&error]) {
			//... Handle success
			self.currentUser = user; //Will also remember this as the last logged in user

			[self saveAuthenticatedPasswordForCurrentUser];

			[[self sharedHud] setCaption:@"Sign Up Successful"];
			[[self sharedHud] setActivity:NO];
			[[self sharedHud] setImage:[UIImage imageNamed:@"check"]];
			[[self sharedHud] update];
			[[self sharedHud] hideAfter:2.0];
			
			[self hideAuthenticationController]; //Reveal the app now..

		}
		else {
			[[self sharedHud] hide];
			[UIHelpers showAlertWithError:error];
			
			//self.currentUser = nil;
		}
	}
	else if ([request isRemoteRequestOfType:KRemoteRequestTypeAutoLogin]) {
		
		//... Handle success
		NSString *response = [request responseString];
		NSLog(@"User Auto Login Request suceeded");
		
		NSError *error = nil;
		
		if (user = (User *)[parser parseUserJson:response withError:&error]) {
			//... Handle success
			self.currentUser = user; //Will also remember this as the last logged in user
			
		}
		else {
			[UIHelpers showAlertWithError:error];			
		}
	}
	
		 
}

-(void)authRequestFailed:(ASIHTTPRequest *)request {
	
	[[self sharedHud] hideAfter:1.0];

	
	//Checks the request to see if it's unauthorised. If it is then is displays the login dialogue.
	if ([self isUnauthorised:request])
		return;
	
	
	//Is it a validation error?
	if (request.responseStatusCode == KHTMLCodeUnprocessableEntity) {
		
		NSString *response = [request responseString];
		
		//parse the errors and add them to the error dictionary of request
		SBJsonParser *errorParser = [[SBJsonParser alloc] init];
		
		//Json class parses the json string and returns an array with dictionaries for each item
		NSDictionary *tempItem = [errorParser objectWithString:response error:NULL];
		[errorParser release];
		
		if (tempItem && [[tempItem allValues]count] > 0) {
			
			[UIHelpers handleValidationError:tempItem];
		}
		
		
	}
	else {
		//Create request - handle validations
		NSLog(@"Request failed");
		[UIHelpers showAlertWithError:[request error]];
	}
	
	
	
	
}

- (void)authQueueFinished:(ASINetworkQueue *)queue
{
	//Set the status of our user. We use this in the UI
	//CURRENT_USER.isAuthenticating = NO;
	
	NSLog(@"Queue finished");
}

#pragma mark DanKit Facebook Methods

-(Authentication *)saveFacebookAuthorizationForUser:(User *)user {
	
	if (user) {
		
			
		NSError *authError = nil;
		
		NSDictionary *authDict = [NSDictionary dictionaryWithObjectsAndKeys:self.facebook.accessToken,@"access_token",self.facebook.expirationDate,@"expiration_date",@"facebook", @"provider",nil];
		return [self.parser parseOauth:authDict forUser:user error:&authError];
		
	
	}
	else {
		return nil;
	}

	
}

#pragma mark Facebook Methods


/**
 * Make a Graph API Call to get information about the current logged in user.
 */
-(void)getFacebookUserInfo {
	[self.facebook requestWithGraphPath:@"me" andDelegate:self];
}

#pragma mark Facebook Delegates

- (void)fbDidLogin {
	NSLog(@"Facebook Logged In");
	
	//if we have a facebook user then auth them
	if (self.currentUser) {
		[self saveFacebookAuthorizationForUser:self.currentUser];
	}
	
	[[self sharedHud] setCaption:@"Getting Facebook Information"];
	[[self sharedHud] setActivity:YES];
	[[self sharedHud] update];
	
	[self getFacebookUserInfo];
	

	
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"Facebook did not Log In");

}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	NSLog(@"Facebook Logged Out");
}

#pragma mark FBRequestDelegate 

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	
	
	if ([request.url isEqualToString:@"https://graph.facebook.com/me"]) {
		//////////////
		//
		// If it's the users profile data
		//
		NSError *error = nil;
		User *user = nil;
		
		
		if (user = [self.parser parseFacebookUser:result forUser:nil withError:&error]) {
			
			//Save our successful oauth details before account is created so probably first time
			//TODO Move this into somewhere better. Might need to create user in signed in..
			
			if (!user.password) {
				[self saveFacebookAuthorizationForUser:user];
			}
			
			NSLog(@"Auth token = %@",[[user findAuthenticationWithProviderName:@"facebook"]accessToken]);
			
			[[self sharedHud] setCaption:@"Facebook Login Successful"];
			[[self sharedHud] setActivity:NO];
			[[self sharedHud] setImage:[UIImage imageNamed:@"check"]];
			[[self sharedHud] update];
			[[self sharedHud] hideAfter:2.0];
		
			self.currentUser = user;
			//Parsing success. If the user doens't have a password then take them to the signup page
			
			[self checkAuthentication];
			
			
		}
		else {
			
			[[self sharedHud] hideAfter:2.0];
			
			NSLog(@"Facebook Parsing failed");
			[UIHelpers showAlertWithError:error];
		}

		
	}
	
	
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	
	[[self sharedHud] hide];
	[UIHelpers showAlertWithError:error];
};




////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
	NSLog(@"publish successfully");
}



#pragma mark Singleton Methods
+ (id)sharedManager {
    @synchronized(self) {
        if(sharedUserManager == nil)
            sharedUserManager = [[super allocWithZone:NULL] init];
    }
    return sharedUserManager;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}

- (void)release {
    // never release
}

- (id)autorelease {
    return self;
}

#pragma mark -


@end