//
//  UserAuthenticationViewController.m
//  DanKit
//
//  Created by Daniel Morgan on 01/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserAuthenticationViewController.h"


@implementation UserAuthenticationViewController
@synthesize signUpController;
@synthesize loginController;
@synthesize navBar;

- (void)dealloc {
	[signUpController release];
	[loginController release];
	[navBar release];
	
    [super dealloc];
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	self.navBar.topItem.title = @"DanKit";


}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark Actions

-(IBAction)login {
	
	[self showLoginAnimated:YES];
	
}


-(void)showLoginAnimated:(BOOL)animated {
	
	if (!self.loginController) {
		
		loginController = [[UserLoginViewController alloc]initWithNibName:@"UserLoginViewController" bundle:nil];
	}
	
	[self presentModalViewController:loginController animated:animated];
	
}


-(void)showSignUpAnimated:(BOOL)animated {
	
	if (!self.signUpController) {
		
		signUpController = [[UserSignUpViewController alloc]initWithNibName:@"UserSignUpViewController" bundle:nil];
	}
	
	[self presentModalViewController:signUpController animated:animated];
}


-(IBAction)SignUpWithFacebook {
	
	[[UserManager sharedManager]loginFacebook];
}

-(IBAction)SignUpWithoutFacebook {
	
	[self showSignUpAnimated:YES];

}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end
