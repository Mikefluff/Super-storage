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
static sqlite3 *database = nil;
@implementation Super_storageAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize usersArray;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	//Copy database to the user's phone if needed.
	[self createDatabaseIfNeeded];
	
	//Initialize the coffee array.
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.usersArray = tempArray;
	[tempArray release];
	
	//Once the db is copied, get the initial data to display on the screen.
	[Users getInitialDataToDisplay:[self getDBPath]];
	
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
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath]; 
    NSString *res;
    
	NSString *hash;
	UIDevice *myDevice = [UIDevice currentDevice];
	hash = [myDevice uniqueIdentifier];
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
    if (!success) {
        NSAssert1(NO, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
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
