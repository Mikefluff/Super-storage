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
        
    NSInteger primaryKey;
    NSString *title;
    NSString *txt;
	UIImage *image;

	BOOL type;
	BOOL isDirty;
	BOOL isDetailViewHydrated;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *txt;

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, readwrite) BOOL isDirty;
@property (nonatomic, readwrite) BOOL isDetailViewHydrated;

+(void)finalizeStatements;
+ (void) getInitialDataToDisplay:(NSString *)dbPath hash:(NSString *)hash;
-(void)readRecord;
-(void)updateRecord;
-(void)deleteRecord;
-(void)insertIntoDatabase;
- (id) initWithPrimaryKey:(NSInteger)pk;
@end
