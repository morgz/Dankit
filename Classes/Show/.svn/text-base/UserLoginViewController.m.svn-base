//
//  UserLoginController.m
//  splashpath
//
//  Created by Daniel Morgan on 26/05/2010.
//  Copyright 2010 Kinkub. All rights reserved.
//

#import "UserLoginViewController.h"
#import "UIHelpers.h"
#import "UserManager.h"
#import "User.h"

@implementation UserLoginViewController
@synthesize usernameField;
@synthesize passwordField;
@synthesize theTableView;
@synthesize username;
@synthesize password;
@synthesize navBar;


- (void)dealloc {
  
	[navBar release];
	[usernameField release];
	[passwordField release];
	[theTableView release];
	[username release];
	[password release];
	[super dealloc];

}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	
	self.navBar.topItem.title = @"Login";
    self.theTableView.allowsSelection = NO;
	self.theTableView.scrollEnabled = NO;
	//self.theTableView.backgroundColor = [UIColor clearColor];
	self.theTableView.separatorColor = [UIColor colorWithWhite:0 alpha:0.2];
	
	//Spacer
	UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 15)];
	[headerView setBackgroundColor:[UIColor clearColor]];
	self.theTableView.tableHeaderView = headerView;
	[headerView release];
	
	
	
    self.usernameField = [self newUsernameField];
    [self.usernameField becomeFirstResponder];
    self.passwordField = [self newPasswordField];

	
	UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] 
							  initWithTitle:@"Login"
							  style:UIBarButtonItemStyleBordered
							  target:self 
							  action:@selector(login)];
	
	self.navBar.topItem.rightBarButtonItem = loginButton;
	[loginButton release];
		
	self.navBar.topItem.leftBarButtonItem = [UIHelpers newCancelButton:self];

    
}

- (void)viewDidAppear:(BOOL)animated {
	
	//////////////
	//
	// Set the fields if we have partial info
	//
	
	User *currentUser = [[UserManager sharedManager]currentUser];
	
	//TODO: remove this
	if (currentUser) {
		self.usernameField.text = currentUser.email;
		self.passwordField.text = currentUser.password;
	}
}

#pragma mark Action methods

- (IBAction)cancel {
	
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)login {
	
	[self.usernameField resignFirstResponder];
	[self.passwordField resignFirstResponder];
	
	//This will either create or update our user depending on whther they exist or not.
	self.username = self.usernameField.text;
	self.password = self.passwordField.text;
	
	[[UserManager sharedManager]loginWithUsername:self.username andPassword:self.password];	

	
}

#pragma mark -
#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section {
    return 2;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	UIView *footerView =[[[UIView alloc] init]autorelease];
    [footerView setBackgroundColor:[UIColor clearColor]];
	
	UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 280, 60)];
	title.font = [UIFont boldSystemFontOfSize:14];
	title.backgroundColor = [UIColor clearColor];
	title.textColor = [UIColor colorWithWhite:0 alpha:0.5];
	title.shadowColor = [UIColor whiteColor];
	title.shadowOffset = CGSizeMake(0, 1);
	title.numberOfLines = 3;
	title.textAlignment = UITextAlignmentCenter;
	
	title.text = @"\nEnter the email and password for your account.";
		
	[footerView addSubview:title];
	[title release];
	
	return footerView;
	
	
}

//- (NSString *)tableView:(UITableView *)tableView 
//titleForFooterInSection:(NSInteger)section {
//    return @"\nEnter the username and password for your Splashpath account.";
//}



- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    UITableViewCell *cell = 
	[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
							reuseIdentifier:nil] autorelease];
    
    if (indexPath.row == 0)  {
        [cell.contentView addSubview:self.usernameField];	
    } else { 
        [cell.contentView addSubview:self.passwordField];	
    }
    
    return cell;
}



#pragma mark Table Cell textfields

- (UITextField *)newUsernameField {
    UITextField *field = [UIHelpers newTableCellTextField:self];
    field.placeholder = @"Email";
    //field.text = CURRENT_USER.username;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.returnKeyType = UIReturnKeyNext;
    [field addTarget:self 
              action:@selector(textFieldChanged:) 
    forControlEvents:UIControlEventEditingChanged];
    return field;
}

- (UITextField *)newPasswordField {
    UITextField *field = [UIHelpers newTableCellTextField:self];
    field.placeholder = @"Password";
    //field.text = CURRENT_USER.password;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.autocorrectionType = UITextAutocorrectionTypeNo;
    field.secureTextEntry = YES;
    field.returnKeyType = UIReturnKeyDone;
	field.enablesReturnKeyAutomatically = YES;
    [field addTarget:self 
              action:@selector(textFieldChanged:) 
    forControlEvents:UIControlEventEditingChanged];
    return field;
}

#pragma mark - 
#pragma mark Text Field Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if (textField == usernameField) {
        [passwordField becomeFirstResponder];
    }
	else if (textField == passwordField) {
		
		if ((passwordField.text.length != 0) && (usernameField.text.length != 0)) {
			[self login];
		}
		else {
			return NO;
		}
		
    }
	else {
		[textField resignFirstResponder];
	}

	
	return YES;
	
}

- (IBAction)textFieldChanged:(id)sender {
    BOOL enableButton = ([self.usernameField.text length] > 0) && ([self.passwordField.text length] > 0);
	[self.navigationItem.rightBarButtonItem setEnabled:enableButton];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end
