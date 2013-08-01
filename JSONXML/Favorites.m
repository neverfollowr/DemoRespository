//
//  Favorites.m
//  JSONXML
//
//  Created by Unbounded Solutions on 7/19/13.
//  Copyright (c) 2013 unlimited. All rights reserved.
//

#import "Favorites.h"

@implementation Favorites


sqlite3 *albumDB;
NSString *dbPathstr;

-(id) init
{
    if(self = [super init])
    {
        [self createDB];
    }
    return self;
}

-(void) createDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths objectAtIndex:0];
    dbPathstr = [docPath stringByAppendingPathComponent:@"albums.sqlite"];
    char *errMsg;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:dbPathstr])
    {
        const char* dbPath = [dbPathstr UTF8String];
        if(sqlite3_open(dbPath, &albumDB) == SQLITE_OK)
        {
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS ALBUMS (ID INTEGER PRIMARY KEY AUTOINCREMENT, TITLE TEXT)";
            if(sqlite3_exec(albumDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table: %s",errMsg);
            }
            sqlite3_close(albumDB);
        }
        else
            NSLog(@"Failed to create database");
    }
}

-(void) saveAlbum:(NSString*)albumName
{
    char* errMsg;
    if(sqlite3_open([dbPathstr UTF8String], &albumDB) == SQLITE_OK)
    {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO ALBUMS(title) VALUES('%s')",[albumName UTF8String]];
        const char *insert_stmt = [insertStmt UTF8String];
        if(sqlite3_exec(albumDB, insert_stmt, NULL, NULL, &errMsg) == SQLITE_OK)
        {
            NSLog(@"%@ added",albumName);
        }
    }
}

-(NSArray*) getAlbums
{
    sqlite3_stmt *statement;
    NSMutableArray *arryAlbums = [[NSMutableArray alloc] init];
    if(sqlite3_open([dbPathstr UTF8String], &albumDB)==SQLITE_OK)
    {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM ALBUMS"];
        const char* query_sql = [querySql UTF8String];
        
        if(sqlite3_prepare(albumDB, query_sql, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *albumTitle = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement,1)];
                [arryAlbums addObject:albumTitle];
            }
        }
    }
    return [NSArray arrayWithArray:arryAlbums];
}

-(void)removeAlbum:(NSString *)albumName
{
    char *errMsg;
    NSString* deleteQuery = [NSString stringWithFormat:@"Delete from ALBUMS where title is'%s'",[albumName UTF8String]];
    if(sqlite3_exec(albumDB, [deleteQuery UTF8String],NULL,NULL,&errMsg) != SQLITE_OK)
    {
        NSLog(@"Error delete data: %s",errMsg);
    }
    NSLog(@"Album: %@ Deleted",albumName);
}

@end
