//
//  TweetDetailsViewController.m
//  Twitter
//
//  Created by Charlie Hu on 2/21/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "EditTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface TweetDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *topRetweetIconView;
@property (weak, nonatomic) IBOutlet UILabel *topRetweetUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countRetweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *countFavoriteLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profileImageToRetweetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameToRetweetNameConstraint;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userScreenName;
@property (nonatomic, strong) NSString *profileImageURLString;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) BOOL isRetweet;
@property (nonatomic, strong) NSString *retweetUserName;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *idString;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger retweetCount;

- (void)onReply;
- (void)setRetweet:(BOOL)isRetweet username:(NSString *)username;
- (void)updateElementConstaint:(id)view attribute:(NSLayoutAttribute)attribute relatedBy:(NSLayoutRelation)relatedBy constant:(CGFloat)constant;

- (void)updateViewUI;

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

  self.title = @"Tweet";

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReply)];

  [self updateViewUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

- (void)onReply {
  EditTweetViewController *evc = [[EditTweetViewController alloc] init];
  [evc setText:[NSString stringWithFormat:@"@%@ ", self.userScreenName]];
  [self.navigationController pushViewController:evc animated:YES];
}

- (IBAction)onReplyButton:(id)sender {
  [self onReply];
}

- (IBAction)onRetweetButton:(id)sender {
  [[TwitterClient sharedInstance] postReTweet:self.idString completion:^(NSError *error) {
    if (error == nil) {
      NSLog(@"Retweeted, %@", self.idString);
    } else {
      NSLog(@"error posting tweet, %@", error);
    }
  }];
}

- (IBAction)onFavoriteButton:(id)sender {
  NSDictionary *params = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:self.idString, nil] forKeys:[NSArray arrayWithObjects:@"id", nil]];
  [[TwitterClient sharedInstance] favoriteTweet:params completion:^(NSError *error) {
    if (error == nil) {
      NSLog(@"Favorited tweet, %@", self.idString);
    } else {
      NSLog(@"error posting tweet, %@", error);
    }
  }];
}

- (void)updateViewUI {
  [self setRetweet:self.isRetweet username:self.retweetUserName];
  [self.profileImageView setImageWithURL:[NSURL URLWithString:self.profileImageURLString]];
  self.userNameLabel.text = self.username;
  self.userScreenNameLabel.text = self.userScreenName;
  self.tweetTextLabel.text = self.text;

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"mm/dd/yy HH:mm";
  self.tweetDateLabel.text = [formatter stringFromDate:self.createdAt];

  self.countFavoriteLabel.text = [NSString stringWithFormat:@"%ld Favorites", (long)self.favoriteCount];
  self.countRetweetLabel.text = [NSString stringWithFormat:@"%ld Retweets", (long)self.retweetCount];

}

- (void)setTweet:(Tweet *)tweet {
  //self.tweet = [[Tweet alloc] init];

  self.username = tweet.user.name;
  self.userScreenName = tweet.user.screenname;
  self.profileImageURLString = tweet.user.profileImageUrl;
  self.createdAt = tweet.createdAt;
  self.isRetweet = tweet.isRetweet;
  self.retweetUserName = tweet.retweetUserName;
  self.idString = tweet.idString;
  self.text = tweet.text;
  self.favoriteCount = tweet.favoriteCount;
  self.retweetCount = tweet.retweetCount;
}

- (void)updateElementConstaint:(id)view attribute:(NSLayoutAttribute)attribute relatedBy:(NSLayoutRelation)relatedBy constant:(CGFloat)constant {
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:relatedBy toItem:self.view attribute:attribute multiplier:1 constant:constant]];
}

- (void)setRetweet:(BOOL)isRetweet username:(NSString *)username {
  if (isRetweet == NO) {
    //[self.topRetweetImageView removeFromSuperview];
    //[self.topRetweetUserLabel removeFromSuperview];
    self.topRetweetIconView.hidden = YES;
    self.topRetweetUserLabel.hidden = YES;
    [self.view removeConstraint:self.profileImageToRetweetConstraint];
    [self.view removeConstraint:self.nameToRetweetNameConstraint];
    [self updateElementConstaint:self.profileImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual constant:90];
    [self updateElementConstaint:self.userNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual constant:100];
  } else {
    self.topRetweetIconView.hidden = NO;
    self.topRetweetUserLabel.hidden = NO;
    self.topRetweetUserLabel.text = [NSString stringWithFormat:@"%@ retweeted", username];
  }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
