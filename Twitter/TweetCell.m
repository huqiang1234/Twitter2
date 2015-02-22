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
#import "EditTweetViewController.h"
#import "TwitterClient.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinceWhenLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topRetweetImageView;
@property (weak, nonatomic) IBOutlet UILabel *topRetweetUserLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageViewTopConstaints;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewToRetweetIconConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NameToRetweetTextConstraint;

@property (nonatomic, strong) NSString *userScreenName;
@property (nonatomic, strong) NSString *idString;

- (void)updateElementConstaint:(id)view attribute:(NSLayoutAttribute)attribute relatedBy:(NSLayoutRelation)relatedBy constant:(CGFloat)constant;
- (void)setRetweet:(BOOL)isRetweet username:(NSString *)username;

-(void)updateDurationLabel:(NSDate *)date;

@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
  self.profileImageView.layer.cornerRadius = 3;
  self.profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
  [self setRetweet:tweet.isRetweet username:tweet.retweetUserName];
  [self.profileImageView setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
  self.nameLabel.text = tweet.user.name;
  self.userScreenName = tweet.user.screenname;
  self.idString = tweet.idString;
  self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.userScreenName];

  self.tweetTextLabel.text = tweet.text;
  [self updateDurationLabel:tweet.createdAt];
}

- (void)updateElementConstaint:(id)view attribute:(NSLayoutAttribute)attribute relatedBy:(NSLayoutRelation)relatedBy constant:(CGFloat)constant {
  [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:relatedBy toItem:self attribute:attribute multiplier:1 constant:constant]];
}

- (void)setRetweet:(BOOL)isRetweet username:(NSString *)username {
  if (isRetweet == NO) {
    //[self.topRetweetImageView removeFromSuperview];
    //[self.topRetweetUserLabel removeFromSuperview];
    self.topRetweetImageView.hidden = YES;
    self.topRetweetUserLabel.hidden = YES;
    [self removeConstraint:self.imageViewToRetweetIconConstraint];
    [self removeConstraint:self.NameToRetweetTextConstraint];
    [self updateElementConstaint:self.profileImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual constant:12];
    [self updateElementConstaint:self.nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual constant:1];
  } else {
    self.topRetweetImageView.hidden = NO;
    self.topRetweetUserLabel.hidden = NO;
    self.topRetweetUserLabel.text = [NSString stringWithFormat:@"%@ retweeted", username];
  }
}

-(void)updateDurationLabel:(NSDate *)date {
  //Which calendar
  NSString *durationString;
  NSCalendar *calendar = [NSCalendar currentCalendar];

  //Gets the componentized interval from the most recent time an activity was tapped until now

  NSDateComponents *components= [calendar components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date toDate:[NSDate date] options:0];
  NSInteger days = [components day];
  NSInteger hours = [components hour];
  NSInteger minutes = [components minute];
  NSInteger seconds =[components second];

  // Converts the components to a string and displays it in the duration label, updated via the timer

  if (days > 0) {
    durationString = [NSString stringWithFormat:@"%ldd", (long)days];
  } else if (hours > 0) {
    durationString = [NSString stringWithFormat:@"%ldh", (long)hours];
  } else if (minutes > 0) {
    durationString = [NSString stringWithFormat:@"%ldm", (long)minutes];
  } else if (seconds > 0) {
    durationString = [NSString stringWithFormat:@"%lds", (long)seconds];
  }

  self.sinceWhenLabel.text = durationString;
}

- (IBAction)onReply:(id)sender {
  [self.delegate tweetCell:self replyTo:self.userScreenName];
}

- (IBAction)onRetweet:(id)sender {
  [[TwitterClient sharedInstance] postReTweet:self.idString completion:^(NSError *error) {
    if (error == nil) {
      NSLog(@"Retweeted, %@", self.idString);
    } else {
      NSLog(@"error posting tweet, %@", error);
    }
  }];
}

- (IBAction)onFavorite:(id)sender {
  NSDictionary *params = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:self.idString, nil] forKeys:[NSArray arrayWithObjects:@"id", nil]];
  [[TwitterClient sharedInstance] favoriteTweet:params completion:^(NSError *error) {
    if (error == nil) {
      NSLog(@"Favorited tweet, %@", self.idString);
    } else {
      NSLog(@"error posting tweet, %@", error);
    }
  }];

}

@end
