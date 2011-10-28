//
//  UserLoginController.h
//  splashpath
//
//  Created by Daniel Morgan on 26/05/2010.
//  Copyright 2010 Kinkub. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LoadingFullScreenViewController;

@interface UserLoginViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {

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


-(void)login;

- (UITextField *)newPasswordField;
- (UITextField *)newUsernameField;

@end

