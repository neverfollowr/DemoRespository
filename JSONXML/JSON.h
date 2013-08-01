//
//  JSON.h
//  JSONXML
//
//  Created by Unbounded Solutions on 7/17/13.
//  Copyright (c) 2013 unlimited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSON : NSObject

@property (strong, nonatomic) NSMutableArray *albumArray;

-(void)parseRecords:(NSArray *)arryOfAlbums;


-(NSString*)getNameAtIndex:(NSInteger) index;


@end
