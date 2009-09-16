//
//  EditViewController.m
//  SQL
//
//  Created by Jai Kirdatt on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "EditViewController.h"


@implementation EditViewController

@synthesize objectToEdit, keyOfTheFieldToEdit, editValue;

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:YES];
	
	self.title = [self.keyOfTheFieldToEdit capitalizedString];
	txtField.placeholder = [self.keyOfTheFieldToEdit capitalizedString];
	
	txtField.text = self.editValue;
	
	[txtField becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[txtField release];
	[editValue release];
	[keyOfTheFieldToEdit release];
	[objectToEdit release];
    [super dealloc];
}

- (IBAction) save_Clicked:(id)sender {
	
	//Update the value.
	//Invokes the set<Key> method defined in the Coffee Class.
	[objectToEdit setValue:txtField.text forKey:self.keyOfTheFieldToEdit];
	
	//Pop back to the detail view.
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) cancel_Clicked:(id)sender {
	
	[self.navigationController popViewControllerAnimated:YES];
}


@end
