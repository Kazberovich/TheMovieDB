//
//  MainViewController.m
//  TheMovieDbClient
//
//  Created by mac-214 on 22.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewCell.h"
#import "DetailViewController.h"
#import "SearchViewController.h"
#import "WebViewController.h"
#import "DownloadHelper.h"
#import "ApiLoadService.h"
#import "ReviewFilm.h"
#import "ImageHelper.h"
#import "NetworkStatusHelper.h"
#import "WatchlistHolder.h"
#import "Reachability.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize sampleTableView = _sampleTableView;
@synthesize filmList = _filmList;
@synthesize unAuthorizedView = _unAuthorizedView;
@synthesize emptyWatchlistView = _emptyWatchlistView;
@synthesize indicator = _indicator;
@synthesize networkStatus = _networkStatus;

int didLoadCount = 0;
int didAppearCount = 0;

- (void) dealloc
{
    NSLog(@"dealloc");
    [_networkStatus release];
    [_unAuthorizedView release];
    [_emptyWatchlistView release];
    [_indicator release];
    [_sampleTableView release];
    [_filmList release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    NSLog(@"viewDidLoad %d", didLoadCount);
    didLoadCount ++;
    [super viewDidLoad];
    
    [NetworkStatusHelper sharedInstance].delegate = self;
    
    
    [_indicator startAnimating];
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                target:self action:@selector(toggleSearch)];
    self.navigationItem.rightBarButtonItem = searchItem;
    [searchItem release];
    
    self.navigationItem.title = @"The Movie DB client";
    NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"];
    
    if ([NetworkStatusHelper isInternetActive])
    {
        _networkStatus.hidden = YES;
        
        if (sessionId)  //authorized user
        {
            UIBarButtonItem *accountItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                          target:self action:@selector(toggleLogOut)] autorelease];
            self.navigationItem.leftBarButtonItem = accountItem;
            
            _emptyWatchlistView.hidden = YES;
            _unAuthorizedView.hidden = YES;
            _sampleTableView.hidden = YES;
            
            NSLog(@"saved session_id: %@", sessionId);
            [ApiLoadService getResponseForURL:[DownloadHelper getUserIdURL:sessionId] callback:^(NSDictionary *dictionary, NSURL *url) {
                
                NSLog(@"response %@", dictionary);
                
                [[NSUserDefaults standardUserDefaults] setObject:[[dictionary objectForKey:@"id"] stringValue] forKey:@"user_id"];
                
                NSLog(@"watchlistURL %@", [DownloadHelper getWatchlistUrl:sessionId :[[dictionary objectForKey:@"id"] stringValue]]);
                [ApiLoadService getResponseForURL:[DownloadHelper getWatchlistUrl:sessionId :[[dictionary objectForKey:@"id"] stringValue]] callback:^(NSDictionary *dictionary, NSURL *url) {
                    NSLog(@"watchlist %@", dictionary);
                    
                    if([[dictionary objectForKey:@"results"] count] < 1) //empty watchlist
                    {
                        [_indicator stopAnimating];
                        _sampleTableView.hidden = YES;
                        _emptyWatchlistView.hidden = NO;
                    }
                    else
                    {
                        [_indicator stopAnimating];
                        WatchlistHolder *holder = [[[WatchlistHolder alloc] init] autorelease];
                        
                        for (id watchFilm in [dictionary objectForKey:@"results"]){
                            [holder addFilm: [[watchFilm objectForKey:@"id"] stringValue]];
                        }
                        
                        NSLog(@"ids %@", [holder getWatchListIDs]);
                        
                        _sampleTableView.hidden = NO;
                        _emptyWatchlistView.hidden = YES;
                        _filmList = [ReviewFilm initWithDictionary:dictionary];
                        [_filmList retain];
                        [_sampleTableView reloadData];
                    }
                    
                }];
            }];
        }
        else //unauthorized user
        {
            [_indicator stopAnimating];
            _sampleTableView.hidden = YES;
            _emptyWatchlistView.hidden = YES;
            _unAuthorizedView.hidden = NO;
            
            UIBarButtonItem *accountItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                          target:self action:@selector(toggleAccount)] autorelease];
            self.navigationItem.leftBarButtonItem = accountItem;
            
            NSLog(@"unAuthorized user");
        }
    }
    else
    {
        _networkStatus.text = @"No access to Internet";
        [_indicator stopAnimating];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"viewDidAppear %d" , didAppearCount);
    ++didAppearCount;
    if (didAppearCount == didLoadCount) {
        ++didAppearCount;
    }
    else
    {
        didAppearCount++;
        [self viewDidLoad];
    }
}

