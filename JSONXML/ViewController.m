//
//  ViewController.m
//  JSONXML
//
//  Created by Unbounded Solutions on 7/16/13.
//  Copyright (c) 2013 unlimited. All rights reserved.
//

#import "ViewController.h"
 


@interface ViewController ()
/*{
    NSMutableData *webData;
    NSURLConnection *connection;
    NSMutableArray *JSONarray;
}*/
@end

@implementation ViewController

NSString* favoritedAlbum;
Favorites *albumDataBase;

@synthesize  recordsXML;
@synthesize recordsJSON;

- (void)viewDidLoad
{
    [super viewDidLoad];
    albumDataBase = [[Favorites alloc] init];
    
   // self.favAlbumArray = [[NSMutableArray alloc]init];
    
    self.recordsXML  = [[XML alloc] init];
    self.recordsJSON = [[JSON alloc] init];
    
    [recordsXML parseRecords:[albumDataBase getAlbums]];
    [self.recordsJSON parseRecords:[albumDataBase getAlbums]];
    
    self.topRecordTable.dataSource = self;
    self.topRecordTable.delegate = self;
    //self.sourceSwitcher.selectedSegmentIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.sourceSwitcher.selectedSegmentIndex == 0)?([self.recordsXML.albumArray count]):([self.recordsJSON.albumArray count]);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSString* albumName = (self.sourceSwitcher.selectedSegmentIndex == 0)?([self.recordsXML.albumArray objectAtIndex:indexPath.row]):[self.recordsJSON getNameAtIndex:indexPath.row];
    
    cell.textLabel.text = albumName;
    
    if([self databaseContainsAlbum:albumName])
    {
        cell.detailTextLabel.text = @"Favorited!";
        
        [self.favAlbumArray addObject:albumName];
        
        
    }
    else
    {
        cell.detailTextLabel.text = @"";
        [self.favAlbumArray removeObject:albumName];
    }
    return cell;
    NSLog (@"%@", favoritedAlbum);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    favoritedAlbum = (self.sourceSwitcher.selectedSegmentIndex == 0)?([self.recordsXML.albumArray objectAtIndex:indexPath.row]):([self.recordsJSON.albumArray objectAtIndex:indexPath.row]);
    if([self databaseContainsAlbum:[self.recordsXML.albumArray objectAtIndex:indexPath.row]])
    {
        UIAlertView *removeAlert = [[UIAlertView alloc] initWithTitle: @"Remove Album" message: @"Would you like to delete this album ?" delegate: self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [removeAlert show];
    }
    else
    {
        UIAlertView *favoriteAlert = [[UIAlertView alloc] initWithTitle: @"Save Album" message: @"Would you like to add this to your favorites?" delegate: self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [favoriteAlert show];
    }
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.title isEqualToString:@"Remove Album"] && buttonIndex == 1)
    {
        [albumDataBase removeAlbum:favoritedAlbum];
    }
    else if([alertView.title isEqualToString:@"Save Album"] && buttonIndex == 1)
    {
        [albumDataBase saveAlbum:favoritedAlbum];
    }
    [self.topRecordTable reloadData];
}



-(BOOL)databaseContainsAlbum:(NSString*)albumName
{
    for(NSString *name in [albumDataBase getAlbums])
    {
        if([name isEqualToString:albumName])
        {
            return true;
        }
    }
    return false;
    
 
}
- (IBAction)sourceSwitcher:(UISegmentedControl *)sender {
    if(self.sourceSwitcher.selectedSegmentIndex == 2)
    {
        self.topRecordTable insertSubview:<#(UIView *)#> atIndex:<#(NSInteger)#>
        [self.topRecordTable reloadData];
        
    }
    else 
     [self.topRecordTable reloadData];
}
@end

