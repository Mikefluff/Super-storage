//
//  Users.m
//  Super-storage
//
//  Created by Mike Fluff on 14.09.09.
//  Copyright 2009 Altell ltd. All rights reserved.
//

#import "Users.h"
#import <sqlite3.h>
#import "md5.h"

static sqlite3 *database = nil;
static sqlite3_stmt *deleteStmt = nil;
static sqlite3_stmt *addStmt = nil;
static sqlite3_stmt *detailStmt = nil;
static sqlite3_stmt *updateStmt = nil;


@implementation Users

@synthesize userID, userName, password, isDirty, isDetailViewHydrated, userImage;

+ (void) getInitialDataToDisplay:(NSString *)dbPath {
	
	Super_storageAppDelegate *appDelegate = (Super_storageAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		NSString *hash = [[NSString alloc] initWithString:@"PRAGMA KEY = '"];
		UIDevice *myDevice = [UIDevice currentDevice];
		hash = [[hash stringByAppendingString:[[myDevice uniqueIdentifier] md5sum]] stringByAppendingString:@"'"];
		sqlite3_exec(database, [hash UTF8String], NULL, NULL, NULL);
		const char *sql = "select userID, username from Users";
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				
				NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
				Users *userObj = [[Users alloc] initWithPrimaryKey:primaryKey];
				userObj.userName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				
				userObj.isDirty = NO;
				
				[appDelegate.usersArray addObject:userObj];
				[userObj release];
			}
		}
	}
	else
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
}
+ (void) finalizeStatements {
	
	if (database) sqlite3_close(database);
	if (deleteStmt) sqlite3_finalize(deleteStmt);
	if (addStmt) sqlite3_finalize(addStmt);
	if (detailStmt) sqlite3_finalize(detailStmt);
	if (updateStmt) sqlite3_finalize(updateStmt);
}
- (id) initWithPrimaryKey:(NSInteger) pk {
	
	[super init];
	userID = pk;
	
	userImage = [[UIImage alloc] init];
	isDetailViewHydrated = NO;
	
	return self;
}
- (void) deleteUser {
	
	if(deleteStmt == nil) {
		const char *sql = "delete from Users where userID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &deleteStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(database));
	}
	
	//When binding parameters, index starts from 1 and not zero.
	sqlite3_bind_int(deleteStmt, 1, userID);
	
	if (SQLITE_DONE != sqlite3_step(deleteStmt)) 
		NSAssert1(0, @"Error while deleting. '%s'", sqlite3_errmsg(database));
	
	sqlite3_reset(deleteStmt);
}
- (void) addUser {
	
	if(addStmt == nil) {
		const char *sql = "insert into Users(username, password) Values(?, ?)";
		if(sqlite3_prepare_v2(database, sql, -1, &addStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_bind_text(addStmt, 1, [userName UTF8String], -1, SQLITE_TRANSIENT);
	sqlite3_bind_text(addStmt, 2, [password UTF8String], -1, SQLITE_TRANSIENT);
	
	if(SQLITE_DONE != sqlite3_step(addStmt))
		NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(database));
	else
		//SQLite provides a method to get the last primary key inserted by using sqlite3_last_insert_rowid
		userID = sqlite3_last_insert_rowid(database);
	
	//Reset the add statement.
	sqlite3_reset(addStmt);
}
- (void) hydrateDetailViewData {
	
	//If the detail view is hydrated then do not get it from the database.
	if(isDetailViewHydrated) return;
	
	if(detailStmt == nil) {
		const char *sql = "Select password, image from Users Where userID = ?";
		if(sqlite3_prepare_v2(database, sql, -1, &detailStmt, NULL) != SQLITE_OK)
			NSAssert1(0, @"Error while creating detail view statement. '%s'", sqlite3_errmsg(database));
	}
	
	sqlite3_bind_int(detailStmt, 1, userID);
	
	if(SQLITE_DONE != sqlite3_step(detailStmt)) {
		
		//Get the price in a temporary variable.
	//	NSString *passwordDN = [[NSString alloc] initWithString:sqlite3_column_text(detailStmt, 0)];
		
		//Assign the price. The price value will be copied, since the property is declared with "copy" attribute.
		self.password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(detailStmt, 0)];		
		NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(detailStmt, 1) length:sqlite3_column_bytes(detailStmt, 1)]; 
		
		if(data == nil)
			NSLog(@"No image found.");
		else
			self.userImage = [UIImage imageWithData:data]; 
		
		//Release the temporary variable. Since we created it using alloc, we have own it.
		
	}
	else
		NSAssert1(0, @"Error while getting the price of coffee. '%s'", sqlite3_errmsg(database));
	
	//Reset the detail statement.
	sqlite3_reset(detailStmt);
	
	//Set isDetailViewHydrated as YES, so we do not get it again from the database.
	isDetailViewHydrated = YES;
}

- (void) saveAllData {
	
	if(isDirty) {
		
		if(updateStmt == nil) {
			const char *sql = "update Users Set usersname = ?, password = ?, image = ? Where userID = ?";
			if(sqlite3_prepare_v2(database, sql, -1, &updateStmt, NULL) != SQLITE_OK) 
				NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
		}
		
		sqlite3_bind_text(updateStmt, 1, [userName UTF8String], -1, SQLITE_TRANSIENT);
		sqlite3_bind_text(updateStmt, 2, [password UTF8String], -1, SQLITE_TRANSIENT);
		
		NSData *imgData = UIImagePNGRepresentation(self.userImage);
		
		int returnValue = -1;
		if(self.userImage != nil)
			returnValue = sqlite3_bind_blob(updateStmt, 3, [imgData bytes], [imgData length], NULL);
		else
			returnValue = sqlite3_bind_blob(updateStmt, 3, nil, -1, NULL);
		
		sqlite3_bind_int(updateStmt, 4, userID);
		
		if(returnValue != SQLITE_OK)
			NSLog(@"Not OK!!!");
		
		if(SQLITE_DONE != sqlite3_step(updateStmt))
			NSAssert1(0, @"Error while updating. '%s'", sqlite3_errmsg(database));
		
		sqlite3_reset(updateStmt);
		
		isDirty = NO;
	}
	
	//Reclaim all memory here.
	[userName release];
	userName = nil;
	[password release];
	password = nil;
	
	isDetailViewHydrated = NO;
}

- (void)setUserName:(NSString *)newValue {
	
	self.isDirty = YES;
	[userName release];
	userName = [newValue copy];
}

- (void)setPassword:(NSString *)newValue {
	
	self.isDirty = YES;
	[password release];
	password = [newValue copy];
}

- (void)setUserImage:(UIImage *)theUserImage {
	
	self.isDirty = YES;
	[userImage release];
	userImage = [theUserImage retain];
}

- (void) dealloc {
	
	[userImage release];
	[password release];
	[userName release];
	[super dealloc];
}



@end
