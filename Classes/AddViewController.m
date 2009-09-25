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
#import "md5.h"
#import "tableDataDelegate.h"

@implementation AddViewController


// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = @"Add User";
 
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] 
											  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
											   target:self action:@selector(cancel_Clicked:)] autorelease];
	
	self.navigationItem.rightBarButtonItem = nil;
	
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	//control form
	
	
	
	
 }


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//Set the textboxes to empty string.
	txtUserName.text = @"";
	txtPassword.text = @"";
	
	//Make the coffe name textfield to be the first responder.
	[txtUserName becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated {
[picker.view removeFromSuperview];
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
	userObj.password = [picker.secret md5sum];
	tableDataDelegate *tabledata = [tableDataDelegate alloc];
	tabledata.db = txtUserName.text;
	tabledata.hash = [picker.secret md5sum];
	[tabledata createEditableCopyOfDatabaseIfNeeded];
	userObj.isDirty = NO;
	userObj.isDetailViewHydrated = YES;
	
	//Add the object
	[appDelegate addUser:userObj];
	
	//Dismiss the controller.
	
 	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) cancel_Clicked:(id)sender {
	
	//Dismiss the controller.
	[picker.view removeFromSuperview];
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
	if (txtUserName.text.length != 0)
	{
	[txtUserName resignFirstResponder];
	if(picker == nil)
		picker = [[PickerViewController alloc] initWithNibName:@"PickerView" bundle:nil];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
	[self.view addSubview:picker.view];
	[UIView commitAnimations];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
		  initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
		  target:self action:@selector(save_Clicked:)] autorelease];
	}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Enter Username!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
		[alert release];
	}
		
	
}
- (void)dealloc {
	[txtUserName release];
	[txtPassword release];
    [super dealloc];
}


@end
