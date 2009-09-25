//
//  txtEditAppDelegate.m
//  txtEdit 0.2
//
//  Created by Evgeniy Krysanov on 22.08.08.
//  Copyright PyObjC.ru - 2008. All rights reserved.
//

#import "tableDataDelegate.h"
#import "Record.h"
#import "tableViewController.h"
#import <sqlite3.h>

#import "md5.h"
//#import "MYCrypto.h"
//#import "MYEncoder.h"

@implementation tableDataDelegate

@synthesize window;
@synthesize navController;
@synthesize records;
@synthesize mviewController;
@synthesize hash;
@synthesize db;
@synthesize username;
@synthesize writableDBPath;


-(void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];   
    NSString *datab = [db stringByAppendingString:@".sql"];
	writableDBPath = [documentsDirectory stringByAppendingPathComponent:datab];
    NSString *res;
    // Если целевой файл уже существует, то не затираем его и выходим из метода
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:writableDBPath];
 	if (success) return;
	else {
		NSString *ha = [[NSString alloc] initWithString:@"PRAGMA KEY = '"];
		ha = [[ha stringByAppendingString:hash] stringByAppendingString:@"'"];
		if (sqlite3_open([writableDBPath UTF8String], &database) == SQLITE_OK) {
		sqlite3_exec(database, [ha UTF8String], NULL, NULL, NULL);
		if (sqlite3_exec(database, (const char*) "CREATE TABLE data('id' INTEGER PRIMARY KEY, 'title' TEXT, 'text' TEXT, 'image' BLOB);", NULL, NULL, NULL) == SQLITE_OK) {
			res = @"password is correct, or, database has been initialized";
		} else {
			res = @"incorrect password!";
		}}
	sqlite3_close(database);
   }
}



// Открывает базу данных и читает записи из нее
-(void)initializeDatabase {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];   
    NSString *datab = [db stringByAppendingString:@".sql"];
	writableDBPath = [documentsDirectory stringByAppendingPathComponent:datab];
	[Record getInitialDataToDisplay:writableDBPath hash:hash];
}    // Создание массива записей
/*    NSString *datab = [db stringByAppendingString:@".sql"];
	NSMutableArray *recordsArray = [[NSMutableArray alloc] init];
    self.records = recordsArray;
	[recordsArray release];
   
    // Получаем путь к базе данных
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:datab];
	NSString *res;
	 //   NSString *res;
    // Открываем базу данных
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		
	//	sqlite3_rekey(database, "1234", (int)strlen("1234"));
//	 sqlite3_close(database);
		NSString *ha = [[NSString alloc] initWithString:@"PRAGMA KEY = '"];
		ha = [[ha stringByAppendingString:hash] stringByAppendingString:@"'"];
		sqlite3_exec(database, [ha UTF8String], NULL, NULL, NULL);
		if (sqlite3_exec(database, (const char*) "SELECT id FROM data ORDER BY id ASC", NULL, NULL, NULL) == SQLITE_OK) {
			res = @"password is correct, or, database has been initialized";
		} else {
			res = @"incorrect password!";
		}
		
		
					 
					 
		// Запрашиваем список идентификаторов записей
        const char *sql = "SELECT id FROM data ORDER BY id ASC";
        sqlite3_stmt *statement;
        
        // Компилируем запрос в байткод перед отправкой в базу данных
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int primaryKey = sqlite3_column_int(statement, 0);
                
                // Заполняем массив объектами Record, инициализированными с ключами, полученными из базы
                Record *record = [[Record alloc] initWithIdentifier:primaryKey database:database];
                [records addObject:record];
				[record release];
            }
			
        }
        
        sqlite3_finalize(statement);
    } else {
        // Даже в случае ошибки открытия базы закрываем ее для корректного освобождения памяти
        sqlite3_close(database);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }
}*/

// Добавляет или обновляет информацию о записи в базе данных
-(void)updateOrAddRecordIntoDatabase:(Record *)record {
    Super_storageAppDelegate *appDelegate = (Super_storageAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (record.primaryKey != 0) {
        [record updateRecord];
    } else {
		if((record.txt==nil)||(record.txt.length==0)) return;
		[record insertIntoDatabase]; 
		[appDelegate.records addObject:record]; 
    }
}



// Перед выходом из приложения закрываем базу данных
-(void)applicationWillTerminate:(UIApplication *)application {
    [Record finalizeStatements];
    
    if (sqlite3_close(database) != SQLITE_OK) {
        NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
}

- (void)dealloc {
    [records release];
    [navController release];
	[hash release];
	[window release];
	[super dealloc];
}


@end