/*
@synthesize dbPathstr;

@synthesize recordsXML;
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    recordsXML = [[XML alloc]init];
    [self.recordsXML parseRecords];
    
    
    [[self topRecordTable]setDelegate:self];
    [[self topRecordTable]setDataSource:self];
    JSONarray = [[NSMutableArray alloc]init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"fail Error");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    NSDictionary *feed = [allDataDictionary objectForKey:@"feed"];
    NSArray *arrayOfEntry = [feed objectForKey:@"entry"];
    
    for (NSDictionary *diction in arrayOfEntry) {
        NSDictionary *title = [diction objectForKey:@"title"];
        NSString *label = [title objectForKey:@"label"];
        
        [JSONarray addObject:label];
    }
     [[self topRecordTable]reloadData];
}
 
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sourceSwitcher.selectedSegmentIndex == 1){
        
        return [self.recordsXML.albumArray count];
    }
    
    else
    {
    return [JSONarray count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    if (self.sourceSwitcher.selectedSegmentIndex == 1)
    {
        cell.textLabel.text = [self.recordsXML.albumArray objectAtIndex:indexPath.row];
        
    }
    else
    {
    cell.textLabel.text = [JSONarray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (IBAction)sourceSwitcher:(UISegmentedControl *)sender
{
 
    [JSONarray removeAllObjects];
    
    if (sender.selectedSegmentIndex == 0)
    {
    NSString *number = @"20";
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/us/rss/topalbums/limit=20/json", [number intValue]];
    NSURL *url = [NSURL URLWithString:urlStr];
  
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
        if(connection)
        {
        webData = [[NSMutableData alloc]init];
        }
    }// end of segment - 0
    
    //segment controller == 1 
    else
    {
     [JSONarray removeAllObjects];
        [self.topRecordTable reloadData];
        
        [recordsXML parseRecords];
    }
}


-(void)createDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *docPath = [paths objectAtIndex:0];
    
    self.dbPathstr = [docPath stringByAppendingPathComponent:@"music.sqlite"];
    
    char* errMsg;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:self.dbPathstr])
    {
        const char* dbpath = [self.dbPathstr UTF8String];
    
            if(sqlite3_open(dbpath, &musicDB) == SQLITE_OK)
            {
        
                const char *sql_stmt = "CREATE TABLE IF NOT EXIST MUSIC (ID INTEGER, PRIMARY KEY, AUTOINCREMENT, Artist TEXT, Album TEXT)";
    
                    if(sqlite3_exec (musicDB, sql_stmt, NULL, NULL, &errMsg)!= SQLITE_OK)
                        {
                                NSLog (@"Failed to create table");
                        }
                    sqlite3_close(musicDB);
            }
            else NSLog(@"failed to create database");
    }
    
}

-(void)saveRecord
{
    
    char*error;
    
   // self.Artist = [self.topRecordTable.indexPathForSelectedRow];
    
    if(sqlite3_open([self.dbPathstr UTF8String], &musicDB) == SQLITE_OK)
    {
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO MUSIC(Artist,title) VALUES('%s','%s')", [self.Artist UTF8String], [self.AlbumString UTF8String]];
        
        const char*insert_stmt =  [insertStmt UTF8String];
    
            if(sqlite3_exec(musicDB, insert_stmt, NULL, NULL, &error)== SQLITE_OK)
            {
                NSLog (@"Music added");
            }
    }
}

-(void)ReadDate
{
    sqlite3_stmt * statement;
    
    if(sqlite3_open([self.dbPathstr UTF8String], &musicDB) == SQLITE_OK )
    {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM MUSIC"];
        
        const char* query_sql =     [querySql UTF8String];
    
        if(sqlite3_prepare(musicDB, query_sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
        //        NSString * artist = [[NSString alloc]initWithUTF8String:(const char*) splite3_column_text(statement,1)];
                
            //    NSString *title = [[NSString alloc]initWithUTF8String:(const char*) splite3_column_text(statement,2)];
            }
        }
    }
}


-(void)deleteData
{
    char *error;
    
    NSString* deleteQuery = [NSString stringWithFormat:@"Delete from MUSIC where title is '%s' and author is '%s'",
                                [@"Harry Potter" UTF8String], [@"jk rowling" UTF8String]];
    
    if(sqlite3_exec(musicDB, [deleteQuery UTF8String], NULL,NULL, &error) != SQLITE_OK){
        NSLog(@"Error deleting data");
    }
}
@end*/