//
//  EditTweetViewController.m
//  Twitter
//
//  Created by Charlie Hu on 2/21/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "EditTweetViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface EditTweetViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userScreenName;
@property (weak, nonatomic) IBOutlet UITextView *tweetEditView;
@property (weak, nonatomic) IBOutlet UILabel *charsLeftLabel;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *prefixText;

-(void)onTweet;

@end

@implementation EditTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.tweetEditView.delegate = self;

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweet)];

  self.user = [User currentUser];
  [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
  self.userName.text = self.user.name;
  self.userScreenName.text = self.user.screenname;

  self.tweetEditView.editable = YES;
  [self.tweetEditView becomeFirstResponder];
  self.tweetEditView.text = self.prefixText;
  self.tweetEditView.selectedRange = NSMakeRange(self.prefixText.length, 0);
  self.charsLeftLabel.text = [NSString stringWithFormat:@"%ld", (long)(140 -self.prefixText.length)];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTweet {
  NSString *tweetText = self.tweetEditView.text;
  NSDictionary *params = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:tweetText, nil] forKeys:[NSArray arrayWithObjects:@"status", nil]];
  [[TwitterClient sharedInstance] postTweet:params completion:^(NSError *error) {
    if (error == nil) {
      NSLog(@"Posted tweet, %@", tweetText);
    } else {
      NSLog(@"error posting tweet, %@", error);
    }
  }];
  [self.navigationController popToRootViewControllerAnimated:TRUE];
}

- (void)setText:(NSString *)text {
  self.prefixText = text;
}

#pragma mark - text view delegate methods

- (void)textViewDidChange:(UITextView *)textView {
  NSInteger charsLeft = 140 - textView.text.length;
  self.charsLeftLabel.text = [NSString stringWithFormat:@"%ld", (long)charsLeft];
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
