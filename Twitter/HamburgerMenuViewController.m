//
//  HamburgerMenuViewController.m
//  Twitter
//
//  Created by Charlie Hu on 2/24/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "HamburgerMenuViewController.h"
#import "SWRevealViewController.h"
#import "ProfileViewController.h"
#import "TweetsViewController.h"

@interface HamburgerMenuViewController ()

@property (nonatomic, weak) SWRevealViewController *srvc;
@property (nonatomic, strong) ProfileViewController *pvc;
@property (nonatomic, strong) TweetsViewController *vc;

- (IBAction)onButton1:(id)sender;
- (IBAction)onButton2:(id)sender;
@end

@implementation HamburgerMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.srvc = [self revealViewController];
  self.pvc = [[ProfileViewController alloc] init];
  self.vc = [[TweetsViewController alloc] init];

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

- (IBAction)onButton1:(id)sender {
  [self.srvc setFrontViewController:self.pvc animated:YES];
}

- (IBAction)onButton2:(id)sender {
  [self.srvc setFrontViewController:self.vc animated:YES];
}
@end
