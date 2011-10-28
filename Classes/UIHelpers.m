#import "UIHelpers.h"

@implementation UIHelpers

+ (UIBarButtonItem *)newCancelButton:(id)target {
    return [[[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
            target:target 
            action:@selector(cancel)]autorelease];    
}

+ (UIBarButtonItem *)newSaveButton:(id)target {
    return [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemSave
            target:target 
            action:@selector(save)];    
}

+ (UIBarButtonItem *)newSignUpButton:(id)target {
    return [[UIBarButtonItem alloc] 
            initWithTitle:@"Sign Up"
			style:UIBarButtonItemStyleDone
            target:target 
            action:@selector(showSignUp)];    
}

+ (UIBarButtonItem *)newLoginButton:(id)target {
    return [[UIBarButtonItem alloc] 
            initWithTitle:@"Login"
			style:UIBarButtonItemStyleBordered
            target:target 
            action:@selector(login)];    
}

+ (UIBarButtonItem *)newCreateButton:(id)target {
    return [[UIBarButtonItem alloc] 
            initWithTitle:@"Create"
			style:UIBarButtonItemStyleDone
            target:target 
            action:@selector(create)];    
}

+ (UIBarButtonItem *)newDoneButton:(id)target {
    return [[UIBarButtonItem alloc] 
            initWithTitle:@"Done"
			style:UIBarButtonItemStyleDone
            target:target 
            action:@selector(done)]; 	
}

+ (UIBarButtonItem *)newRefreshButton:(id)target {
	return [[UIBarButtonItem alloc] 
            initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
            target:target 
            action:@selector(refreshRemoteData)];  
}

+ (UIBarButtonItem *)newMapButton:(id)target {
    return [[UIBarButtonItem alloc] 
            initWithTitle:@"Map"
			style:UIBarButtonItemStyleDone
            target:target 
            action:@selector(showMap)]; 
}

+ (UITextField *)newTableCellTextField:(id)delegate {
    UITextField *textField = 
        [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 250, 25)];
    textField.font = [UIFont systemFontOfSize:16];
    textField.delegate = delegate;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearsOnBeginEditing = NO;
	textField.tag = KTextFieldTag;
    return textField;
}   

+ (void)showAlert:(NSString *)title withMessage:(NSString *)message {
	UIAlertView *alert = 
        [[UIAlertView alloc] initWithTitle:title 
                                   message:message
                                  delegate:nil 
                         cancelButtonTitle:@"OK" 
                         otherButtonTitles:nil];
    [alert show];
	[alert release];
}

+ (void)showAlertWithError:(NSError *)error {
    NSString *message = 
        [NSString stringWithFormat:@"Sorry, %@", [error localizedDescription]];
    [self showAlert:@"Error" withMessage:message];
}

+ (void)showLoginFailedAlert {

    [self showAlert:@"Login Failed" withMessage:@"Please check your username and password."];
}


+ (void)handleRemoteError:(NSError *)error {
	
	
    if ([error code] == 401) {
        [self showAlert:@"Login Failed" 
            withMessage:@"Please check your username and password, and try again."];
	}
	else if ([error code] == 422) {
		//unprocessable entity
		NSArray *errorMessages = [[error userInfo]objectForKey:@"NSLocalizedRecoveryOptions"];
		NSMutableString *errorMessage = [[[NSMutableString alloc]init]autorelease];
		
		for (int count = 0; count < errorMessages.count; count++) {
			
			
			//Add a return if it's more than the first line
			if (count > 0) {
				[errorMessage appendString:@"\n- "];
			}
			else {
				//Add a dash for bullet point look
				[errorMessage appendString:@"- "];
			}

			NSString *errorString = [errorMessages objectAtIndex:count];
			//Just capitalize the first letter of the string
			[errorMessage appendString:[errorString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[errorString substringToIndex:1] capitalizedString]]];
			
		}
		
		[self showAlert:@"Login Failed" withMessage:errorMessage];
		
	}
    else {
        [self showAlertWithError:error];
    }
}

+ (void)handleValidationError:(NSDictionary *)errorDictionary {
  
	
	NSMutableString *errorMessage = [[[NSMutableString alloc]init]autorelease];
	
	
	NSArray *keys = [errorDictionary allKeys];
	
	for (int count = 0; count < [keys count]; count++) {
		
		NSString *errorKey = [keys objectAtIndex:count];
		//Add a return if it's more than the first line
		if (count > 0) {
			[errorMessage appendString:@"\n"];
		}
		
		NSString *errorDescription = [errorDictionary objectForKey:errorKey];
		
		[errorMessage appendString:[errorKey stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[errorKey substringToIndex:1] capitalizedString]]];
		[errorMessage appendString:@": "];
		[errorMessage appendString:[errorDescription stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[errorDescription substringToIndex:1] capitalizedString]]];
 
		//Just capitalize the first letter of the string
		//[errorMessage appendString:[errorString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[errorString substringToIndex:1] capitalizedString]]];
		
	}
	
	
		
	[self showAlert:@"Incorrect Details" withMessage:errorMessage];
		
	
}

#pragma mark Errors

+ (NSError *)appErrorWithCode:(NSInteger)code andDescription:(NSString *)errorDescription {
	
	
	NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
	[errorDetail setValue:errorDescription forKey:NSLocalizedDescriptionKey];
	NSError *error = [NSError errorWithDomain:KAppErrorDomain code:code userInfo:errorDetail];
	
	return error;
	
}



@end
