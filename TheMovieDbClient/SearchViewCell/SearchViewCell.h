//
//  SearchViewCell.h
//  TheMovieDbClient
//
//  Created by mac-214 on 24.01.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <UIKit/UIKit.h>

#define cellSearchHeight 40.0;

@interface SearchViewCell : UITableViewCell

@property(nonatomic, retain) IBOutlet UIImageView* filmPoster;
@property(nonatomic, retain) IBOutlet UILabel* filmYear;
@property(nonatomic, retain) IBOutlet UILabel* filmRating;
@property(nonatomic, retain) IBOutlet UITextView* filmTitle;

@end
