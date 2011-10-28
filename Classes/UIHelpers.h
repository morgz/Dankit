#import <Foundation/Foundation.h>

@interface UIHelpers : NSObject

+ (UIBarButtonItem *)newCancelButton:(id)target;
+ (UIBarButtonItem *)newSaveButton:(id)target;
+ (UIBarButtonItem *)newSignUpButton:(id)target;
+ (UIBarButtonItem *)newLoginButton:(id)target;
+ (UIBarButtonItem *)newCreateButton:(id)target;
+ (UIBarButtonItem *)newRefreshButton:(id)target;
+ (UIBarButtonItem *)newMapButton:(id)target;
+ (UIBarButtonItem *)newDoneButton:(id)target;


+ (UITextField *)newTableCellTextField:(id)delegate;

+ (void)showAlert:(NSString *)title withMessage:(NSString *)message;
+ (void)showAlertWithError:(NSError *)error;
+ (void)handleRemoteError:(NSError *)error;
+ (void)showLoginFailedAlert;

//specific to our rails validation errors json representation
+ (void)handleValidationError:(NSDictionary *)errorDictionary;

+ (NSError *)appErrorWithCode:(NSInteger)code andDescription:(NSString *)errorDescription;


@end
