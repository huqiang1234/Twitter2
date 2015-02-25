//
//  TweetsViewController.m
//  Twitter
//
//  Created by Charlie Hu on 2/18/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "EditTweetViewController.h"
#import "TweetDetailsViewController.h"
#import "SWRevealViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)onLogout;
- (void)onNew;
- (void)onRefresh;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.refreshControl = [[UIRefreshControl alloc] init];
  [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
  [self.tableView insertSubview:self.refreshControl atIndex:0];

  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  SWRevealViewController *srvc = [self revealViewController];
  [srvc panGestureRecognizer];
  [srvc tapGestureRecognizer];

  self.title = @"Home";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNew)];

  [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];

  self.tableView.estimatedRowHeight = 120;
  self.tableView.rowHeight = UITableViewAutomaticDimension;

  [[TwitterClient sharedInstance] homeTimeLineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
    self.tweets = tweets;
    //for (Tweet *tweet in self.tweets) {
    //  NSLog(@"image url: %@", tweet.user.profileImageUrl);
    //}
    [self.tableView reloadData];
  }];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLogout {
  [User logout];
}

- (void)onNew {
  EditTweetViewController *evc = [[EditTweetViewController alloc] init];
  [self.navigationController pushViewController:evc animated:YES];
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
  //TweetCell *cell = [[TweetCell alloc] init];
  cell.delegate = self;

  Tweet *tweet = self.tweets[indexPath.row];
  // NSLog(@"%@", tweet);
  [cell setTweet:tweet];

  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  TweetDetailsViewController *vc = [[TweetDetailsViewController alloc] init];
  [vc setTweet:self.tweets[indexPath.row]];
  [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark - UIRefreshControl

- (void)onRefresh {
  [[TwitterClient sharedInstance] homeTimeLineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
    self.tweets = tweets;
    //for (Tweet *tweet in self.tweets) {
    //  NSLog(@"image url: %@", tweet.user.profileImageUrl);
    //}
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
  }];
}

- (void)tweetCell:(TweetCell *)cell replyTo:(NSString *)screenName {
  EditTweetViewController *evc = [[EditTweetViewController alloc] init];
  [evc setText:[NSString stringWithFormat:@"@%@ ", screenName]];
  [self.navigationController pushViewController:evc animated:YES];
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
