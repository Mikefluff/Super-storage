//
//  AddViewController.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "AddViewController.h"
#import "Users.h"
#import "PickerViewController.h"

@implementation AddViewController


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Add User";
 
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											   target:self action:@selector(cancel_Clicked:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
											   target:self action:@selector(save_Clicked:)] autorelease];
	
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
 }


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//Set the textboxes to empty string.
	txtUserName.text = @"";
	txtPassword.text = @"";
	
	//Make the coffe name textfield to be the first responder.
	[txtUserName becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (void) save_Clicked:(id)sender {
	
	Super_storageAppDelegate *appDelegate = (Super_storageAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//Create a Coffee Object.
	Users *userObj = [[Users alloc] initWithPrimaryKey:0];
	userObj.userName = txtUserName.text;
	userObj.password = txtPassword.text;
	userObj.isDirty = NO;
	userObj.isDetailViewHydrated = YES;
	
	//Add the object
	[appDelegate addUser:userObj];
	
	//Dismiss the controller.
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) cancel_Clicked:(id)sender {
	
	//Dismiss the controller.
	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	
	[theTextField resignFirstResponder];
	return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)theTextField {
//   return NO;
}
-(void) showPicker:(id)sender {
		// Add the picker
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"test"
													  delegate:self
											 cancelButtonTitle:@"Done"
										destructiveButtonTitle:@"Cancel"
											 otherButtonTitles:nil];
	if(picker == nil)
		picker = [[PickerViewController alloc] initWithNibName:@"PickerView" bundle:nil];
	
	[menu addSubview:picker.view];
	[menu showInView:self.view];
	[menu setBounds:CGRectMake(0,0,320, 200)];
	

	[menu release];
	
}
- (void)dealloc {
	[txtUserName release];
	[txtPassword release];
    [super dealloc];
}


@end
