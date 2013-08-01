//
//  JSON.m
//  JSONXML
//
//  Created by Unbounded Solutions on 7/17/13.
//  Copyright (c) 2013 unlimited. All rights reserved.
//


#import "JSON.h"

#define jsonURL [NSURL URLWithString: @"http://itunes.apple.com/us/rss/topalbums/limit=20/json"]

@implementation JSON

@synthesize  albumArray;
-(NSString*)getNameAtIndex:(NSInteger) index
{
    return [self.albumArray objectAtIndex:index];
}

-(void)parseRecords:(NSArray *)arryOfAlbums
{
    self.albumArray = [[NSMutableArray alloc] initWithArray:arryOfAlbums];
    NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
    [self performSelectorOnMainThread: @selector(jsonDataRetreived:) withObject:jsonData waitUntilDone:YES];
}

-(void)jsonDataRetreived:(NSData*) dataResponse
{
    NSError *error;
    NSDictionary *currentEntry;
    NSString *albumName;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:dataResponse options:kNilOptions error:&error];
    NSDictionary *feedArray = [jsonDict objectForKey:@"feed"];
    NSArray *entryArray = [feedArray objectForKey:@"entry"];
    
    for(int i = 0; i < entryArray.count; i++)
    {
        currentEntry = [entryArray objectAtIndex:i];
        albumName = [[currentEntry objectForKey:@"im:name"] objectForKey:@"label"];
        if(![self arrayContainsAlbum:albumName])
        {
            [self.albumArray addObject:albumName];
        }
    }
}

-(BOOL)arrayContainsAlbum:(NSString*)albumName
{
    for(NSString *name in self.albumArray)
    {
        if([name isEqualToString:albumName])
        {
            return true;
        }
    }
    return false;
}

@end
