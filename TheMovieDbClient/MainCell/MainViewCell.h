//
//  MainViewCell.h
//  TheMovieDbClient
//
//  Created by mac-214 on 22.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <UIKit/UIKit.h>

#define cellMainHeight 120.0;

@interface MainViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UIImageView* filmPoster;
@property(nonatomic, retain) IBOutlet UILabel* filmYear;
@property(nonatomic, retain) IBOutlet UILabel* filmGenre;
@property(nonatomic, retain) IBOutlet UILabel* filmRating;
@property(nonatomic, retain) IBOutlet UITextView* filmTitle;
@property (nonatomic, retain) NSURL *posterUrl;

@end
