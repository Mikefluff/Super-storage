//
//  EditViewController.h
//  SQL
//
//  Created by Jai Kirdatt on 11/1/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditViewController : UIViewController {
	
	IBOutlet UITextField *txtField;
	NSString *keyOfTheFieldToEdit;
	NSString *editValue;
	id objectToEdit;
}

@property (nonatomic, retain) id objectToEdit;
@property (nonatomic, retain) NSString *keyOfTheFieldToEdit;
@property (nonatomic, retain) NSString *editValue;

- (IBAction) save_Clicked:(id)sender;
- (IBAction) cancel_Clicked:(id)sender;

@end
