//
//  DetailViewController.h
//  TheMovieDbClient
//
//  Created by mac-214 on 23.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewFilm.h"

@interface DetailViewController : UIViewController

@property (nonatomic, retain) UIView  *myView;
@property (nonatomic, retain) UIButton *myButton;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) ReviewFilm *film;

@end
