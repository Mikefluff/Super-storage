//
//  RootViewController.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class Users, AddViewController, DetailViewController, PickerViewController;

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
	
	Super_storageAppDelegate *appDelegate;
	IBOutlet UITableView *tableView;
	AddViewController *avController;
	DetailViewController *dvController;
	PickerViewController *picker;
	UINavigationController *addNavigationController;
	BOOL edit;
}

@property (nonatomic, retain) UITableView *tableView;
- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;
- (void)button:(id)sender;
- (void)button2:(id)sender;
@end
