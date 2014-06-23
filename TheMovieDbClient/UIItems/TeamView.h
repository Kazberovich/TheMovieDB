//
//  TeamView.h
//  TheMovieDbClient
//
//  Created by mac-214 on 10.02.14.
//  Copyright (c) 2014 mac-214. All rights reserved.
//

#import <Foundation/Foundation.h>
#define teamViewHeight 95.0f

@interface TeamView : UIView

@property (nonatomic, retain) IBOutlet UILabel *director;
@property (nonatomic, retain) IBOutlet UILabel *actors;

- (void) fillBlock: (NSDictionary*) fillData;

@end