#pragma mark -NetworkStatusDelegate

- (void) statusWasChanged: (NetworkStatusHelper*)helper
{
    if (helper.isNetworkConnection) {
        NSLog(@"status changed to YES");
        _networkStatus.hidden = YES;
        [self viewDidLoad];
    }
    else
    {
        _networkStatus.hidden = NO;
        NSLog(@"status changed to NO");
        NSLog(@"No interet");
        UIAlertView *notFound = [[UIAlertView alloc] initWithTitle: @"The MovieDataBase" message: @"No Internet Connection" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [notFound show];
        [notFound release];
    }
}

#pragma mark -TableView

- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected item %@", [tableView indexPathForSelectedRow]);
    
    if ([NetworkStatusHelper isInternetActive])
    {
        ReviewFilm *testFilm = (ReviewFilm*) _filmList[indexPath.row];
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellMainHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([_filmList count] < 1)
    {
        [_indicator stopAnimating];
        _emptyWatchlistView.hidden = NO;
        _sampleTableView.hidden = YES;
    }
    else
    {
        _sampleTableView.hidden = NO;
        _emptyWatchlistView.hidden = YES;
    }
    return [_filmList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"MyFeedCell";
    MainViewCell *cell;
    cell = (MainViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [ViewLoader loadView:[MainViewCell class]];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    ReviewFilm* testFilm = [_filmList objectAtIndex:indexPath.row];
    
    cell.filmTitle.text = testFilm.title;
    cell.filmYear.text = testFilm.yearRelease;
    cell.filmRating.text = testFilm.rating;
    
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
            [ImageHelper setRoundedBorder:cell.filmPoster];
            
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
    [_filmList retain];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [ApiLoadService actionWithWatchlist: NO :[[_filmList objectAtIndex:indexPath.row] filmId] callback:^(NSDictionary *dictionary) {
            NSLog(@"delete film response: \n%@", dictionary);
        }];
        
        [_filmList removeObjectAtIndex:[indexPath row]];
        [_sampleTableView reloadData];
    }
}


#pragma mark -ButtonTogles

- (void) toggleSearch
{
    NSLog(@"SearchButton is clicked");
    
    if ([NetworkStatusHelper isInternetActive]) {
        SearchViewController *searchController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
        [self.navigationController pushViewController:searchController animated:YES];
        [searchController release];
    }
    else
    {
        NSLog(@"No interet");
        UIAlertView *notFound = [[UIAlertView alloc] initWithTitle: @"The MovieDataBase" message: @"No Internet Connection" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [notFound show];
        [notFound release];
    }

}

- (void) toggleAccount
{
    if ([NetworkStatusHelper isInternetActive])
    {
        NSLog(@"AccountButton is clicked");
        WebViewController *webController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
        [self.navigationController pushViewController:webController animated:YES];
        [webController release];
    }
    else
    {
        NSLog(@"No interet");
        UIAlertView *notFound = [[UIAlertView alloc] initWithTitle: @"The MovieDataBase" message: @"No Internet Connection" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [notFound show];
        [notFound release];
    }
}

- (void) toggleLogOut
{
    // deleting all saved ids
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIAlertView *loggedOut = [[UIAlertView alloc] initWithTitle: @"The MovieDataBase" message: @"You were logged out" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
    
    [loggedOut show];
    [loggedOut release];
    [self viewDidLoad];
    
    NSLog(@"LogOut is clicked");
}

@end
