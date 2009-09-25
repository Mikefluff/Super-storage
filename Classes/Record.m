//
//  Record.m
//  txtEdit 0.2
//
//  Created by Evgeniy Krysanov on 22.08.08.
//  Copyright PyObjC.ru - 2008. All rights reserved.
//

#import "Record.h"
#import "tableDataDelegate.h"
#import <sqlite3.h>


#define TITLE_LENGTH 50

@implementation Record

@synthesize primaryKey, title, txt, image, isDirty, isDetailViewHydrated;

static sqlite3 *database = nil;
static sqlite3_stmt *init_statement = nil;
static sqlite3_stmt *read_statement = nil;
static sqlite3_stmt *update_statement = nil;
static sqlite3_stmt *insert_statement = nil;
static sqlite3_stmt *delete_statement = nil;

+(void)finalizeStatements {
    if (init_statement) sqlite3_finalize(init_statement);
    if (read_statement) sqlite3_finalize(read_statement);
    if (update_statement) sqlite3_finalize(update_statement);
    if (insert_statement) sqlite3_finalize(insert_statement);
	if (delete_statement) sqlite3_finalize(delete_statement);
}


// Инициализирует запись и читает для нее заголовок из базы
+ (void) getInitialDataToDisplay:(NSString *)dbPath hash:(NSString *)hash {
	
	Super_storageAppDelegate *appDelegate = (Super_storageAppDelegate *)[[UIApplication sharedApplication] delegate];

	
	if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		NSString *ha = [[NSString alloc] initWithString:@"PRAGMA KEY = '"];
		ha = [[ha stringByAppendingString:hash] stringByAppendingString:@"'"];
		sqlite3_exec(database, [ha UTF8String], NULL, NULL, NULL);
		
		const char *sql = "select id, title from data";
		sqlite3_stmt *selectstmt;
		if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
			
			while(sqlite3_step(selectstmt) == SQLITE_ROW) {
				
				NSInteger primaryKey = sqlite3_column_int(selectstmt, 0);
				Record *record = [[Record alloc] initWithPrimaryKey:primaryKey];
				record.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectstmt, 1)];
				
				record.isDirty = NO;
				
				[appDelegate.records addObject:record];
				[record release];
			}
		}
	}
	else
		sqlite3_close(database); //Even though the open call failed, close the database connection to release all the memory.
}
- (id) initWithPrimaryKey:(NSInteger) pk {
	
	[super init];
	primaryKey = pk;
	
	image = [[UIImage alloc] init];
	isDetailViewHydrated = NO;
	
	return self;
}
/*-(id)initWithIdentifier:(NSInteger)idKey database:(sqlite3 *)db {
    if (self = [super init]) {
        database = db;
        primaryKey = idKey;
        image = [[UIImage alloc] init];
        // Инициализуем переменную init_statement при первом вызоме метода
        if (init_statement == nil) {
            // Подготавливаем запрос перед отправкой в базу данных
            const char *sql;
				sql = "SELECT title FROM data WHERE id=?";
            if (sqlite3_prepare_v2(database, sql, -1, &init_statement, NULL) != SQLITE_OK) {
                NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
            }
        }
        
        // Подставляем значение в запрос
        sqlite3_bind_int(init_statement, 1, self.primaryKey);
        
        // Получаем результаты выборки
        if (sqlite3_step(init_statement) == SQLITE_ROW) {
            self.title = [NSString stringWithUTF8String:(char *)sqlite3_column_text(init_statement, 0)];
        } else {
            self.title = @"";
        }
        
        // Сбрасываем подготовленное выражение для повторного использования
        sqlite3_reset(init_statement);
    }
    return self;
}*/

