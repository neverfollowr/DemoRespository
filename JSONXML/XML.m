//
//  XML.m
//  JSONXML
//
//  Created by Unbounded Solutions on 7/17/13.
//  Copyright (c) 2013 unlimited. All rights reserved.
//

#import "XML.h"



@implementation XML

#define xmlURL [NSURL URLWithString: @"http://itunes.apple.com/us/rss/topalbums/limit=20/xml"]

@synthesize parser;
@synthesize currentAlbum;
@synthesize currentElement;
@synthesize albumArray;


-(void)parseRecords:(NSArray *)arryOfAlbums{
    
    self.currentAlbum = @"";
    self.currentElement = [[NSString alloc] init];
    self.albumArray = [[NSMutableArray alloc] initWithArray:arryOfAlbums];
    
    
    NSData *webData = [[NSData alloc] initWithContentsOfURL:xmlURL];
    
    
    
    
    self.parser = [[NSXMLParser alloc] initWithData:webData];
    self.parser.delegate = self;
    [self.parser parse];
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([self.currentElement isEqualToString:@"title"])
    {
        self.currentAlbum = [self.currentAlbum stringByAppendingString:string];
   
    }//end of if
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"title"])
    {
        self.currentElement = elementName;
    
    }//end of if
}
 
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if(![self.currentAlbum isEqualToString:@""])
        [self.albumArray addObject:self.currentAlbum];
    self.currentAlbum = @"";
    self.currentElement = @"";
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