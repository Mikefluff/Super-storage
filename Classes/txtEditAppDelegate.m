//
//  txtEditAppDelegate.m
//  txtEdit 0.2
//
//  Created by Evgeniy Krysanov on 22.08.08.
//  Copyright PyObjC.ru - 2008. All rights reserved.
//

#import "txtEditAppDelegate.h"
#import "Record.h"
#import "tableViewController.h"

#import "md5.h"
//#import "MYCrypto.h"
//#import "MYEncoder.h"

@implementation txtEditAppDelegate

@synthesize window;
@synthesize navController;
@synthesize records;
@synthesize mviewController;
@synthesize hash;
@synthesize db;
@synthesize username;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    db = [[NSString alloc] initWithString:@"system"];
	[self createEditableCopyOfDatabaseIfNeeded];
    [self initializeDatabase:db];
//    mviewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    [window addSubview:navController.view];
    
    // Override point for customization after app launch   
    [window makeKeyAndVisible];
	UIDevice *myDevice = [UIDevice currentDevice];
	hash = [myDevice uniqueIdentifier];
	hash = [hash md5sum];
//	MYPrivateKey *keyPair = [[MYKeychain defaultKeychain] generateRSAKeyPairOfSize: 2048];
//	NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
//						   @"alice", @"Common Name",
//						   @"Alice", @"Given Name",
//						   @"Lidell", @"Surname",
//						   nil];
//	MYIdentity *ident = [keyPair createSelfSignedIdentityWithAttributes: attrs];
	
//	NSData *certData = ident.certificateData;
//	NSData *cleartext = [@"Attack at dawn" dataUsingEncoding: NSUTF8StringEncoding];
//	MYEncoder *encoder = [[MYEncoder alloc] init];
//	[encoder addSigner: ident];
//	[encoder addRecipient: bob];
//	[encoder addRecipient: carla];
//	[encoder addData: cleartext];
//	[encoder finish];
//	NSData *ciphertext = encoder.encodedData;
	
//	sendMessage(ciphertext);
}

// Копирует базу данных из ресурсов приложения в папку Documents на iPhone
/*-(void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];   
    
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"system.sql"];
    NSString *res;
    // Если целевой файл уже существует, то не затираем его и выходим из метода
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"system.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (sqlite3_open([writableDBPath UTF8String], &database) == SQLITE_OK) {
		sqlite3_exec(database, [hash UTF8String], NULL, NULL, NULL);
		if (sqlite3_exec(database, (const char*) "CREATE TABLE records('id' INTEGER PRIMARY KEY, 'title' TEXT, 'txt' TEXT, 'image' BLOB);", NULL, NULL, NULL) == SQLITE_OK) {
			res = @"password is correct, or, database has been initialized";
		} else {
			res = @"incorrect password!";
		}}
	sqlite3_close(database);
    if (!success) {
        NSAssert1(NO, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}*/

-(void)createEditableCopyOfDatabaseIfNeeded {
    BOOL success;
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];   
    
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"system.sql"];
    NSString *res;
    // Если целевой файл уже существует, то не затираем его и выходим из метода
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"system.sql"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (sqlite3_open([writableDBPath UTF8String], &database) == SQLITE_OK) {
		sqlite3_exec(database, [hash UTF8String], NULL, NULL, NULL);
		if (sqlite3_exec(database, (const char*) "CREATE TABLE system('id' INTEGER PRIMARY KEY, 'username' TEXT, 'password' TEXT, 'image' BLOB);", NULL, NULL, NULL) == SQLITE_OK) {
			res = @"password is correct, or, database has been initialized";
		} else {
			res = @"incorrect password!";
		}}
	sqlite3_close(database);
    if (!success) {
        NSAssert1(NO, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}



// Открывает базу данных и читает записи из нее
-(void)initializeDatabase:(NSString *)dat {
    // Создание массива записей
    NSString *datab = [dat stringByAppendingString:@".sql"];
	NSMutableArray *recordsArray = [[NSMutableArray alloc] init];
    self.records = recordsArray;
	[recordsArray release];
   
    // Получаем путь к базе данных
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:datab];
	
	if (dat != @"system")
	{ hash = [username md5sum];
	}
 //   NSString *res;
    // Открываем базу данных
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		
	//	sqlite3_rekey(database, "1234", (int)strlen("1234"));
//	 sqlite3_close(database);
		sqlite3_exec(database, [hash UTF8String], NULL, NULL, NULL);
					 
					 
		// Запрашиваем список идентификаторов записей
        const char *sql = "SELECT id FROM system ORDER BY id ASC";
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
}

// Добавляет или обновляет информацию о записи в базе данных
/*-(void)updateOrAddRecordIntoDatabase:(Record *)record {
    if (record.primaryKey != 0) {
        [record updateRecord];
    } else {
		if((record.txt==nil)||(record.txt.length==0)) return;
		[record insertIntoDatabase:database]; 
		[records addObject:record]; 
    }
}*/
-(void)updateOrAddRecordIntoDatabase:(Record *)record {
    if (record.primaryKey != 0) {
        [record updateRecord];
    } else {
		if((record.password==nil)||(record.username.length==0)) return;
		[record insertIntoDatabase:database]; 
		[records addObject:record]; 
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
