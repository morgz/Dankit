//
//  UserManager.h
//  DanKit
//
//  Created by Daniel Morgan on 29/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "FBConnect.h"

@class User;
@class ASINetworkQueue;
@class UserParser;
@class Authentication;
@interface UserManager : NSObject <ASIHTTPRequestDelegate, FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {

	//The current user who is interacting with the application
	User *currentUser;
	
	UserParser *parser;
	//Network queue for performing core user functions such as login/logout/signup
	ASINetworkQueue *authNetworkQueue;
	ASINetworkQueue *userDataNetworkQueue;
	
	Facebook* facebook;
	NSArray* facebookPermissions;
	
	NSString *password;
	

}

@property (nonatomic, retain) User *currentUser;
@property (nonatomic, retain) UserParser *parser;
@property (nonatomic, retain) ASINetworkQueue *authNetworkQueue; 
@property (nonatomic, retain) ASINetworkQueue *userDataNetworkQueue;

@property (nonatomic, retain) Facebook *facebook;
@property (nonatomic, retain) NSArray *facebookPermissions;
@property (nonatomic, copy) NSString *password;

+ (id)sharedManager;



//////////////
//
// Data Methods
//
-(void)getRemoteUserDataFor:(NSString *)url withCallbackController:(UIViewController *)callbackController;
-(void)userDataRequestFinished:(ASIHTTPRequest *)request;
-(void)userDataRequestFailed:(ASIHTTPRequest *)request;
-(void)userDataQueueFinished:(ASINetworkQueue *)queue;

//////////////
//
// Login/Signup methods
//

-(void)checkAuthentication;

//Called after successful login or signup to save the authorized pass as this doens't
//come back in our json
-(void)saveAuthenticatedPasswordForCurrentUser;

//Saves the facebook access token in the user after succesful facebook login.
-(Authentication *)saveFacebookAuthorizationForUser:(User *)user;

//Tries to login the user with the remote site.
-(void)loginFacebook;
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password;
-(void)signUpWithUsername:(NSString *)username andPassword:(NSString *)password;

-(void)autoLoginWithCurrentUser;

-(void)authRequestFinished:(ASIHTTPRequest *)request;
-(void)authRequestFailed:(ASIHTTPRequest *)request;
-(void)authQueueFinished:(ASINetworkQueue *)queue;

//////////////
//
// Facebook methods
//

-(void)getFacebookUserInfo;


@end
