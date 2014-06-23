//
//  DetailViewController.m
//  TheMovieDbClient
//
//  Created by mac-214 on 23.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import "DetailViewController.h"
#import "ViewLoader.h"
#import "FilmHeaderView.h"
#import "DescriprionView.h"
#import "DownloadHelper.h"
#import "ApiLoadService.h"
#import "TeamView.h"
#import "BackDropsView.h"
#import "SimilarMoviesView.h"
#import "WatchlistHolder.h"
#import "NetworkStatusHelper.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize myButton = _myButton;
@synthesize myView = _myView;
@synthesize scrollView = _scrollView;
@synthesize film = _film;

- (void) dealloc
{
    [_myButton release];
    [_myView release];
    [_scrollView release];
    [_film release];
    [super dealloc];
}

- (void)viewDidLoad
{
    
    WatchlistHolder *holder = [[[WatchlistHolder alloc] init] autorelease];
    
    NSLog(@"ids %@", [holder getWatchListIDs]);
    NSLog(@"ddd %@", _film.filmId);
    
    if ([[holder getWatchListIDs] count] < 1) {
        UIBarButtonItem *addItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self action:@selector(toggleAddFilm)] autorelease];
        self.navigationItem.rightBarButtonItem = addItem;
    }
    else
    {
        for (id filmId in [holder getWatchListIDs]) {
            
            if([filmId isEqualToString:_film.filmId])
            {
                UIBarButtonItem *removeItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                            target:self action:@selector(toggleDeleteFilm)] autorelease];
                self.navigationItem.rightBarButtonItem = removeItem;
                break;
            }
            else
            {
                UIBarButtonItem *addItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                            target:self action:@selector(toggleAddFilm)] autorelease];
                self.navigationItem.rightBarButtonItem = addItem;
            }
        }
    }    

    self.navigationItem.title = _film.title;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.userInteractionEnabled = YES;

//Header Block
    
    FilmHeaderView* filmHeader = [ViewLoader loadView:[FilmHeaderView class] fromNibNamed:@"FilmHeaderView"];
    filmHeader.frame = CGRectMake(0.0f, 0.0 + 20.0f, self.view.bounds.size.width, headerHeight);
    [filmHeader fillHeader:_film];

    
//Description Block
    
    DescriprionView  *description = [ViewLoader loadView:[DescriprionView class] fromNibNamed:@"DescriptionView"];
    description.frame = CGRectMake(0.0f, filmHeader.bounds.size.height + 20.0f, self.view.bounds.size.width, descriptionHeight);
    [_scrollView addSubview:description];

    [ApiLoadService getResponseForURL:[NSURL URLWithString:[DownloadHelper getBasicMovieInformationUrl:_film.filmId]] callback:^(NSDictionary *dictionary, NSURL *url) {
        [description fillBlock:dictionary];
        if(![[dictionary objectForKey:@"runtime"] isEqual:[NSNull null]])
        {
            [filmHeader setFilmDuration:[[dictionary objectForKey:@"runtime"] stringValue]];
        }
        else
        {
            [filmHeader setFilmDuration: @"  0"];
        }
    }];
    
    [_scrollView addSubview:filmHeader];
    _scrollView.contentSize = self.view.bounds.size;
    
//Team Block
    
    TeamView *teamBlock = [ViewLoader loadView:[TeamView class]];
    teamBlock.frame = CGRectMake(0.0f,
                                 filmHeader.bounds.size.height + 20.0f + description.bounds.size.height,
                                 self.view.bounds.size.width,
                                 teamViewHeight);
    [_scrollView addSubview:teamBlock];
    
    [ApiLoadService getResponseForURL:[NSURL URLWithString:[DownloadHelper getTeamMovieUrlForId:_film.filmId]] callback:^(NSDictionary *dictionary, NSURL *url) {
        //NSLog(@"team: %@", dictionary);
        [teamBlock fillBlock:dictionary];
        
    }];
    
//Backdrops Block
    
    BackDropsView *backdrops = [ViewLoader loadView:[BackDropsView class]];
    backdrops.frame = CGRectMake(0.0f,
                                 filmHeader.bounds.size.height + 20.0f + description.bounds.size.height + teamBlock.bounds.size.height,
                                 self.view.bounds.size.width,
                                 backdropsHeigh);
    [_scrollView addSubview:backdrops];
    
    [ApiLoadService getResponseForURL:[NSURL URLWithString:[DownloadHelper getBackdropsUrlForId:_film.filmId]] callback:^(NSDictionary *dictionary, NSURL *url) {
        [backdrops fillBlock:dictionary];
    }];
    
//SimilarMovies Block
    
    SimilarMoviesView *similarMoviesView = [ViewLoader loadView:[SimilarMoviesView class]];
    similarMoviesView.frame = CGRectMake(0.0f,
                                        filmHeader.bounds.size.height + 20.0f + description.bounds.size.height
                                         + teamBlock.bounds.size.height + backdropsHeigh,
                                        self.view.bounds.size.width,
                                        similarMoviesHeight);
    [_scrollView addSubview:similarMoviesView];
    
    [ApiLoadService getResponseForURL:[NSURL URLWithString:[DownloadHelper getSimilarMoviesURLForId:_film.filmId]] callback:^(NSDictionary *dictionary, NSURL *url) {
        [similarMoviesView fillBlock:dictionary];
    }];
    
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, headerHeight + descriptionHeight + teamViewHeight + backdropsHeigh + similarMoviesHeight + 20.0);
   
    [super viewDidLoad];
}

- (void) toggleAddFilm
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"session_id"]) {
        
        if ([NetworkStatusHelper isInternetActive])
        {
            [ApiLoadService actionWithWatchlist:YES :_film.filmId callback:^(NSDictionary *dictionary) {
                NSLog(@"add film response: \n%@", dictionary);
            }];
            
            [[WatchlistHolder sharedInstance] addFilm:_film.filmId];
            
            UIBarButtonItem *removeItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                         target:self action:@selector(toggleDeleteFilm)] autorelease];
            self.navigationItem.rightBarButtonItem = removeItem;
        }
        else
        {
            NSLog(@"No interet");
            UIAlertView *notFound = [[UIAlertView alloc] initWithTitle: @"The MovieDataBase" message: @"No Internet Connection" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [notFound show];
            [notFound release];
        }


    }
    else
    {
        UIAlertView *notAuthorized = [[UIAlertView alloc] initWithTitle: @"The MovieDataBase" message: @"You are not authorized. Log in to have access to Watchlist" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [notAuthorized show];
        [notAuthorized release];
    }
}

- (void) toggleDeleteFilm
{
    
    if ([NetworkStatusHelper isInternetActive])
    {
        [ApiLoadService actionWithWatchlist: NO :_film.filmId callback:^(NSDictionary *dictionary) {
            NSLog(@"delete film response: \n%@", dictionary);
            
        }];
        
        [[WatchlistHolder sharedInstance] deleteFilm:_film.filmId];
        
        UIBarButtonItem *addItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self action:@selector(toggleAddFilm)] autorelease];
        self.navigationItem.rightBarButtonItem = addItem;
    }
    else
    {
        NSLog(@"No interet");
        UIAlertView *notFound = [[UIAlertView alloc] initWithTitle: @"The MovieDataBase" message: @"No Internet Connection" delegate: self.navigationController cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [notFound show];
        [notFound release];
    }    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
