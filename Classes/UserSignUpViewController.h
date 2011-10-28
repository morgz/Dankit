//
//  UserSignUpViewController.h
//  Show
//
//  Created by Daniel Morgan on 19/11/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSignUpViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
	
	UINavigationBar *navBar;
	
	UITextField *usernameField;
	UITextField *passwordField;
	
	NSString *username;
	NSString *password;
	
	UITableView *theTableView;
	
}

@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;

@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;


@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;


-(IBAction)signUp;


- (UITextField *)newPasswordField;
- (UITextField *)newUsernameField;

@end
