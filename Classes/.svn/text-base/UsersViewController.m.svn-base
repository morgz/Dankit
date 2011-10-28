//
//  UsersViewController.m
//  DanKit
//
//  Created by Daniel Morgan on 03/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UsersViewController.h"
#import "UserGridViewCell.h"

@implementation UsersViewController
@synthesize gridView;
@synthesize users;

- (void)dealloc {
	[users release];
	[gridView release];
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
- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // grid view sits on top of the background image
    gridView = [[AQGridView alloc] initWithFrame: self.view.bounds];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.gridView.backgroundColor = [UIColor blackColor];
    self.gridView.opaque = NO;
    self.gridView.dataSource = self;
    self.gridView.delegate = self;
    self.gridView.scrollEnabled = YES;
	
	[self.view addSubview:self.gridView];
	
	[self.gridView reloadData];
	
	
}

- (void)viewDidAppear:(BOOL)animated {

	[[UserManager sharedManager] getRemoteUserDataFor:@"users.json" withCallbackController:self];
	
}

-(void)remoteRequestFinished {
	
	self.users = [User allSortedBy:nil];
	[self.gridView reloadData];
}

-(void)remoteRequestFailed {
	
	
}

#pragma mark -
#pragma mark GridView Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return self.users.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UserGridViewCell *cell = (UserGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (!cell){
		cell = [[[UserGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 75, 75) reuseIdentifier: CellIdentifier] autorelease];
		cell.selectionGlowColor = [UIColor blueColor];
	}
	
	//cell.imageView.backgroundColor = [UIColor blueColor];
	cell.image = [UIImage imageNamed:@"driver_placeholder_large"];
	
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return CGSizeMake(80, 80);
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
