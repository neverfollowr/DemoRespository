//
//  Favorites.h
//  JSONXML
//
//  Created by Unbounded Solutions on 7/19/13.
//  Copyright (c) 2013 unlimited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface Favorites : NSObject


-(void) saveAlbum:(NSString*)albumName;
-(void) removeAlbum:(NSString*)albumName;
-(NSArray*) getAlbums;


@end
