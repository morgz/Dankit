//
//  UsersViewController.h
//  DanKit
//
//  Created by Daniel Morgan on 03/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"


@interface UsersViewController : UIViewController <AQGridViewDataSource, AQGridViewDelegate> {

	AQGridView *gridView;
	
	NSMutableArray *users;
}

@property (nonatomic, retain) AQGridView *gridView;
@property (nonatomic, retain) NSMutableArray *users;


//////////////
//
// Remote request callbacks
//
-(void)remoteRequestFinished;
-(void)remoteRequestFailed;

@end
