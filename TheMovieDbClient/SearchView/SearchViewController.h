//
//  SearchViewController.h
//  TheMovieDbClient
//
//  Created by mac-214 on 23.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewCell.h"
#import "SearchRecord.h"
#import "AppDelegate.h"

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (assign) bool isSearch;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSArray *fetchedRecordsArray;
@property (nonatomic, retain) IBOutlet UITableView *searchTableView;
@property (nonatomic, retain) IBOutlet UISearchBar *theSearchBar;
@property (nonatomic, retain) NSArray *films;
@property (nonatomic, retain) NSCache *cache;
@property (nonatomic, retain) NSString* lastRequest;

@end
