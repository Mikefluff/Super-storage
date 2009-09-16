//
//  DetailViewController.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class Users, EditViewController;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate> {

	IBOutlet UITableView *tableView;
	Users *userObj;
	NSIndexPath *selectedIndexPath;
	EditViewController *evController;
	
	UIImagePickerController *imagePickerView;
}

@property (nonatomic, retain) Users *userObj;

@end
