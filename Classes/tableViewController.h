//
//  mainViewController.h
//  txtEdit 0.2
//
//  Created by Evgeniy Krysanov on 22.08.08.
//  Copyright PyObjC.ru - 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>

@class txtEditViewController;
@class OverlayViewController;

@interface tableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *listView;
	txtEditViewController *txtViewController;
	NSMutableArray *copylistOfItems;
	BOOL searching;
	BOOL letUserSelectRow;
	OverlayViewController *ovController;
	NSString *search;
	IBOutlet UISearchBar *searchb;
	}

@property (nonatomic, retain) UITableView *listView;
@property (nonatomic, retain) NSMutableArray *copylistOfItems;
@property (nonatomic, retain) NSString *search;
@property (nonatomic, retain) UISearchBar *searchb;


- (void)button:(id)sender;
- (void) searchTableView;
- (void) doneSearching_Clicked:(id)sender;
- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;

@end
