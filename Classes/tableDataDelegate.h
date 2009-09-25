//
//  txtEditAppDelegate.h
//  txtEdit 0.2
//
//  Created by Evgeniy Krysanov on 22.08.08.
//  Copyright PyObjC.ru - 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@class ViewController;
@class txtEditViewController, Record;

@interface tableDataDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
    IBOutlet UINavigationController *navController;
	sqlite3 *database;
    NSMutableArray *records;
	ViewController *mviewController;
	NSString *hash;
	NSString *db;
	NSString *username;
	NSString *writableDBPath;
}



@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) NSMutableArray *records;
@property (nonatomic, retain) ViewController *mviewController;
@property (nonatomic, retain) NSString *hash;
@property (nonatomic, retain) NSString *db;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *writableDBPath;

-(void)createEditableCopyOfDatabaseIfNeeded;
-(void)initializeDatabase;
-(void)updateOrAddRecordIntoDatabase:(Record *)record;


@end


