//
//  Users.h
//  Super-storage
//
//  Created by Mike Fluff on 14.09.09.
//  Copyright 2009 Altell ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Users : NSObject {
	NSInteger userID;
	NSString *userName;
	NSString *password;
	UIImage *userImage; 
	
	//Intrnal variables to keep track of the state of the object.
	BOOL isDirty;
	BOOL isDetailViewHydrated;
}

@property (nonatomic, readonly) NSInteger userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, retain) UIImage *userImage;

@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

//Static methods.
+ (void) getInitialDataToDisplay:(NSString *)dbPath;
+ (void) finalizeStatements;

//Instance methods.
- (id) initWithPrimaryKey:(NSInteger)pk;
- (void) deleteUser;
- (void) addUser;
- (void) hydrateDetailViewData;
- (void) saveAllData;

@end
