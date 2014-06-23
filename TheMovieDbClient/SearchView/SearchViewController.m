//
//  SearchViewController.m
//  TheMovieDbClient
//
//  Created by mac-214 on 23.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "SearchViewController.h"
#import "MainViewCell.h"
#import <CoreData/CoreData.h>
#import "SearchRecord.h"
#import "SearchViewCell.h"
#import "ImageHelper.h"
#import "ReviewFilm.h"
#import "DetailViewController.h"
#import "ApiLoadService.h"
#import "NetworkStatusHelper.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize films = _films;
@synthesize theSearchBar = _theSearchBar;
@synthesize searchTableView = _searchTableView;
@synthesize fetchedRecordsArray = _fetchedRecordsArray;
@synthesize isSearch = _isSearch;

- (void) dealloc
{
    [_fetchedRecordsArray release];
    [_searchTableView release];
    [_theSearchBar release];
    [_films release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
   return self;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_isSearch) {
        [_searchTableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isSearch = TRUE;
    self.navigationItem.title = @"Search";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        self.managedObjectContext = appDelegate.managedObjectContext;
        self.fetchedRecordsArray = [[[appDelegate getAllRecords] reverseObjectEnumerator] allObjects];
    });
    [_searchTableView reloadData];
}

- (void) saveForAutocompleting: (NSString *) _typedRequest
{
    SearchRecord *newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"SearchRecord"
                                                            inManagedObjectContext:self.managedObjectContext] ;
    newEntry.typedRequest = _typedRequest;
    
    NSError *error;
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"Error. Couldn't save: %@", [error localizedDescription]);
    }
    NSLog(@"save for autocomplete: %@", _typedRequest);    
}

#pragma mark -SearchBar

- (void)searchBar:(UISearchBar*) searchBar textDidChange:(NSString *)searchText
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    _searchTableView.allowsSelection = YES;
    _searchTableView.scrollEnabled = YES;
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _isSearch = TRUE;
    [_searchTableView reloadData];
    searchBar.text = @"";
    
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    _searchTableView.allowsSelection = YES;
    _searchTableView.scrollEnabled = YES;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _isSearch = FALSE;
    [_searchTableView reloadData];
    
    if(_theSearchBar.text.length < 1)
    {
        NSLog(@"no characters to find");
    }
    else
    {
     
        if ([NetworkStatusHelper isInternetActive]) {
            
            [self saveForAutocompleting:_theSearchBar.text];
            _lastRequest = _theSearchBar.text;
            NSString *searchRequest = @"http://api.themoviedb.org/3/search/movie?api_key=48ed176d044976544817d2b4f21f3567&query=";
            searchRequest = [searchRequest stringByAppendingString:_theSearchBar.text];
            searchRequest = [searchRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *searchURl = [NSURL URLWithString:searchRequest];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:searchURl];
                NSLog(@"Search URL - %@", searchURl);
                [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
            });
            NSLog( @"Search request: %@", searchRequest);
        }
        else
        {
            NSLog(@"No interet");
            UIAlertView *notFound = [[UIAlertView alloc] initWithTitle: @"The MovieDataBase" message: @"No Internet Connection" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [notFound show];
            [notFound release];
        }
        
        [searchBar setShowsCancelButton:NO animated:YES];
        [searchBar resignFirstResponder];
        _searchTableView.allowsSelection = YES;
        _searchTableView.scrollEnabled = YES;
    }
        
}

- (void) fetchedData: (NSData*) responseData
{
    if (responseData)
    {
        NSError * error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        
        if (error != nil)
        {
            _films = [ReviewFilm initWithDictionary:json];
            NSLog(@"Response: %@", json);
            
            if([_films count] < 1)
            {
                UIAlertView *notFound = [[UIAlertView alloc] initWithTitle: @"Searching" message: @"Sorry, there is no mathces. Try to type again" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
                [notFound show];
                [notFound release];
                
                _theSearchBar.text = @"";
            }
            
            [_films retain];
            [_searchTableView reloadData];
        }
        else
        {
            NSLog(@"Error: fetchedData method");
        }
    }
    else
    {
        UIAlertView *notFound = [[UIAlertView alloc] initWithTitle: @"The MovieDataBase" message: @"Error" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [notFound show];
        [notFound release];
        NSLog(@"Error");
    }
}

#pragma mark -TableView

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isSearch)
    {
        return cellSearchHeight;
    }
    else
    {
        return cellMainHeight;
    }
}

- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearch)
    {
        NSLog(@"%@\t\t%d",[[[_searchTableView cellForRowAtIndexPath:indexPath] textLabel] text], indexPath.row);
        _theSearchBar.text = [[_fetchedRecordsArray objectAtIndex:indexPath.row] typedRequest];
        
    }
    else
    {
        if ([NetworkStatusHelper isInternetActive])
        {
            NSLog(@"Selected item %@", [tableView indexPathForSelectedRow]);
            ReviewFilm *testFilm = (ReviewFilm*) _films[indexPath.row];
            DetailViewController *detailController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
            detailController.film = testFilm;
            [self.navigationController pushViewController:detailController animated:YES];
            
            [detailController release];
        }
        else
        {
            NSLog(@"No interet");
            UIAlertView *notFound = [[UIAlertView alloc] initWithTitle: @"The MovieDataBase" message: @"No Internet Connection" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [notFound show];
            [notFound release];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(_isSearch)
    {
        return [self.fetchedRecordsArray count];
    }
    else
    {
        NSLog(@"Count of rows: %lu", (unsigned long)[_films count]);
        return [_films count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearch == FALSE)
    {
        static NSString *CellIdentifier = @"MyFeedCell";
        MainViewCell *cell;
        cell = (MainViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell)
        {
            cell = [ViewLoader loadView:[MainViewCell class]];
        }
        
        ReviewFilm *testFilm = (ReviewFilm*) _films[indexPath.row];
        
        if(testFilm.posterImage)
        {
            cell.filmPoster.image = testFilm.posterImage;
            [ImageHelper setRoundedBorder:cell.filmPoster];
        }
        else
        {
            cell.filmPoster.image = [UIImage imageNamed:@"poster.png"];
            
            if (![testFilm.posterPath isEqual:[NSNull null]])
            {
                NSString *path = @"http://image.tmdb.org/t/p/w500";
                NSURL *imageURL = [NSURL URLWithString:[path stringByAppendingString:testFilm.posterPath]];
                
                cell.posterUrl = imageURL;
                
                [ImageHelper laodFromURL:imageURL callback:^(UIImage *image, NSURL *url) {
                    
                    if([cell.posterUrl.absoluteString isEqualToString:imageURL.absoluteString])
                    {
                        cell.filmPoster.image = image;
                        [ImageHelper setRoundedBorder:cell.filmPoster];
                        testFilm.posterImage = image;
                    }
                }];
            }
        }
        cell.filmTitle.text = [testFilm title];
        cell.filmYear.text =[testFilm yearRelease];
        cell.filmRating.text = [testFilm rating] ;
        
        return cell;
    }
    else
    {
        NSLog(@"Autocell");
        static NSString *cellId = @"AutoCell";
        
        UITableViewCell *autoCell = [ tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (autoCell == nil)
        {
            autoCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId] autorelease];
        }
        autoCell.textLabel.text = [[self.fetchedRecordsArray  objectAtIndex:indexPath.row] typedRequest];
        
        return autoCell;
    }
}

@end
