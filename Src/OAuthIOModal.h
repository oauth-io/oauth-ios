/*
 * (C) Copyright 2013 Webshell SAS.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import <UIKit/UIKit.h>
#import "OAuthIORequest.h"
#import "OAuthIO.h"

#define NAVIGATION_BAR_HEIGHT_IOS7_OR_LATER     64
#define NAVIGATION_BAR_HEIGHT_IOS6_OR_EARLIER   44

@protocol OAuthIODelegate <NSObject>

- (void)didReceiveOAuthIOResponse:(NSDictionary *)result;
- (void)didFailWithOAuthIOError:(NSError *)error;

@end

@interface OAuthIOModal : UIViewController<UIWebViewDelegate>
{
    NSString            *_key;
    NSString            *_scheme;
    NSString            *_callback_url;
    OAuthIO             *_oauth;
    UIViewController    *_rootViewController;
    NSUInteger          _navigationBarHeight;
}

@property (nonatomic, retain) id<OAuthIODelegate>   delegate;
@property (nonatomic, retain) NSString              *provider;
@property (nonatomic, retain) UINavigationBar       *navigationBar;
@property (nonatomic, retain) IBOutlet UIWebView    *browser;

+ (void) handleOAuthIOResponse:(NSURL *)url;

- (id)initWithKey:(NSString *)key delegate:(id)delegate;
- (void)showWithProvider:(NSString *)provider;

@end
