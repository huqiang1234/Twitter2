//
//  LoginViewController.m
//  Twitter
//
//  Created by Charlie Hu on 2/16/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TweetsViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)onLogin:(id)sender {
  [[TwitterClient sharedInstance] loginWithCompletion:^(User *user, NSError *error) {
    if (user != nil) {
      // tweets view
      NSLog(@"Welcome: %@", user.name);
      [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[TweetsViewController alloc] init]] animated:YES completion:nil];
    } else {
      // error view
    }
  }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.title = @"Login";
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
