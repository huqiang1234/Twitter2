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

@interface EditTweetViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userScreenName;

@property (nonatomic, strong) User *user;

@end

@implementation EditTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.user = [User currentUser];
  [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
  self.userName.text = self.user.name;
  self.userScreenName.text = self.user.screenname;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
