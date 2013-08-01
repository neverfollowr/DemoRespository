//
//  ViewController.h
//  JSONXML
//
//  Created by Unbounded Solutions on 7/16/13.
//  Copyright (c) 2013 unlimited. All rights reserved.
//

#import <UIKit/UIKit.h>
 
#import "JSON.h"
#import "XML.h"
#import "sqlite3.h"
#import "Favorites.h"

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, UIAlertViewDelegate>
 



@property (strong, nonatomic) XML *recordsXML;
@property (strong, nonatomic) JSON *recordsJSON;

 

@property (strong, nonatomic) IBOutlet UISegmentedControl *sourceSwitcher;
 
- (IBAction)sourceSwitcher:(UISegmentedControl *)sender;

@property (strong, nonatomic) IBOutlet UITableView *topRecordTable;

@property (strong, nonatomic) NSString *dbPathstr;

@property (strong, nonatomic) NSString *Artist;
@property (strong, nonatomic) NSString *AlbumString;


@property (strong, nonatomic) NSMutableArray *favAlbumArray;

@end
