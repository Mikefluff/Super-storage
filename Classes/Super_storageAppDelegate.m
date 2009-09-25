//
//  SQLAppDelegate.m
//  SQL
//
//  Created by iPhone SDK Articles on 10/26/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "Super_storageAppDelegate.h"
#import "RootViewController.h"
#import "Users.h"
#import "md5.h"
#import <sqlite3.h>

static sqlite3 *database = nil;
@implementation Super_storageAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize usersArray;
@synthesize records;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	//Copy database to the user's phone if needed.
	[self createDatabaseIfNeeded];
	
	//Initialize the coffee array.
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	NSMutableArray *tempArray1 = [[NSMutableArray alloc] init];
	self.usersArray = tempArray;
	self.records = tempArray1;
	
	[tempArray release];
	[tempArray1 release];
	//Once the db is copied, get the initial data to display on the screen.
	[Users getInitialDataToDisplay:[self getDBPath]];
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:YES];
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	
	//Save all the dirty coffee objects and free memory.
	[self.usersArray makeObjectsPerformSelector:@selector(saveAllData)];
	
	[Users finalizeStatements];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    //Save all the dirty coffee objects and free memory.
	[self.usersArray makeObjectsPerformSelector:@selector(saveAllData)];
}

- (void)dealloc {
	[usersArray release];
	[navigationController release];
	[window release];
	[super dealloc];
}

-(void)createDatabaseIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
    NSString *res;
    
	NSString *hash = [[NSString alloc] initWithString:@"PRAGMA KEY = '"];
	UIDevice *myDevice = [UIDevice currentDevice];
	hash = [[hash stringByAppendingString:[[myDevice uniqueIdentifier] md5sum]] stringByAppendingString:@"'"];
		// Если целевой файл уже существует, то не затираем его и выходим из метода
    success = [fileManager fileExistsAtPath:dbPath];
    if (success) return;
    else {
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		sqlite3_exec(database, [hash UTF8String], NULL, NULL, NULL);
		if (sqlite3_exec(database, (const char*) "CREATE TABLE Users('userID' INTEGER PRIMARY KEY, 'username' TEXT, 'password' TEXT, 'image' BLOB);", NULL, NULL, NULL) == SQLITE_OK) {
			res = @"password is correct, or, database has been initialized";
		} else {
			res = @"incorrect password!";
		}}
	}
	sqlite3_close(database);
    
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"system.sqlite"];
}

- (void) removeUser:(Users *)userObj {
	
	//Delete it from the database.
	[userObj deleteUser];
	
	//Remove it from the array.
	[usersArray removeObject:userObj];
}

- (void) addUser:(Users *)userObj {
	
	//Add it to the database.
	[userObj addUser];
	
	//Add it to the coffee array.
	[usersArray addObject:userObj];
}

@end
