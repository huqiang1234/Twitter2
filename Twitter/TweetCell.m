//
//  TweetCell.m
//  Twitter
//
//  Created by Charlie Hu on 2/20/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "Tweet.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinceWhenLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;


@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
  self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
  [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
  self.nameLabel.text = tweet.user.name;
  self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.user.screenname];

  self.sinceWhenLabel.text = [NSString stringWithFormat:@"%d m", 38];
  self.tweetTextLabel.text = tweet.text;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

@end
