//
//  XML.h
//  JSONXML
//
//  Created by Unbounded Solutions on 7/17/13.
//  Copyright (c) 2013 unlimited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XML: NSObject<NSXMLParserDelegate>


@property (strong, nonatomic) NSString *currentElement;
@property (strong, nonatomic) NSString* currentAlbum;
@property (strong, nonatomic) NSMutableArray *albumArray;


@property (strong, nonatomic) NSXMLParser *parser;




-(void)parseRecords:(NSArray *)arryOfAlbums;



@end




