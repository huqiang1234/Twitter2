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

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tweets;

- (void)onLogout;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.tableView.delegate = self;
  self.tableView.dataSource = self;

  self.title = @"Home";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];

  [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];

  self.tableView.estimatedRowHeight = 150;
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

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];

  Tweet *tweet = self.tweets[indexPath.row];
  NSLog(@"%@", tweet);
  [cell setTweet:tweet];

  return cell;
}

/*
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
  [cell setTweet:self.tweets[indexPath.row]];
  CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  return size.height + 1;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
