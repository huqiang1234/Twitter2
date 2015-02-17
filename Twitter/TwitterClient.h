//
//  TwitterClient.h
//  Twitter
//
//  Created by Charlie Hu on 2/16/15.
//  Copyright (c) 2015 Charlie Hu. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

@end
