//
//  AddViewController.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class Users, PickerViewController;

@interface AddViewController : UIViewController {

	IBOutlet UITextField *txtUserName;
	IBOutlet UITextField *txtPassword;
	PickerViewController *picker;
}

-(void) showPicker:(id)sender;

@end