// Читает полный текст записи из базы
-(void)readRecord {
    if (read_statement == nil) {
        const char *sql;
		sql = "SELECT title, text, image FROM data WHERE id=?";
		if (sqlite3_prepare_v2(database, sql, -1, &read_statement, NULL) != SQLITE_OK) {
            NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    
    sqlite3_bind_int(read_statement, 1, self.primaryKey);
    
    if (sqlite3_step(read_statement) == SQLITE_ROW) {
        self.txt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(read_statement, 0)];
		NSData *data = [[NSData alloc] initWithBytes:sqlite3_column_blob(read_statement, 1) length:sqlite3_column_bytes(read_statement, 1)]; 
		
		if(data == nil)
			NSLog(@"No image found.");
		else
			self.image = [UIImage imageWithData:data]; 
	} else {
        self.txt = @"";
    }
    
    sqlite3_reset(read_statement);
}

// Обновляет значение записи в базе
-(void)updateRecord {
    // Если обновление уже проходило - выходим
    if (self.txt == nil) return;
    
    if (update_statement == nil) {
		const char *sql;
	
		sql = "UPDATE data SET title=?, text=?, image=? WHERE id=?"; 
	    if (sqlite3_prepare_v2(database, sql, -1, &update_statement, NULL) != SQLITE_OK) {
            NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    
    // title содержит несколько символов из начала записи для отображения в списке TableView
    NSUInteger lenToCut = (txt.length < TITLE_LENGTH) ? txt.length : TITLE_LENGTH;
    self.title = [txt substringToIndex:lenToCut];
    NSData *imgData = UIImagePNGRepresentation(self.image);
    sqlite3_bind_text(update_statement, 1, [title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(update_statement, 2, [txt UTF8String], -1, SQLITE_TRANSIENT);
	if(self.image != nil)
		sqlite3_bind_blob(update_statement, 3, [imgData bytes], [imgData length], NULL);
	else
		sqlite3_bind_blob(update_statement, 3, nil, -1, NULL);
    sqlite3_bind_int(update_statement, 4, self.primaryKey);
    
    if (sqlite3_step(update_statement) != SQLITE_DONE) {
        NSAssert1(NO, @"Error: failed to update with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(update_statement);
    
    self.txt = nil;
}

// Добавляет новую запись в базу
-(void)insertIntoDatabase {
    
    // Если пользователь ничего не ввел, то запись в базу не производится
    if ((self.txt == nil) || (txt.length == 0)) return;
    
    if (insert_statement == nil) {
		const char *sql;
				sql = "INSERT INTO data(title, text, image) VALUES(?, ?, ?)";
        if (sqlite3_prepare_v2(database, sql, -1, &insert_statement, NULL) != SQLITE_OK) {
            NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
    }
    
    NSUInteger lenToCut = (txt.length < TITLE_LENGTH) ? txt.length : TITLE_LENGTH;
    self.title = [txt substringToIndex:lenToCut];
    NSData *imgData = UIImagePNGRepresentation(self.image);
    sqlite3_bind_text(insert_statement, 1, [title UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(insert_statement, 2, [txt UTF8String], -1, SQLITE_TRANSIENT);
    if(self.image != nil)
		sqlite3_bind_blob(insert_statement, 3, [imgData bytes], [imgData length], NULL);
	else
		sqlite3_bind_blob(insert_statement, 3, nil, -1, NULL);
	
    if (sqlite3_step(insert_statement) == SQLITE_DONE) {
        primaryKey = sqlite3_last_insert_rowid(database);
    } else {
        NSAssert1(NO, @"Error: failed to insert into the database with message '%s'.", sqlite3_errmsg(database));
    }
    
    sqlite3_reset(insert_statement);
    
    self.txt = nil;
}

-(void)deleteRecord {
	if (delete_statement == nil) {
		const char *sql;	
			sql = "DELETE FROM data WHERE id=?";
        if (sqlite3_prepare_v2(database, sql, -1, &delete_statement, NULL) != SQLITE_OK) {
            NSAssert1(NO, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        }
		sqlite3_bind_int(delete_statement, 1, self.primaryKey);
		sqlite3_step(delete_statement);
    }
    
       
    sqlite3_reset(delete_statement);
}


- (void)dealloc {
    [title release];
    [txt release];
	[image release];
    [super dealloc];
}

@end
