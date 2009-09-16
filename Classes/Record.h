//
//  Record.h
//  txtEdit 0.2
//
//  Created by Evgeniy Krysanov on 22.08.08.
//  Copyright PyObjC.ru - 2008. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Record : NSObject {
    sqlite3 *database;
    
    NSInteger primaryKey;
    NSString *title;
    NSString *txt;
	UIImage *image;
	NSString *username;
	NSString *password;
	BOOL type;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *txt;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;
@property (nonatomic, retain) UIImage *image;

+(void)finalizeStatements;
-(id)initWithIdentifier:(NSInteger)idKey database:(sqlite3 *)db;
-(void)readRecord;
-(void)updateRecord;
-(void)deleteRecord;
-(void)insertIntoDatabase:(sqlite3 *)db;

@end
