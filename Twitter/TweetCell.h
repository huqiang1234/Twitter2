//
//  TweetCell.h
//  Twitter
//
//  Created by Charlie Hu on 2/20/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)tweetCell:(TweetCell *)cell replyTo:(NSString *)screenName;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, weak) id<TweetCellDelegate> delegate;

- (void)setTweet:(Tweet *)tweet;

@end
