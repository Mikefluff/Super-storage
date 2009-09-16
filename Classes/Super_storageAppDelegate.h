//
//  SQLAppDelegate.h
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class Users;

@interface Super_storageAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
	
	//To hold a list of Coffee objects
	NSMutableArray *usersArray;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, retain) NSMutableArray *usersArray;

- (void) createDatabaseIfNeeded;
- (NSString *) getDBPath;

- (void) removeUser:(Users *)userObj;
- (void) addUser:(Users *)userObj;

@end

