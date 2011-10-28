//
//  UserAuthenticationViewController.h
//  DanKit
//
//  Created by Daniel Morgan on 01/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSignUpViewController.h"
#import "UserLoginViewController.h"
#import "UserManager.h"

@interface UserAuthenticationViewController : UIViewController {

	UserSignUpViewController *signUpController;
	UserLoginViewController *loginController;
	
	UINavigationBar *navBar;
	
}

@property (nonatomic, retain) UserSignUpViewController *signUpController;
@property (nonatomic, retain) UserLoginViewController *loginController;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

-(void)showLoginAnimated:(BOOL)animated;
-(void)showSignUpAnimated:(BOOL)animated;
-(IBAction)login;
-(IBAction)SignUpWithFacebook;
-(IBAction)SignUpWithoutFacebook;



@end
