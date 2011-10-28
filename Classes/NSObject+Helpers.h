//
//  NSObject+Hud.h
//  DanKit
//
//  Created by Daniel Morgan on 29/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "DanKitAppDelegate.h"
#import "ATMHud.h"
#import "ASIHTTPRequest.h"
#import "UserManager.h"
#import "ASIHTTPRequest+DanKit.h" 
#import "UIHelpers.h"

@interface NSObject (Helpers) 

-(ATMHud *)sharedHud;
-(void)challengeAuthenticationShowLogin:(BOOL)login orShowSignUp:(BOOL)signup;
-(void)hideAuthenticationController;

-(BOOL)isUnauthorised:(ASIHTTPRequest *)request;

@end
