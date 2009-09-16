//
//  RootViewController.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class Users, AddViewController, DetailViewController, PickerViewController;

@interface RootViewController : UITableViewController {
	
	Super_storageAppDelegate *appDelegate;
	PickerViewController *avController;
	DetailViewController *dvController;
	UINavigationController *addNavigationController;
	BOOL edit;
}
- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;
@end
